-- Exploring All Countries From dim_customers
SELECT distinct
    country
FROM gold.dim_customers;

-- Exploring All Categories of Products From dim_products
SELECT DISTINCT
    category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY 1,2,3;