-- WHich 5 Products are generating the highest revenue?
SELECT
    product_name,
    total_revenue
FROM (
    SELECT
        dp.product_name,
        SUM(fs.sales_amount) AS total_revenue,
        DENSE_RANK() OVER (ORDER BY SUM(fs.sales_amount) DESC) AS revenue_rank
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_products AS dp
        ON fs.product_key = dp.product_key
    GROUP BY dp.product_key, dp.product_name
) AS ranked_revenue
WHERE revenue_rank <= 5
ORDER BY total_revenue DESC;

-- WHich 5 Subcategories are generating the highest revenue?
SELECT
    subcategory,
    total_revenue
FROM (
    SELECT
        dp.subcategory,
        SUM(fs.sales_amount) AS total_revenue,
        DENSE_RANK() OVER (ORDER BY SUM(fs.sales_amount) DESC) AS revenue_rank
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_products AS dp
        ON fs.product_key = dp.product_key
    GROUP BY dp.subcategory
) AS ranked_revenue
WHERE revenue_rank <= 5
ORDER BY total_revenue DESC;

-- WHich 5 Products are generating the lowest revenue?
SELECT
    product_name,
    total_revenue
FROM (
    SELECT
        dp.product_name,
        SUM(fs.sales_amount) AS total_revenue,
        DENSE_RANK() OVER (ORDER BY SUM(fs.sales_amount)) AS revenue_rank
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_products AS dp
        ON fs.product_key = dp.product_key
    GROUP BY dp.product_key, dp.product_name
) AS ranked_revenue
WHERE revenue_rank <= 5
ORDER BY total_revenue;

-- WHich 10 Customers generated the highest revenue?
SELECT
    customer_key,
    first_name || ' ' || last_name AS full_name,
    total_revenue
FROM (
SELECT
    dc.customer_key,
    dc.first_name,
    dc.last_name,
    SUM(fs.sales_amount) AS total_revenue,
    DENSE_RANK() OVER (ORDER BY SUM(fs.sales_amount) DESC) AS revenue_rank
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc
    ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_key, dc.first_name, dc.last_name
) AS ranked_revenue
WHERE revenue_rank <= 10
ORDER BY total_revenue DESC;

-- Which  Customers placed 3 or less orders?
SELECT
    customer_key,
    first_name || ' ' || last_name AS full_name,
    no_of_orders
FROM (
SELECT
    dc.customer_key,
    dc.first_name,
    dc.last_name,
    COUNT(DISTINCT fs.order_number) AS no_of_orders,
    DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT fs.order_number)) AS no_of_orders_rank
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc
    ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_key, dc.first_name, dc.last_name
) AS ranked_revenue
WHERE no_of_orders_rank <= 3;