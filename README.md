# <p align="center" style="margin-top: 0px;"> 🥑 Case Study #3 - Foodie-Fi 🥑

<p align="center" style="margin-bottom: 0px !important;">
<img src="https://github.com/Chisomnwa/8-Week-SQL-Challenge-Case-Study--3-Foodie-Fi/blob/main/Images/Foodie-Fi%20Photo.png" width="540" height="540">

---
*This repository hosts the solutions to the 3rd challenge (Week 3) of the 8 Weeks SQL Challenge by DannyMa. [Click here to view the full challenge](https://8weeksqlchallenge.com/case-study-3/)*

---
## 🧾 Table of Contents
- [Business Case](#business-case)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Available Data](#available-data)
- [Case Study Questions](#case-study-questions)
- [Extra Resources](#extra-resources)

   
## Business Case
Subscription based businesses are super popular and Danny realised that there was a large gap in the market - he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. 
   
This case study focuses on using Foodie-Fi data; a subscription style digital data to answer important business questions that could help the startup have an insight of critical business metrics relating to the customer journey, payment transactions, and overall business performance.
   
   
---
## Entity Relationship Diagram
<p align="center" style="margin-bottom: 0px !important;">
<img src="https://github.com/Chisomnwa/8-Week-SQL-Challenge-Case-Study--3-Foodie-Fi/blob/main/Images/ERD.png">
   
   
---
## Available Data
  
<details><summary>
    All datasets exist in database schema.
  </summary> 
  
 #### ``Table 1: plans``
plan_id | plan_name | price
-- | -- | --
0 | trial | 0
1 | basic monthly | 9.90
2 | pro monthly | 19.90
3 | pro annual | 199
4 | churn | null

#### ``Table 2: subscriptions``
*Note: this is only customer sample*
customer_id | plan_id | start_date
-- | -- | --
1 | 0 | 2020-08-01
1 | 1 | 2020-08-08
2 | 0 | 2020-09-20
2 | 3 | 2020-09-27
11 | 0 | 2020-11-19
11 | 4 | 2020-11-26
13 | 0 | 2020-12-15
13 | 1 | 2020-12-22
13 | 2 | 2021-03-29
15 | 0 | 2020-03-17
15 | 2 | 2020-03-24
15 | 4 | 2020-04-29
16 | 0 | 2020-05-31
16 | 1 | 2020-06-07
16 | 3 | 2020-10-21
18 | 0 | 2020-07-06
18 | 2 | 2020-07-13
19 | 0 | 2020-06-22
19 | 2 | 2020-06-29
19 | 3 | 2020-08-29 

  </details>

   
---
## Case Study Solutions
- [Part A - Customer Journey](https://github.com/Chisomnwa/8-Week-SQL-Challenge-Case-Study--3-Foodie-Fi/blob/main/A.%20Customer%20Journey.md)
- [Part B - Data Analysis Questions](https://github.com/Chisomnwa/8-Week-SQL-Challenge-Case-Study--3-Foodie-Fi/blob/main/B.%20Data%20Analysis%20Questions.md)
- [Part C - Challenge Payment Questions](https://github.com/Chisomnwa/8-Week-SQL-Challenge-Case-Study--3-Foodie-Fi/blob/main/C.%20Challenge%20Payment%20Question.md)
- [Part D - Outside the Box Questions](https://github.com/Chisomnwa/8-Week-SQL-Challenge-Case-Study--3-Foodie-Fi/blob/main/D.%20Outside%20the%20Box%20Questions.md)
   
   
 ---
 ## Extra Resources
 - [Medium Article](https://medium.com/@chisompromise/analyzing-subscription-style-digital-data-foodie-fi-f82031f93d09)
 - [Foodie-Fi Dashboard and Key Recommendations](https://www.novypro.com/project/business-performance-dashboard--foodie-fi)
   
   
 # <p align="center" style="margin-top: 0px;">This was Fun! 🙌🥰😎
 
