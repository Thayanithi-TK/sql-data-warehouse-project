/*
===========================================================================
Gold Layer Data Quality Checks
===========================================================================
Purpose:
    Validate data integrity, consistency, and correctness in Gold Layer tables.
Checks:
     Uniqueness of surrogate keys in dimensions
     Referential integrity between fact and dimension tables
     Null checks in critical columns
     Fact table metric consistency
===========================================================================
*/

-- =====================================================
--  Dimension Table Checks
-- =====================================================

--  dim_customers: Check uniqueness of customer_key
SELECT customer_key, COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- dim_customers: Check for NULLs in critical columns
SELECT *
FROM gold.dim_customers
WHERE customer_key IS NULL
   OR customer_name IS NULL;

-- dim_products: Check uniqueness of product_key
SELECT product_key, COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- dim_products: Check for NULLs in critical columns
SELECT *
FROM gold.dim_products
WHERE product_key IS NULL
   OR product_name IS NULL
   OR product_category IS NULL;

-- =====================================================
-- Fact Table Checks
-- =====================================================

-- Referential integrity with dim_customers and dim_products
SELECT f.sales_id, f.customer_key, f.product_key
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL;

-- Null checks in fact metrics
SELECT *
FROM gold.fact_sales
WHERE sales_amount IS NULL
   OR quantity IS NULL
   OR price IS NULL;

--  Consistency check: Sales amount = quantity * price
SELECT *
FROM gold.fact_sales
WHERE sales_amount != quantity * price;
;

