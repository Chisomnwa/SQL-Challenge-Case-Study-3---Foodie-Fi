-- A. Customer Journey

/*Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief
description about each customer’s onboarding journey.Try to keep it as short as possible - you may also
want to run some sort of join to make your explanations a bit easier!*/

-- first let's see what the plans table looks like
SELECT * 
FROM plans;

-- secondly let's see what the subscriptions table looks like
SELECT TOP 5 *
FROM subscriptions;

/*
Steps to answering the question:
*The sample customer_id given in the sample subscription table are 1, 2, 11, 13, 15, 16, 18, 19. 
*Create a base table with the following columns: customer_id, plan_id, plan_name, start_date.
*Order by Customer_id
*/

--selecting the unique customers based on the sample from the subscriptions table
SELECT s.customer_id,
	   p.plan_id, 
	   p.plan_name, 
	   s.start_date
FROM plans AS p
INNER JOIN subscriptions AS s
ON p.plan_id = s.plan_id
WHERE s.customer_id IN (1,2,11,13,15,16,18,19);-- selected 8 unique customers;

/*

Brief description on the customers journey based on the results from the above query:

Customer 1 starts with a free trial plan on 2020-08-01 and when the trial ends, upgrades to basic monthly plan on 2020-08-08

Customer 2 starts with a free trial plan on 2020-09-20 and when the trial ends, upgrades to pro annual plan on 2020-09-27

Customer 11 starts with free trial plan on 2020-11-19 and churns at the end of the free trial plan on 2020-11-26

Customer 13 starts with free trial plan on 2020-15-12 and when the trial ends subscribes to a basic monthly plan on the
2020-12-22, and 3 months later upgrades to a pro monthly plan on 2021-03-29

Customer 15 starts with a free trial plan on 2020-03-17, and when the trail ends automatically upgrades to the pro monthly plan on
2020-03-24 and then churns one month later on 2020-04-29

Customer 16 starts with a free trial plan on 2020-05-31, and when the trial ends, subscribes to a basic monthly plan on 2020-06-07 
and 4 months later upgrades to a pro annual plan on 2020-10-21

Customer 18 starts with a free trial plan on 2020-07-06 and when the trial ends, automatically upgrades to pro monthly plan on
the 2020-07-13

Customer 19 starts with a free trial plan on 2020-06-22, automatically ugrades to pro monthly on 2020-06-29, and 2 months later
upgrades to pro annual plan on 2020-08-29

*/