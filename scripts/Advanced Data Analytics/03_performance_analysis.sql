-- Comparing each product yearly sales to the yearly average and previous year's sales

WITH tbl1 AS (
    SELECT 
        dp.product_name,
        EXTRACT(YEAR FROM fs.order_date) AS year,
        SUM(fs.sales_amount) AS yearly_sales,
        ROUND(AVG(SUM(fs.sales_amount))
            OVER(PARTITION BY fs.product_key, dp.product_name), 2) AS avg_yearly_sales,
        LAG(SUM(fs.sales_amount))
            OVER(
                PARTITION BY fs.product_key, dp.product_name
                ORDER BY EXTRACT(YEAR FROM fs.order_date)
                ) AS previous_year_sales
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_products AS dp
        ON fs.product_key = dp.product_key
    WHERE fs.order_date IS NOT NULL
    GROUP BY 
        fs.product_key, 
        dp.product_name, 
        EXTRACT(YEAR FROM fs.order_date)
)

SELECT 
    product_name,
    year,
    yearly_sales,
    avg_yearly_sales,
    ROUND(yearly_sales - avg_yearly_sales, 2)  AS sales_diff_to_avg,
    CASE 
        WHEN yearly_sales - avg_yearly_sales > 0 THEN 'Above Average'
        WHEN yearly_sales - avg_yearly_sales < 0 THEN 'Below Average'
        ELSE 'Same as Average'
    END AS sales_diff_to_avg_sales,
    previous_year_sales,
    yearly_sales - previous_year_sales AS YoY_sales_diff,
    CASE 
        WHEN yearly_sales - previous_year_sales > 0 THEN 'Above Previous Year'
        WHEN yearly_sales - previous_year_sales < 0 THEN 'Below Previous Year'
        ELSE 'Same as Previous Year'
    END AS YoY_sales_diff_change
FROM tbl1
ORDER BY product_name, year;