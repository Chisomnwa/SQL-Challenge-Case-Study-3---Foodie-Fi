# <p align="center" style="margin-top: 0px;">🥑 Case Study #3 - Foodie-Fi 🥑
## <p align="center"> B. Data Analysis Questions


###1. How many customers has Foodie-Fi ever had?*

###Steps:
Use the DISTINCT function to find the number of Foodie Fi's unique customers

```
SELECT COUNT(DISTINCT customer_id) AS customer_count
FROM subscriptions;
```
### Output
|total_customers|
| -- |
|1000|

Foodie-Fi has 1000 unique customers.
