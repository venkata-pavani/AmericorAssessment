/*------ 3.	For staff member 4462, please provide the count of the top 3 most recent client statuses
, as of 12/14/2020, from customer_action table. Tip: use new values to summarize-----------------**/
with cte as (
select log_id,new_value,crm_object_description as client_status 
,rank() over( order by count(new_value)) as StatusCount  /** SUMMARIZING NEW VLAUES TO FIND THEIR COUNT**/
 from [dbo].[customer_action - customer_action] as ca
inner join [dbo].[crm_dictionary - crm_dictionary] as cd on ca.new_value = cd.crm_object_id
where user_id = 4462 and crm_object_name = 'customer' and CAST(ins_ts as date) <= '2020-12-14' 
group by new_value,crm_object_description,log_id ) 
select client_status,count(StatusCount)  as TotalStatusCount 
from cte where client_status in (select top 3 client_status from cte order by log_id desc) /** SELECTING THE RECENT 3 CLIENT STATUSES AS OF GIVEN DATE**/
group by client_status 


/**
select * , CAST (ins_ts as date) as date from [dbo].[customer_action - customer_action]  where user_id = 4462
and CAST(ins_ts as date) <= '2020-12-14' 
 order by ins_ts desc**/
