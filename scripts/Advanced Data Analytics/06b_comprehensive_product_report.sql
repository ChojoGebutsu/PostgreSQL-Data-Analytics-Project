/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report provides a consolidated view of critical product metrics and behaviors.

Highlights:
    1. Captures essential fields including product name, category, subcategory, and cost.
    2. Classifies products into performance tiers: High-Performers, Mid-Range, or Low-Performers based on revenue.
    3. Aggregates key product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total unique customers,
       - average selling price
       - product lifespan (in months)
    4. Computes important KPIs:
       - recency (months since the last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

CREATE OR REPLACE VIEW gold.product_report AS

WITH base_query AS (

-- 1) Base Query: Retrieving essential data from tables

    SELECT 
        fs.order_number,
        fs.customer_key,
        fs.sales_amount,
        fs.quantity,
        fs.order_date,
        dp.product_key,
        dp.product_number,
        dp.product_name,
        dp.category,
        dp.subcategory,
        dp.cost
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_products AS dp
    ON fs.product_key = dp.product_key
    WHERE order_date IS NOT NULL
),

product_aggregation AS (

-- 2) Product Aggregation: Aggregating product metrics

    SELECT
        product_key,
        product_number,
        product_name,
        category,
        subcategory,
        cost,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity_sold,
        COUNT(DISTINCT customer_key) AS total_unique_customers,
        ROUND(AVG(sales_amount::NUMERIC / NULLIF(quantity, 0)), 2) AS avg_selling_price,
        MAX(order_date) AS last_sales_date,
        EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
        EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS product_lifespan
    FROM base_query
    GROUP BY product_key, product_number, product_name, category, subcategory, cost
)

-- 3) Final Query: Calculating KPIs and classifying products
SELECT  
    product_key,
    product_number,
    product_name,
    category,
    subcategory,
    cost,
    total_orders,
    total_sales,
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE ROUND(total_sales::NUMERIC / total_orders, 2) 
    END AS avg_order_revenue,
    avg_selling_price,
    CASE 
        WHEN product_lifespan = 0 THEN 0
        ELSE ROUND(total_sales::NUMERIC / product_lifespan, 2) 
    END AS avg_monthly_revenue,
    total_quantity_sold,
    total_unique_customers,
    CASE
        WHEN total_sales >= 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_performance_segment,
    last_sales_date,
    EXTRACT(YEAR FROM AGE(NOW()::DATE, last_sales_date)) * 12 +
    EXTRACT(MONTH FROM AGE(NOW()::DATE, last_sales_date)) AS mths_since_last_sale,
    product_lifespan
FROM product_aggregation
ORDER BY product_key;

SELECT * FROM gold.product_report;