# <p align="center" style="margin-top: 0px;">🥑 Case Study #3 - Foodie-Fi 🥑
## <p align="center"> D. Outside the Box Questions


### *1. How would you calculate the rate of growth for Foodie-Fi?*

#### A: Calculating growth rate based on increase in number of customers overtime

To calculate the growth rate of Foodie-Fi, we need to determine the increase in the number of customers over a specific period of time.

The formular to calculate the growth rate is Rate of Growth = ((Customer count 2021 - customer count 2020) / customer count  2020) * 100

For example, let's say that Foodi Fi has 10,000 customers at the beginning of the year and 15,000 customers at the end of the year.
The rate of growth for that year would be ((15,000 - 10,000) / 10,000) * 100 = 50%

So, in the above example, Foodie-Fi customers grew by 50% during that year.

To calculate the growth rate for specific plans, we need to calculate the increase in the number of customers for each plan seperately
and then calculate the rate of growth for each plan. 

*The SQL Code to calculate the growth rate is:*


```sql
SELECT ((COUNT(DISTINCT current_customers) - COUNT(DISTINCT previous_customers)) / COUNT(DISTINCT previous_customers)) * 100 AS rate_of_growth
FROM (
  SELECT COUNT(DISTINCT customer_id) AS current_customers, NULL AS previous_customers
  FROM subscriptions
  WHERE start_date >= '2021-01-01'
  UNION ALL
  SELECT NULL AS current_customers, COUNT(DISTINCT customer_id) AS previous_customers
  FROM subscriptions
  WHERE start_date BETWEEN '2020-01-01' AND '2021-12-31'
) AS customer_counts
```

*To calculate the growth rate for a particular plan:*

```sql
SELECT ((COUNT(DISTINCT current_customers) - COUNT(DISTINCT previous_customers)) / COUNT(DISTINCT previous_customers)) * 100 AS rate_of_growth
FROM (
  SELECT COUNT(DISTINCT customer_id) AS current_customers, NULL AS previous_customers
  FROM subscriptions
  WHERE plan_id = 2 AND start_date >= '2021-01-01'
  UNION ALL
  SELECT NULL AS current_customers, COUNT(DISTINCT customer_id) AS previous_customers
  FROM subscriptions
  WHERE plan_id = 2 AND start_date BETWEEN '2020-01-01' AND '2021-12-31'
) AS customer_counts;
```

#### B: Calculating the growth rate based on increase in revenue over time.

Explanation:

* The inner query is a UNION of two subqueries: one for current revenue (in 2021) and one for previous revenue (in 2020).

* In each subquery, we join the subscriptions and plans tables to get the price of each subscription plan.

* For the current revenue subquery, we only select the subscriptions with a start date greater than or equal to '2021-01-01'.

* For the previous revenue subquery, we only select the subscriptions with a start date between '2020-01-01' and '2020-12-31'.

* In each subquery, we use the SUM function to calculate the total revenue for the selected subscriptions.

* We use NULL as a placeholder for the value we don''t need in each subquery.

* The outer query calculates the growth rate of revenue using the same formula as the original query: 
((current - previous) / previous) * 100.

```sql
SELECT ((SUM(current_revenue) - SUM(previous_revenue)) / SUM(previous_revenue)) * 100 AS rate_of_growth
FROM (
  SELECT SUM(p.price) AS current_revenue, NULL AS previous_revenue
  FROM subscriptions s
  INNER JOIN plans p ON s.plan_id = p.plan_id
  WHERE s.start_date >= '2021-01-01'
  UNION ALL
  SELECT NULL AS current_revenue, SUM(p.price) AS previous_revenue
  FROM subscriptions s
  INNER JOIN plans p ON s.plan_id = p.plan_id
  WHERE s.start_date BETWEEN '2020-01-01' AND '2020-12-31'
) AS revenue_counts;
```

---

### *2. What key metrics would you recommend Foodie-Fi management to track over time to assess performance of their overall business?*

Some key metrics I would recommend Fodie-Fi management to track over time to assess the performance of their overall business are:

* Monthly Recurring Revenue (MRR)	: This is the sum of revenue from all active monthly subscriptions, and it is a good indicator of the
business's revenue-generating potential.'

* Churn Rate: This is the percentage of customers who cancel their subscription in a given time period. A high churn rate could indicate
a problem with the product or service, customer experience and pricing.

* Customer Acquisition Cost (CAC): This is the amount of money it costs to acquire a new customer. By tracking this metric over time,
management can access the efficiency of their marketing and sales efforts.

* Customer Lifetime Value (CLV): This is the total amount of revenue a customer is expected to generate over their lifetime as a subscriber.
By comparing CLV to CAC, management can determine if their customer acquisition efforts are profitable.

* Plan Conversion Rates: This metric shows the percentage of customers who upgrade or downgrade their subscription plans. By tracking this
metric, management can identify which plans are most popular and which plans may need improvement.

* Engagement Metrics: These metrics can include the number of hours streamed, number of videos watched, and frequency of usage. Tracking
these metrics over time can provide insight into customer behaviour and preferences, which can inform content development and marketing strategies.

* Net Promoter Score (NPS): This is a measure of customer satisfaction and loyalty. By asking customers to rate the likelihood of recommending
Foodie-Fi to others, management can guage overall customer satisfaction and identify areas for improvement.

---

### *3. What are some key customer journeys or experiences that you would analyse further to improve customer retention?*

The key customer journeys or experiences that I would analyse further to improve customer retention are:

* Onboarding experience: The first few interactions a customer has with the Foodie-Fi platform can set the tone for their entire experience.
Analysing how the users sign up, navigate through the platform, and discover content can help identify areas for improvement in the onboarding experience.

* Customer engagement with content: Understanding which shows and recipes are most popular and how often customers are watching them can help
improve the content selection and recommendations. Analyzing which type of content performs well in different regions and demographics can
provide insights and personalized content.

* Customer feedback: Solicting customer feedback through surveys, reviews, and customer support interactions can provide valuable insights into
areas that need improvement or features that could be added. Analyzing feedbacks and complaints to understand trends and patterns can provide
insights to rectify common issues.

* Churn analysis: Understanding why customers are leaving the service can help Foddie-Fi address the underlying issues that are causing the churn.
Analyzing churn trends by demographic, location, or subscription plan can help identify patterns and potential reasons behind cancellations.

* Retention campaigns: Analysing the impact of different retention campaigns like email campaigns, loyalty programs, or personalized recommendations 
can help improve customer retention. By identifying the most effective campaigns, Foodie-Fi can refine their retention strategy and improve 
customer engagement.

Overall, by analysing these key customer journeys and experiences, Foodie-Fi can identify areas for improvement and develop targeted strategies 
to improve customer retention and loyalty.

---

### *4. If the Foodie-Fi team were to create an exit survey shown to customers who wish to cancel their subscription, what questions would you include*
in the survey?

If Foodie-Fi were to create an exit survey shown to customers who wish to cancel their subscription, some questions that could be included in the
survey are:

- Why are you cancelling your subscription?
- How satisfied were you with the content offered on Foodie-Fi?
- Was the price of the subscription a deciding factor in your cancellation?
- How was your experience with the Foodie-Fi platforms? Was it user-friendly?
- Did you encounter any technical issues while using Foodie-Fi?
- Did you find the content recomendation relevant and personalized to your interests?
- Did you experience any issues with customer support during your subscription?
- Would you consider re-subscribing to Foodie-Fi in the future?
- How likely are you to recommend Foodie-Fi to a friend or family member? 
- Is there anything that Foodie-Fi could have done differently to prevent your cancellation?

---

### *5. What business levers could the Foodie-Fi team use to reduce the customer churn rate? How would you validate the effectiveness of your ideas?*

To reduce the customer churn rate, the Foodie-Fi team could use several business levers, such as:

* Improve content selection: By offering a wide range of content and regularly updating it, Foodie-Fi can keep customers engaged and
interested in their plaform. Conducting customer surveys, analysing viewing pattens, and incorporating customer feedback can help identify 
content preferences and improve election.

* Personalization: Offering personalized recommendations and content based on a customer''s viewing history and preferefences can help improve
customer engagement and retention. Using machine learning algorithms to understand viewing habits and predict interests can help offer personalized
contenet.

* Price and plan options: Offering affordable and flexible subscription plans can help retain customers. For instance, offering annual subscriptions
with discount or introducing more affordable plans can encourage customers to stay longer.

* Customer service: Providing excellent customer service can help build a loyal customer base. By offering timely and effective support, addressing
customer complaints, and conducting regular follow-ups, Foodie-Fi can build trust and a positive reputation.

* Retention  campaigns: Offering retention campaigns such as exclusive content, discounts or loyalty programs can incentivize customers to stay longer.

To validate the effectiveness of these ideas, Foodie-Fi can use A/B testing and customer surveys to analyze the impact of these levers on customer
retention. For example, the team could run an A/B test with personalized content recommendations to measure its impact on customer retention.
Similarly, conducting surveys after implementing retention campaigns can provide insights into customer satisfaction and engagement levels. 
By continually monitoring and analyzing the impact of these levers on customer churn, Foodie-Fi can refine its retention strategies and
improve customer loyalty.

