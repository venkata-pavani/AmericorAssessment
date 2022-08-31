with sales_teams as (select tt.id as team_id , tt.name as team from [dbo].[team - team] as tt
left join [dbo].[department - department] as dt 
on tt.department_id = dt.id
where dt.title = 'Sales')

select count(distinct user_id) as head_count,st.team 
from sales_teams as st left join [dbo].[user_team - user] as ut  on st.team_id = ut.team_id
where cast(updated_at as date) <= '2019-12-14'
group by st.team_id,team

union 


select 0 as head_count,st.team from sales_teams as st 
where st.team_id not in (select team_id from [dbo].[user_team - user] where cast(updated_at as date) <= '2019-12-14')




--select * from [dbo].[user_team - user] where cast(updated_at as date) <= '2019-12-14' and team_id = 73

