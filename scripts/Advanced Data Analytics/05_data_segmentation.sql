-- Performing data segmentation
-- Task: Segment product into categoeries according to cost & count how many products are in each category

WITH tbl1 AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost > 500 AND cost <= 1000 THEN '501-1000'
            ELSE 'Above 1000'
        END AS cost_category
    FROM gold.dim_products
)

SELECT 
    cost_category,
    COUNT(product_key) AS no_of_products
FROM tbl1
GROUP BY cost_category
ORDER BY no_of_products DESC;