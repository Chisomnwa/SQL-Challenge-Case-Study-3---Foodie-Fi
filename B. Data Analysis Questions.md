# <p align="center" style="margin-top: 0px;">🥑 Case Study #3 - Foodie-Fi 🥑
## <p align="center"> B. Data Analysis Questions


### 1. How many customers has Foodie-Fi ever had?

### Steps:
  
* Use the DISTINCT function to find the number of Foodie Fi's unique customers

```sql
SELECT COUNT(DISTINCT customer_id) AS customer_count
FROM subscriptions;
```
### Output:
|total_customers|
| -- |
|1000|

* Foodie-Fi has 1000 unique customers.
  
 ---
	
### 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

### Steps:
* Extract the months from start_date column
* COUNT the total number of plan_ids for each month
* And filter for where plan_name is Trial

```sql
SELECT month(start_date) AS months,
	   COUNT(s.plan_id) AS total_plans
FROM subscriptions AS s
INNER JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE plan_name = 'trial'
GROUP BY month(start_date)
ORDER BY COUNT(s.plan_id) DESC
```

#### Output:
| months | total_plans
| -- | --
| 3 | 94
| 7 | 89
| 8 | 88
| 1 | 88
| 5 | 88 
| 9 | 87
| 12 | 84
| 4 | 81
| 10 | 79
| 6 | 79
| 11 | 75
| 2 | 68
	
* March has the highest number of trial plans, whereas February has the lowest number of trial plans.
  
---
  
### 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

### Steps:
Question is asking for the number of plans for start dates occurring in 2021 and after grouped by plan names.

* Filter plans with start_dates occurring after 2020-12-31
* Group and order results by plan.

```sql
SELECT p.plan_name, 
	   p.plan_id,
	   COUNT(*) AS event_2021
FROM plans AS p
INNER JOIN  subscriptions AS s
ON p.plan_id = s.plan_id
WHERE s.start_date >= '2021-01-01'
GROUP BY p.plan_id, p.plan_name
ORDER BY p.plan_id;
```

### Output:
plan_name | plan_id | event_2021
-- | -- | --
basic monthly | 1 | 8
pro monthly | 2 | 60
pro annual | 3 | 63
churn | 4 | 71
	
	
* The result above showed that there was no trial plan recorded in 2021 and I was curious and ran the below query for 2020 and 2021 so I could understand the year-on-year results.


```sql
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
```
 
### Output:
plan_id| event_2020 | event_2021
-- | -- | --
0 | 1000 | 0
1 | 538 | 8
2 | 479 | 60
3 | 195 | 63
4 | 236 | 71


The result shows there was no free trial in 2020. Maybe the old customers from 2020 continued with their subscriptions in 2021,
customers upgraded from one paid trial to another, or customers signed up for paid plans without going through the trial plan.

---
	
### 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

### Steps:
* Count the total number of customers
* Get the percentage of customers by diving total customers with distinct number of customers and round it to 1 decimal place.
* Filter for where the plan_id is 4 which is Trial

```sql
SELECT COUNT(*) AS customer_count,
	   ROUND((CAST(COUNT(*) AS FLOAT) / (SELECT COUNT(DISTINCT customer_id) FROM  subscriptions)) * 100, 1) AS churn_percentage
FROM subscriptions
WHERE plan_id = 4;
```

### Output:
customer_count | churn_percentage
-- | --
307 | 30.7
	
* 307 customers, or 30.7% of the total customers, have churned from Food-fi during the period of analysis.

---
	
### 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

### Steps:
* use lag function to create a new column called "previous_plan" which stores the plan_id of the previous
  subscription plan for each customer.	
* get the total number of rows in the previous_plan column
* get the perecentage of customers and round to the nearest whole number
* Using the cte_churn CTE, filter for rows with plan_id of 4 (churn_plan) and previous_plan of 0(trial plan)

```sql
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
```

### Ouput:
churn_count | percentage_churn
-- | --
92 | 9
	
---

### 6. What is the number and percentage of customer plans after their initial free trial?

Question is asking for number and percentage of customers who converted to becoming paid customer after the trial. 

### Steps:
* Find out customer's next plan which is located in the next row using LEAD() function
* Find the total number and percentage for each plan using COUNT
* Filter for plan_id = 0 as every customer has to start from the trial plan at 0

```
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

SELECT p.plan_name, 
	   s.customer_count, 
	   s.percentage
FROM planning s
LEFT JOIN plans p 
ON p.plan_id = s.next_plan;
```

### Output:
plan_name | customer_count | percentage
-- | -- | --
basic monthly | 546 | 54.6
pro monthly | 325 | 32.5
pro annual | 37 | 3.7
churn | 92 | 9.2


* More than 80% of customers are on paid plans,a with small 3.7% on plan 3 (pro annual $199). Foodie-fi has to restrategize on 
their customer acquisition strategy for customers who would be willing to spend more.

