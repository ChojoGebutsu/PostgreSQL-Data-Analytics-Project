-- Calculating the Total Number of Customers Per Country
SELECT
    country,
    COUNT(*) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Calculating the Total Number of Customers By Gender
SELECT
    gender,
    COUNT(*) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Calculating the Total Number of Products Per Category
SELECT
    category,
    COUNT(*) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- Calculating the Average Cost of Products Per Category
SELECT
    category,
    ROUND(AVG(cost), 2) AS average_cost
FROM gold.dim_products
GROUP BY category
ORDER BY average_cost DESC;

--Calculating the Total Revenue Per Category
SELECT
    dp.category,
    SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS dp
    ON fs.product_key = dp.product_key
GROUP BY dp.category
ORDER BY total_revenue DESC;

--Calculating the Total Revenue Per Each Customer
SELECT
    dc.customer_key,
    dc.first_name,
    dc.last_name,
    SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc
    ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_key, dc.first_name, dc.last_name
ORDER BY total_revenue DESC;

--Calculating the Distribution of Sold Items Per Category
SELECT
    dc.country,
    SUM(fs.quantity) AS total_sold_items
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc
    ON fs.customer_key = dc.customer_key
GROUP BY dc.country
ORDER BY total_sold_items DESC;