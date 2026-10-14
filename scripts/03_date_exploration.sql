USE DataWarehouse;
GO

--------------------------------------------------------------------------------
-- Find the date of the first and last order
-- How many years of sales are available
--------------------------------------------------------------------------------
SELECT
    MIN(order_date)                                        AS first_order_date,
    MAX(order_date)                                        AS last_order_date,
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date))       AS order_range_years
FROM gold.fact_sales;


--------------------------------------------------------------------------------
-- Find the youngest and the oldest customer
-- Show their age at the latest order in the data, so the result does
-- not change with the day the script is run
--------------------------------------------------------------------------------
WITH reference_date AS
(
    SELECT MAX(order_date) AS as_of_date
    FROM gold.fact_sales
),
birth_range AS
(
    SELECT
        MIN(birthdate) AS oldest_birthdate,
        MAX(birthdate) AS youngest_birthdate
    FROM gold.dim_customers
)

SELECT
    b.oldest_birthdate,
    DATEDIFF(YEAR, b.oldest_birthdate, r.as_of_date)
        - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, b.oldest_birthdate, r.as_of_date), b.oldest_birthdate) > r.as_of_date
               THEN 1 ELSE 0 END   AS oldest_age,
    b.youngest_birthdate,
    DATEDIFF(YEAR, b.youngest_birthdate, r.as_of_date)
        - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, b.youngest_birthdate, r.as_of_date), b.youngest_birthdate) > r.as_of_date
               THEN 1 ELSE 0 END   AS youngest_age
FROM birth_range b
CROSS JOIN reference_date r;