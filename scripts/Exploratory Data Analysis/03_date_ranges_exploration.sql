-- Searching for the first and last order date
-- How many months of data do we have?
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    EXTRACT(YEAR FROM age(MAX(order_date), MIN(order_date))) * 12 + 
    EXTRACT(MONTH FROM age(MAX(order_date), MIN(order_date))) AS months_of_data
FROM gold.fact_sales;

-- Finding the Youngest and Oldest Customer
SELECT 
    MIN(birth_date) AS oldest_customer,
    EXTRACT(YEAR FROM CURRENT_TIMESTAMP) - EXTRACT(YEAR FROM MIN(birth_date)) AS oldest_customer_age,
    MAX(birth_date) AS youngest_customer,
    EXTRACT(YEAR FROM CURRENT_TIMESTAMP) - EXTRACT(YEAR FROM MAX(birth_date)) AS youngest_customer_age
FROM gold.dim_customers;