/****** Script for SelectTopNRows command from SSMS  ******/
with dept as (
select distinct dt.id ,dt.title as department,tt.id as teamid from [dbo].[department - department] as dt 
left join [dbo].[team - team]  as tt on dt.id = tt.department_id where tt.name IS NOT NULL) /**eliminating those records with no teams as we use this team id for join**/
,cte as (
select dt.department , ut.user_id as user_id 
from dept as dt
left join [dbo].[user_team - user] as ut on dt.teamid = ut.team_id where ut.user_id IS NOT NULL) /** eliminating those records with no users**/
/**TOP 3 ACTION CHANGES --> TOP 3 OLD VALUES THAT WERE CHANGED FREQUENTLY --> I CHOSE THIS AS IT MAKES SENSE TO CALCULATE MoM percentage on this **/
,cte1 as (
select  department,ca.ins_ts,month(ca.ins_ts) as month,ca.log_id,ca.old_value,ca.new_value from cte as c 
left join [dbo].[customer_creditor_action - customer_creditor_action] as ca on ca.user_id = c.user_id 
where log_id IS NOT NULL)
,cte2 as(
select department , month , old_value,count(old_value) as cnt from cte1
group by department , month,old_value)
,cte3 as (
select department, month , old_value,sum(cnt) as TotalActionChange 
,rank() over (partition by department,month order by sum(cnt) desc) as rnk
from cte2 group by department,month,old_value)
,cte4 as (
select department,month,old_value,sum(TotalActionChange) as TotalActionCount
,COALESCE(lag(sum(TotalActionChange)) over (partition by department,old_value order by old_value,month),0) as prev_count
from cte3 where rnk <=3 group by department,month,old_value)

select department , month,old_value as actiontochange,crm_object_description as actiontochangestatus
,TotalActionCount,prev_count,ROUND(CAST(100*(CASE WHEN prev_count = 0 THEN 0 ELSE 1.0*(TotalActionCount-prev_count)/prev_count END) AS numeric(12,2)),2) AS MoM_percentage
from cte4 left join [dbo].[crm_dictionary - crm_dictionary] as crm on cte4.old_value = crm.crm_object_id
where crm.crm_object_name like 'customer_creditor'
 