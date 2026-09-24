/*---------------------------------------------------------------------------
Segment products into cost ranges and
count how many products fall into each segment
---------------------------------------------------------------------------*/
SELECT
    cost_range,
    COUNT(product_key) AS total_products
FROM
(
    SELECT
        product_key,
        product_name,
        cost,
        CASE
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
) t
GROUP BY cost_range
ORDER BY total_products DESC;


/*---------------------------------------------------------------------------
Group customers into three segments based on their spending behavior:
    - VIP: at least 12 months of history and spending more than $5,000.
    - Regular: at least 12 months of history but spending $5,000 or less.
    - New: lifespan less than 12 months.
And find the total number of customers in each group.
---------------------------------------------------------------------------*/
WITH customers_spending AS
(
    SELECT
        c.customer_key,
        SUM(s.sales_amount)                                    AS total_spending,
        MIN(s.order_date)                                       AS first_order,
        MAX(s.order_date)                                       AS last_order,
        DATEDIFF(MONTH, MIN(s.order_date), MAX(s.order_date))   AS lifespan
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_customers c
        ON s.customer_key = c.customer_key
    GROUP BY c.customer_key
)

SELECT
    customer_segment,
    COUNT(*) AS customers_per_category
FROM
(
    SELECT
        customer_key,
        CASE
            WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customers_spending
) t
GROUP BY customer_segment;