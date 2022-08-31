# Americor Assessment 

### 1. Question1

a. Calculated the frequency of new values using count() and sum() functions for summarizing the new value <br>
b. Used Rank function to find the most frquenct values that are summarized through COUNT() <br>
3. Lag() function to find the previous month count value <br>
4. Calculated MoM Percentage using this formula ((month 1 count - previous month count)/previous month count)*100 <br>
5. Merged with Teams and Department table to find the team name and the department for each staff member <br>

### 2.Question 2 

I have two ways of thoughts on implemention this Question as "Top 3 Action Changes" seemed to be generic 
I thought of calculating top 3 action chnaged using RANK Function by using log id <br> 
BUT I need to come up with MoM percentage.so I implemnted below logic as it made more sense 

a. Extracted all the departments in the Department Table <br>
b. Merged with customer action table <br>
c. Using RANK() function I extracted the top 3 actions that were chnaged frequently <br>
d. Calculated MoM Percentage using this formula ((month 1 count - previous month count)/previous month count)*100 <br>

### Question 3

Implemented the most recent top 3 client statuses by extracting the recent logs as for the given date <br>

### Question 4

Extracted all the teams in the SALES deaprtment  and merged with the USERTEAM table to find the head count of all staff members

*Some prior findinds to understand data

![image](https://user-images.githubusercontent.com/12963112/187609758-5c94e7f7-e9bc-435c-8afa-833a4976c089.png)


