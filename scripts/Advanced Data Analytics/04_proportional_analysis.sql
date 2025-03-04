-- Which product categories contribute the most to total sales?
-- The following query calculates the proportion of total sales for each product category.

SELECT
    dp.category,
    SUM(fs.sales_amount) AS total_sales,
    ROUND(100.0*(SUM(fs.sales_amount) / SUM(SUM(fs.sales_amount)) OVER()), 2) || '%' AS pct_of_total_sales
FROM gold.fact_sales fs
JOIN gold.dim_products dp
    ON fs.product_key = dp.product_key
GROUP BY dp.category
ORDER BY total_sales DESC;