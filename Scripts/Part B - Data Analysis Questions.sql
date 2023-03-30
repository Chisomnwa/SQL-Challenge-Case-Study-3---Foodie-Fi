-- B. Data Analysis Questions

-- 1. How many customers has Foodie-Fi ever had?

-- use the DISTINCT function to find the number of Foodie Fi's unique customers

SELECT COUNT(DISTINCT customer_id) AS customer_count
FROM subscriptions;

-- Foodie-Fi has 1000 unique customers.


-- 2. What is the monthly distribution of trial plan start_date values for our dataset
-- use the start of the month as the group by value

/*
Steps:
* Extract the months from start_date column
* COUNT the total number of plan_ids for each month
* And filter for where plan_name is Trial
*/

SELECT month(start_date) AS months,
	   COUNT(s.plan_id) AS total_plans
FROM subscriptions AS s
INNER JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE plan_name = 'trial'
GROUP BY month(start_date)
ORDER BY COUNT(s.plan_id) DESC

-- March has the highest number of trial plans, whereas February has the lowest number of trial plans.


-- 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

/*
Steps:
Question is asking for the number of plans for start dates occurring in 2021 and after grouped by plan names.

* Filter plans with start_dates occurring after 2020-12-31
* Group and order results by plan.
*/

SELECT p.plan_name, 
	   p.plan_id,
	   COUNT(*) AS event_2021
FROM plans AS p
INNER JOIN  subscriptions AS s
ON p.plan_id = s.plan_id
WHERE s.start_date >= '2021-01-01'
GROUP BY p.plan_id, p.plan_name
ORDER BY p.plan_id;

/*
The result above showed that there was no trial plan recorded in 2021 and I was curious and ran the below 
query for 2020 and 2021 so I could understand the year-on-year results.
*/


WITH events_2020 AS 
(
SELECT plan_id,
	   COUNT(*) AS event_2020
FROM subscriptions
WHERE start_date <= '2020-12-31'
GROUP BY plan_id
),

events_2021 AS (
SELECT plan_id,
	   COUNT(*) AS event_2021
FROM subscriptions
WHERE start_date >= '2021-01-01'
GROUP BY plan_id
)

SELECT COALESCE(e20.plan_id, e21.plan_id) AS plan_id, COALESCE(event_2020, 0) AS event_2020, COALESCE(event_2021, 0) AS event_2021
FROM events_2020 e20
FULL OUTER JOIN events_2021 e21
ON e20.plan_id = e21.plan_id
ORDER BY plan_id;

/*
The result shows there was no free trial in 2020. Could it be that the old customers from 2020 continued with their 
subscriptions in 2021, that customers upgraded from one paid trial to another, or that customers signed up 
for paid plans without going through the trial plan?
*/


-- 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

/*
Steps:
* Count the total number of customers
* Get the percentage of customers by diving total customers with distinct number of customers and round it to 1 decimal place.
* Filter for where the plan_id is 4 which is Trial
*/

SELECT COUNT(*) AS customer_count,
	   ROUND((CAST(COUNT(*) AS FLOAT) / (SELECT COUNT(DISTINCT customer_id) FROM  subscriptions)) * 100, 1) AS churn_percentage
FROM subscriptions
WHERE plan_id = 4;

-- 307 customers, or 30.7% of the total customers, have churned from Food-fi during the period of analysis.


-- 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

/*
Steps:
* use lag function to create a new column called "previous_plan" which stores the plan_id of the previous
  subscription plan for each customer.	
* get the total number of rows in the previous_plan column
* get the perecentage of customers and round to the nearest whole number
* Using the cte_churn CTE, filter for rows with plan_id of 4 (churn_plan) and previous_plan of 0(trial plan)
*/

WITH cte_churn AS 
(
-- use lag function to look at the previous row in the plan_id column resulting in previous_plan column
SELECT *,
	   LAG(plan_id, 1) OVER(PARTITION BY customer_id ORDER BY plan_id) AS previous_plan
FROM subscriptions
)
SELECT COUNT(previous_plan) AS churn_count, 
	   ROUND(COUNT(*) * 100 / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 0) AS percentage_churn
FROM cte_churn
WHERE plan_id = 4 and previous_plan = 0;


-- OR Using this second method

/*
Steps:
* In order to identify which customer churned straight after the trial plan, rank each customer''s plan using a ROW_NUMBER.
  Remember to partition by unique customer.
* My understanding is that if a customer churned immediately after trial, the plan ranking would look like this.

Trial Plan - Rank 1
Churned - Rank 2

* Using the CTE, filter for plan_id = 4 (churn plan) and rank = 2 (being customers who churned immediately after trial)
* Find the percentage of churned customers.
*/

-- To find ranking of the plans by customers and plans
WITH ranking AS (
SELECT s.customer_id,
	   s.plan_id,
	   p.plan_name,
	   -- run a ROW_NUMBERto rank the plans from 0 to 4
	   ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY s.plan_id) AS plan_rank
FROM subscriptions s
INNER JOIN plans p
ON s.plan_id = p.plan_id
)

SELECT COUNT(*) AS churn_count,
	   ROUND(100 * COUNT(*) / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 0) AS churn_percentage
FROM ranking
WHERE plan_id = 4 -- filter to churn plan
	   AND plan_rank = 2 -- filter to rank 2 as customers who churned imediately after the trial plan

-- There are 92 customers who churned immediately after their initial trial which is at 9% entire customer base.


-- 6. What is the number and percentage of customer plans after their initial free trial?

/*
Question is asking for number and percentage of customers who converted to becoming paid customer after the trial. 

Steps:
* Find out customer's next plan which is located in the next row using LEAD() function
* Find the total number and percentage for each plan using COUNT
* Filter for plan_id = 0 as every customer has to start from the trial plan at 0
*/

WITH cte_next_plan AS
(
	SELECT *,
		   LEAD(plan_id, 1) OVER (PARTITION BY customer_id ORDER BY plan_id) AS next_plan
	FROM subscriptions
),

planning AS --create number and percentage
(
    SELECT c.next_plan,
    COUNT(DISTINCT customer_id) AS customer_count,
    (100 * CAST(COUNT(DISTINCT customer_id) AS FLOAT) / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions)) AS percentage
	FROM cte_next_plan c
	LEFT JOIN plans p 
	ON p.plan_id = c.next_plan
	WHERE c.plan_id = 0 
		AND c.next_plan is not null
	GROUP BY c.next_plan
	)

SELECT
	p.plan_name, 
	s.customer_count, 
	s.percentage
FROM planning s
LEFT JOIN plans p 
ON p.plan_id = s.next_plan;

/*
More than 80% of customers are on paid plans,a with small 3.7% on plan 3 (pro annual $199). Foodie-fi has to restrategize on 
their customer acquisition strategy for customers who would be willing to spend more.
*/


-- 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

/*
Steps:
* Use LEAD() function to retrieve the next plan start_date located in the next row based on the curent row
* Find the breakdown of customers with existing plans on or after 2020-12-31
*/

WITH cte_next_date AS (
SELECT *,
	   LEAD(start_date, 1) OVER(PARTITION BY customer_id ORDER BY start_date) AS next_date
FROM subscriptions
WHERE start_date <= '2020-12-31'
),

plans_breakdown AS (
SELECT plan_id,
	   CAST(COUNT(DISTINCT customer_id) as FLOAT) total,
	   CAST((SELECT COUNT(DISTINCT customer_id) FROM subscriptions) AS float) total_all
FROM cte_next_date c
WHERE next_date IS NULL
GROUP BY plan_id
)

SELECT
	p.plan_name, 
	pb.total, 
	ROUND(pb.total / pb.total_all * 100, 1) percentage
FROM plans_breakdown pb
LEFT JOIN plans p 
ON p.plan_id = pb.plan_id
ORDER BY pb.plan_id;

* On December 31, 2020, more people subscribed or upgraded to the pro monthly plan, but fewer people signed up
for the trial plan. Could it be that some new customers signed up for paid plans immediately? If not, Foodie-Fi
needs to scale up its marketing strategies for acquiring new sign-ups during this period as it's a holiday period,
and as an entertainment platform, it's supposed to have more customers testing out the platform.


-- 8. How many customers have upgraded to an annual plan in 2020?

SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM Subscriptions s
WHERE plan_id = 3 AND start_date <= '2020-12-31'

-- 195 customers upgraded to an annual plan in 2020


-- 9. How many days on average does it take for a customer to upgrade to an annual plan from the day they join Foodie-Fi?

/*
* Assuming join date same as trial start date, fetch data for trial and annual plan separately
* Use DATEDIFF to extract days from the difference between trial and annual start date
* Use AVG to find the average length of days it takes to buy an annual plan.
*/

-- Filter results to customers at trial plan = 0
WITH trial_plan AS (
	SELECT customer_id,
		   start_date AS trial_date
	FROM subscriptions
	WHERE plan_id = 0
),

-- Filter results to customers on annual plan = 3
annual_plan AS (
	SELECT customer_id,
		   start_date as annual_date
	FROM subscriptions
	WHERE plan_id = 3
)

-- Find the diffrence between the two dates
SELECT ROUND(AVG(ABS(DATEDIFF(day, annual_date, trial_date))), 0) AS avg_days_to_upgrade
FROM trial_plan tp
JOIN annual_plan ap
ON tp.customer_id = ap.customer_id;

-- On average, it takes 104 days for customers to upgrade to an annual plan after they join Foodie-Fi


-- 10. Can you further break down this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

WITH trial_plan AS (
    SELECT customer_id, start_date AS trial_date
    FROM subscriptions
    WHERE plan_id = 0
),
annual_plan AS (
    SELECT customer_id, start_date as annual_date
    FROM subscriptions
    WHERE plan_id = 3
)

SELECT
    CONCAT(FLOOR(DATEDIFF(day, trial_date, annual_date) / 30) * 30, '-', FLOOR(DATEDIFF(day, trial_date, annual_date) / 30) * 30 + 30, ' days') AS period,
    COUNT(*) AS total_customers,
    ROUND(AVG(DATEDIFF(day, trial_date, annual_date)), 0) AS avg_days_to_upgrade
FROM trial_plan tp
JOIN annual_plan ap ON tp.customer_id = ap.customer_id
WHERE ap.annual_date IS NOT NULL
GROUP BY FLOOR(DATEDIFF(day, trial_date, annual_date) / 30);

/*
Upon further analysis, I discovered the following trends:

* The majority of customers opt to subscribe or upgrade to an annual plan within the first 30 days.
* A smaller percentage of customers make the decision to subscribe or upgrade after 210 days.
* After 270 days, there is almost no customer activity in terms of purchasing a plan.


-- 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

/*
Steps:
* Use the LEAD() function to get the next plan after their initial plan
* COUNT the number of customers that dowgraded from pro monthly to basic monthly in 2020
*/

-- To retrieve the next plan start_date located in the next row based on the current row
WITH next_plan_cte AS (
SELECT customer_id,
	   plan_id,
	   start_date,
	   LEAD(plan_id) OVER(PARTITION BY customer_id ORDER BY plan_id) AS next_plan
FROM subscriptions
)

SELECT COUNT(*) AS downgraded
FROM next_plan_cte
WHERE start_date <= '2020-12-31'
	AND plan_id = 2 AND next_plan = 1; 

-- No customer has downgraded from pro monthly to basic monthly in 2020.


