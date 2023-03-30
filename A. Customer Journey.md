# <p align="center" style="margin-top: 0px;"> 🥑 Case Study #3 - Foodie-Fi 🥑

## A. Customer Journey

*Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief
description about each customer’s onboarding journey.Try to keep it as short as possible - you may also
want to run some sort of join to make your explanations a bit easier!*

### Steps to answering the question:

- The sample customer_id given in the sample subscription table are 1, 2, 11, 13, 15, 16, 18, 19. 

- Create a base table with the following columns: customer_id, plan_id, plan_name, start_date.

- Order by Customer_id

```sql
--selecting the unique customers based on the sample from the subscriptions table
SELECT s.customer_id,
	   p.plan_id, 
	   p.plan_name, 
	   s.start_date
FROM plans AS p
INNER JOIN subscriptions AS s
ON p.plan_id = s.plan_id
WHERE s.customer_id IN (1,2,11,13,15,16,18,19);-- selected 8 unique customers;
```

