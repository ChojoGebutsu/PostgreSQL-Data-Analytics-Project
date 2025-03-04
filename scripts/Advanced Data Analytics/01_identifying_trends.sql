SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM order_date) 
ORDER BY EXTRACT(YEAR FROM order_date);


SELECT 
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(MONTH FROM order_date) 
ORDER BY EXTRACT(MONTH FROM order_date);

-- Formated total_sales with comma separator for better readability
SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS year_month,
    TO_CHAR(SUM(sales_amount), 'FM999,999,999') AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY 1;
