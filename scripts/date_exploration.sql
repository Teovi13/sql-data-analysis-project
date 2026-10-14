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
-- Show the age of them
--------------------------------------------------------------------------------
WITH birth_range AS
(
    SELECT
        MIN(birthdate) AS oldest_birthdate,
        MAX(birthdate) AS youngest_birthdate
    FROM gold.dim_customers
)

SELECT
    oldest_birthdate,
    DATEDIFF(YEAR, oldest_birthdate, GETDATE())
        - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, oldest_birthdate, GETDATE()), oldest_birthdate) > GETDATE()
               THEN 1 ELSE 0 END   AS oldest_age,
    youngest_birthdate,
    DATEDIFF(YEAR, youngest_birthdate, GETDATE())
        - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, youngest_birthdate, GETDATE()), youngest_birthdate) > GETDATE()
               THEN 1 ELSE 0 END   AS youngest_age
FROM birth_range;