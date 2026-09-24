/*---------------------------------------------------------------------------
Calculate the total sales per month
and the running total sales over time
---------------------------------------------------------------------------*/
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date)   AS running_total,
    AVG(average_price) OVER (ORDER BY order_date) AS moving_average_price
FROM
(
    SELECT
        DATETRUNC(MONTH, order_date) AS order_date,
        SUM(sales_amount)            AS total_sales,
        AVG(price)                   AS average_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
) t
ORDER BY order_date;