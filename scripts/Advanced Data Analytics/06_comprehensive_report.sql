/*
=============================================
Comprehensive Customer Report
=============================================
Purpose:
    - This report provides key customer metrics and behaviours 
Highlights:
    - Gathers essential fields such as names, ages, and transaction details.
    - Segments customers into categories based on their purchasing history and age groups.
    - Aggregates customer metrics:
        - Total Sales Amount
        - Total Number of Orders
        - Total Purchased Quantity
        - Total Products
        - Lifespan in Months
    - Calculates following KPIs:
        - Months since last purchase
        - Average Order Value
        - Average Monthly Spend
*/

CREATE OR REPLACE VIEW gold.customer_report AS 

WITH base_query AS (

-- 1) Base Query: Retrieving essential data from tables

    SELECT
        fs.order_number,
        fs.product_key,
        fs.order_date,
        fs.sales_amount,
        fs.quantity,
        dc.customer_key,
        dc.customer_number,
        CONCAT(dc.first_name, ' ', dc.last_name) AS full_name,
        EXTRACT (YEAR FROM AGE(NOW()::DATE, dc.birth_date)) AS age
    FROM gold.fact_sales fs
    LEFT JOIN gold.dim_customers dc
        ON fs.customer_key = dc.customer_key
    WHERE fs.order_date IS NOT NULL
),

customer_aggregation AS(

-- 2) Customer Aggregation: Aggregating customer metrics

    SELECT  
        customer_key,
        customer_number,
        full_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales_amount,
        SUM(quantity) AS total_purchased_qty,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_purchase_date,
        EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
        EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS lifespan_mths
    FROM base_query
    GROUP BY customer_key, customer_number, full_name, age
)

-- 3) Final Query: Calculating KPIs and classifying customers
SELECT
    customer_key,
    customer_number,
    full_name,
    age,
    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END AS age_group,
    CASE
        WHEN lifespan_mths >= 12 AND total_sales_amount > 5000 THEN 'Premium Customers'
        WHEN lifespan_mths >= 12 AND total_sales_amount <= 5000 THEN 'Regular Customers'
        ELSE 'New Customers'
    END AS customer_segment,
    last_purchase_date,
    EXTRACT (YEAR FROM AGE(NOW()::DATE, last_purchase_date)) * 12 +
    EXTRACT (MONTH FROM AGE(NOW()::DATE, last_purchase_date)) AS mths_since_last_purchase,
    total_orders,
    total_sales_amount,
    total_purchased_qty,
    total_products,
    lifespan_mths,
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE ROUND(total_sales_amount::NUMERIC / total_orders, 2) 
    END AS avg_order_value,
    CASE 
        WHEN lifespan_mths = 0 THEN 0
        ELSE ROUND(total_sales_amount::NUMERIC / lifespan_mths, 2) 
    END AS avg_monthly_spend
FROM customer_aggregation;
