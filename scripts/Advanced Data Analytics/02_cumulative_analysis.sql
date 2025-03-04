-- Calculating total sales and running total sales for each month over time
SELECT
    TO_CHAR(year_month, 'YYYY-MM') AS year_month,
    total_sales_per_mth,
    SUM(total_sales_per_mth) 
    OVER(
        PARTITION BY EXTRACT(YEAR FROM year_month)
        ORDER BY year_month
        ) AS running_total_sales,
    avg_price,
    AVG(avg_price)
    OVER(
        PARTITION BY EXTRACT(YEAR FROM year_month)
        ORDER BY year_month
        ) AS running_avg_price
FROM (
    SELECT
        DATE_TRUNC('month', order_date)::DATE AS year_month,
        SUM(sales_amount) AS total_sales_per_mth,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY 
        DATE_TRUNC('month', order_date)::DATE
) AS tbl;
