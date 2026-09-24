--------------------------------------------------------------------------------
-- Explore all objects in the database
--------------------------------------------------------------------------------
SELECT *
FROM INFORMATION_SCHEMA.TABLES;


--------------------------------------------------------------------------------
-- Explore all columns for a specific table
--------------------------------------------------------------------------------
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';