--------------------------------------------------------------------------------
-- Which 5 products generate the highest revenue?
--------------------------------------------------------------------------------

-- Approach 1: TOP N
SELECT TOP 5
    p.product_name,
    SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
    ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Approach 2: Window function (ROW_NUMBER)
SELECT *
FROM
(
    SELECT
        p.product_name,
        SUM(s.sales_amount)                                        AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(s.sales_amount) DESC)       AS rank_products
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
    GROUP BY p.product_name
) t
WHERE rank_products <= 5;


--------------------------------------------------------------------------------
-- What are the 5 worst-performing products in terms of sales?
--------------------------------------------------------------------------------

-- Approach 1: TOP N
SELECT TOP 5
    p.product_name,
    SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
    ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;

-- Approach 2: Window function (ROW_NUMBER)
SELECT *
FROM
(
    SELECT
        p.product_name,
        SUM(s.sales_amount)                                   AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(s.sales_amount) ASC)  AS rank_products
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
    GROUP BY p.product_name
) t
WHERE rank_products <= 5;