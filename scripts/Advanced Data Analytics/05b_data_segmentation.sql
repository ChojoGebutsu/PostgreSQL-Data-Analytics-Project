/*
- Based on customers' spending behaviour, segment them into 3 groups:
    1) Premium Customers: At least 12 months of purchasing history and more than $5000 spent
    2) Regular Customers: At least 12 months of purchasing history and less than $5000 spent
    3) New Customers: Less than 12 months of purchasing history

- Find the total number of customers for each segment
*/

WITH tbl1 AS (
    SELECT
        customer_key,
        SUM(sales_amount) AS total_sales,
        MAX(order_date) AS last_purchase_date,
        MIN(order_date)  AS first_purchase_date,
        EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
        EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS purchasing_history_mths
    FROM gold.fact_sales
    GROUP BY customer_key
    ORDER BY 1,2
)

SELECT
    customer_segment,
    COUNT(customer_key) AS no_of_customers
FROM (
    SELECT 
        customer_key,
        CASE
            WHEN purchasing_history_mths >= 12 AND total_sales > 5000 THEN 'Premium Customers'
            WHEN purchasing_history_mths >= 12 AND total_sales <= 5000 THEN 'Regular Customers'
            ELSE 'New Customers'
        END AS customer_segment
    FROM tbl1
) AS t
GROUP BY customer_segment
ORDER BY no_of_customers DESC;



