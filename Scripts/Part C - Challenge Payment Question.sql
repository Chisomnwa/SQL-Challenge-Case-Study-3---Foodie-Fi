-- C. Challenge Payment Question

/*
The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts
paid by each customer in the subscriptions table with the following requirements:

- monthly payments always occur on the same day of month as the original start_date of any monthly paid plan

- upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately

- upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end
of the month period once a customer churns they will no longer make payments


STEPS TAKEN TO CREATE THE PAYMENT TABLE:

1. The first step is to create a table named payments_2020 using the CREATE TABLE command. 
This table will store the payment data for the year 2020. The table has several columns including 
payment_id, customer_id, plan_id, plan_name, payment_date, amount, and payment_order.

2. After creating the payments_2020 table, the next step is to insert data into it. This is done using a Common Table
Expression (CTE) named join_table. The CTE is created by joining the subscriptions and plans tables and selecting 
specific columns like customer_id, plan_id, plan_name, payment_date, start_date, next_date, and amount.

3. The join_table CTE is then used to create another CTE named new_join. This CTE filters out trial and churn plans
from the join_table CTE using the WHERE clause.

4. A new CTE named new_join1 is created from new_join. This CTE adds a new column named next_date1 which contains 
the date that is one month before the next_date column.

5. The Date_CTE CTE is then created using a recursive function. This CTE generates payment dates for each customer
and plan combination based on their start date, end date, and next date. The function continues to run recursively
until the payment_date is equal to or greater than the next_date1.

6. Finally, the payments data is inserted into the payments_2020 table using the INSERT INTO command.
The data is selected from the Date_CTE CTE and filtered to only include data for the year 2020 using
the WHERE clause. The data is then ordered by customer_id, plan_id, and payment_date using the ORDER BY clause.

7. Additionally, a payment_order column is added to the payments_2020 table using the RANK() OVER() function. 
This column assigns a unique rank to each payment made by a customer for a specific plan.
*/

--Create payments_2020 table
CREATE TABLE payments_2020 (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    plan_id INT NOT NULL,
    plan_name VARCHAR(50) NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_order INT NOT NULL
);

--Insert payments data into payments_2020 table
WITH join_table AS --create base table
(
	SELECT 
	    s.customer_id,
		s.plan_id,
		p.plan_name,
		s.start_date AS payment_date,
		s.start_date,
		LEAD(s.start_date, 1) OVER(PARTITION BY s.customer_id ORDER BY s.start_date, s.plan_id) AS next_date,
		p.price AS amount
	FROM subscriptions s
	LEFT JOIN plans p 
	ON p.plan_id = s.plan_id
),

new_join AS --filter table (deselect trial and churn)
(
	SELECT 
		customer_id,
		plan_id,
		plan_name,
		payment_date,
		start_date,
		CASE WHEN next_date IS NULL or next_date > '20201231' THEN '20201231' ELSE next_date END next_date,
		amount
	FROM join_table
	WHERE plan_name NOT IN ('trial', 'churn')
),

new_join1 AS --add new column, 1 month before next_date
(
	SELECT 
		customer_id,
		plan_id,
		plan_name,
		payment_date,
		start_date,
		next_date,
		DATEADD(MONTH, -1, next_date) AS next_date1,
		amount
	FROM new_join
),

Date_CTE  AS --recursive function (for payment_date)
(
	SELECT 
		customer_id,
		plan_id,
		plan_name,
		start_Date,
		payment_date = (SELECT TOP 1 start_Date FROM new_join1 WHERE customer_id = a.customer_id AND plan_id = a.plan_id),
		next_date, 
		next_date1,
		amount
	FROM new_join1 a

	UNION ALL 
    
	SELECT 
		customer_id,
		plan_id,
		plan_name,
		start_Date, 
		DATEADD(M, 1, payment_date) AS payment_date,
		next_date, 
		next_date1,
		amount
	FROM Date_CTE b
	WHERE payment_date < next_date1 AND plan_id != 3
)

INSERT INTO payments_2020 (customer_id, plan_id, plan_name, payment_date, amount, payment_order)
SELECT 
	customer_id,
	plan_id,
	plan_name,
	payment_date,
	amount,
	RANK() OVER(PARTITION BY customer_id ORDER BY customer_id, plan_id, payment_date) AS payment_order
FROM Date_CTE
WHERE YEAR(payment_date) = 2020
ORDER BY customer_id, plan_id, payment_date;

--Confirming the values from the payment table
SELECT *
FROM payments_2020