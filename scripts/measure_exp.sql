--------------------------------------------------------------------------------
-- Find the total sales
--------------------------------------------------------------------------------
SELECT SUM(sales_amount) AS total_sales
FROM gold.fact_sales;


--------------------------------------------------------------------------------
-- Find the average selling price
--------------------------------------------------------------------------------
SELECT AVG(price) AS average_price
FROM gold.fact_sales;


--------------------------------------------------------------------------------
-- Find the total number of orders
--------------------------------------------------------------------------------
SELECT COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;


--------------------------------------------------------------------------------
-- Find the total number of products
--------------------------------------------------------------------------------
SELECT COUNT(product_key) AS total_products
FROM gold.dim_products;


--------------------------------------------------------------------------------
-- Find the total number of customers
--------------------------------------------------------------------------------
SELECT COUNT(customer_key) AS total_customers
FROM gold.dim_customers;


--------------------------------------------------------------------------------
-- Find the total number of customers that placed an order
--------------------------------------------------------------------------------
SELECT COUNT(DISTINCT customer_key) AS customers_with_orders
FROM gold.fact_sales;


--------------------------------------------------------------------------------
-- Generate a report that shows all key metrics of the business
--------------------------------------------------------------------------------
SELECT 'Total Sales'                  AS measure_name, SUM(sales_amount)             AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity',                                SUM(quantity)                                 FROM gold.fact_sales
UNION ALL
SELECT 'Average Price',                                 AVG(price)                                    FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders',                                  COUNT(DISTINCT order_number)                  FROM gold.fact_sales
UNION ALL
SELECT 'Total Products',                                COUNT(product_key)                             FROM gold.dim_products
UNION ALL
SELECT 'Total Customers',                               COUNT(customer_key)                            FROM gold.dim_customers
UNION ALL
SELECT 'Customers with Orders',                         COUNT(DISTINCT customer_key)                   FROM gold.fact_sales;