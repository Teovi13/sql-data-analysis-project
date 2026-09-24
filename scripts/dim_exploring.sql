--------------------------------------------------------------------------------
-- Explore all countries our customers come from
--------------------------------------------------------------------------------
SELECT DISTINCT
    country
FROM gold.dim_customers;


--------------------------------------------------------------------------------
-- Explore all categories, subcategories, and products
--------------------------------------------------------------------------------
SELECT DISTINCT
    category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY 1, 2, 3;