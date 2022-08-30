with cte as ( select 
 ca.user_id,month(ins_ts) as month,new_value,count(new_value) as cnt
from
[dbo].[customer_action - customer_action] as ca
group by user_id,ins_ts,new_value
--having user_id = 4033  and month(ins_ts) in( 11,12)
)
,cte2 as (
select user_id,month,count(cnt) as ActionCount
,rank() over (partition by user_id,month order by sum(cnt) desc)  as rnk /** rank function finds out  top 3 frequent (through total count) new values for userid and month**/
from cte 
group by user_id,month,new_value)
,cte3 as (
select user_id,month,sum(ActionCount) as TotalActionCount
,COALESCE(lag(sum(ActionCount)) over (partition by user_id order by month),0) as prev_count
from cte2 
where rnk <=3 group by user_id,month)
select k.user_id,month,TotalActionCount,prev_count,tt.name as Team,dt.title as Department
,ROUND(CAST(100*(CASE WHEN prev_count = 0 THEN 0 ELSE 1.0*(TotalActionCount-prev_count)/prev_count END) AS numeric(12,2)),2) AS MoM_percentage

from cte3 as k left join [dbo].[user_team - user] as ut on ut.user_id = k.user_id
left join [dbo].[team - team] as tt on tt.id = ut.team_id
inner  join [dbo].[department - department] as dt on dt.id = tt.department_id /**elimating staff that are not in any departmentas of today**/
where year(ut.updated_at) <= 2020  /** searching for all those staff members whose team id updated or relevant on or before 2020**/
--and dt.id IS NOT NULL
order by user_id,month
