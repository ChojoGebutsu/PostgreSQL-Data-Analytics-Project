-- Calculating the Total Sales
SELECT
    'Total Sales' AS measure_name,
    SUM(sales_amount) AS measure_value
FROM gold.fact_sales

UNION ALL

-- Calculating Number of Sold Items
SELECT
    'Total Sold Quantity' AS measure_name,
    SUM(quantity) AS measure_value
FROM gold.fact_sales

UNION ALL

-- Calculating Average Selling Price
SELECT
    'Average Selling Price' AS measure_name,
    ROUND(AVG(price), 2) AS measure_value
FROM gold.fact_sales

UNION ALL

-- Calculating the Total Number of Orders
SELECT
    'Total No. Of Orders' AS measure_name,
    COUNT(DISTINCT order_number) AS measure_value
FROM gold.fact_sales

UNION ALL

-- Calculating the Total Number of Products
SELECT
    'Total No. Of Products' AS measure_name,
    COUNT(product_key) AS measure_value
FROM gold.dim_products

UNION ALL

-- Calculating the Total Number of Customers
SELECT
    'Total No. Of Customers' AS measure_name,
    COUNT(DISTINCT customer_key) AS measure_value
FROM gold.dim_customers

UNION ALL

-- Calculating the Total Number of Customer That Placed an Order
SELECT
    'Total No. Of Customers With Orders' AS measure_name,
    COUNT(DISTINCT customer_key) AS measure_value
FROM gold.fact_sales;
