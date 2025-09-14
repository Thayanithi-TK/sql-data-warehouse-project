/*
===========================================================================
Silver Layer Data Quality Checks 
===========================================================================
Purpose:
    Validate data in Silver tables for consistency, correctness, and completeness after clean Silver Layer.
    Checks performed:
      - Duplicate or NULL primary keys
      - Unwanted spaces in text columns
      - Negative or NULL numeric values
      - Data standardization & consistency
      - Valid date ranges
Expectation: No results for all checks if data quality is correct.
===========================================================================
*/





/*
===========================================================================
Silver Layer Data Quality Checks : crm_cust_info Table
===========================================================================
*/

--  Primary key uniqueness
SELECT cst_id, COUNT(*) AS cnt
FROM dwh_silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- NULL check for critical columns
SELECT *
FROM dwh_silver.crm_cust_info
WHERE cst_id IS NULL 
   OR cst_key IS NULL
   OR cst_firstname IS NULL
   OR cst_lastname IS NULL;

-- Leading/trailing spaces check
SELECT *
FROM dwh_silver.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname)
   OR cst_lastname <> TRIM(cst_lastname);

--  Standardized gender values check
SELECT *
FROM dwh_silver.crm_cust_info
WHERE cst_gndr NOT IN ('Male', 'Female', 'n/a');

--Standardized marital status values check
SELECT *
FROM dwh_silver.crm_cust_info
WHERE cst_marital_status NOT IN ('Married', 'Single', 'n/a');




/*
===========================================================================
Silver Layer Data Quality Checks : crm_prd_info Table
===========================================================================
*/
-- Check Duplicate and NULL in Primary Key
-- Expectation: No Results
SELECT 
    prd_id,
    COUNT(*) AS cnt
FROM dwh_silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) != 1 OR prd_id IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT prd_key
FROM dwh_silver.crm_prd_info
WHERE prd_key <> TRIM(prd_key);

SELECT prd_nm
FROM dwh_silver.crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);

-- Check Price is Negative or NULL
-- Expectation: No Results
SELECT *
FROM dwh_silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency
-- Expectation: Review distinct values
SELECT DISTINCT prd_line
FROM dwh_silver.crm_prd_info
ORDER BY prd_line;

-- Check Valid Date Ranges
-- Expectation: No Results
SELECT *
FROM dwh_silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;



/*
===========================================================================
Silver Layer Data Quality Checks: crm_sales_details Table
===========================================================================
*/

--  Primary key NULL and duplicates
SELECT * 
FROM dwh_silver.crm_sales_details
WHERE sls_ord_num IS NULL;

SELECT sls_ord_num, ls_prd_key, COUNT(*) AS cnt
FROM dwh_silver.crm_sales_details
GROUP BY sls_ord_num, ls_prd_key
HAVING COUNT(*) != 1;

--  Unwanted spaces in string columns
SELECT *
FROM dwh_silver.crm_sales_details
WHERE ls_prd_key <> TRIM(ls_prd_key);

--  Valid dates
SELECT *
FROM dwh_silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > NOW()
   OR sls_order_dt < '1990-10-10';

--Sales, Quantity, Price consistency
SELECT *
FROM dwh_silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales < 0
   OR sls_quantity < 0
   OR sls_price < 0;



/*
===========================================================================
Silver Layer Data Quality Checks: erp_cust_az12 Tables
===========================================================================

*/

-- Primary key NULL and duplicates
SELECT * 
FROM dwh_silver.erp_cust_az12
WHERE cid IS NULL;

SELECT cid, COUNT(*) AS cnt
FROM dwh_silver.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) != 1;

-- Unwanted spaces in string columns
SELECT * 
FROM dwh_silver.erp_cust_az12
WHERE gen <> TRIM(gen);

--  Valid Birth Dates
SELECT *
FROM dwh_silver.erp_cust_az12
WHERE bdate > NOW();





/*
===========================================================================
Silver Layer Data Quality Checks: erp_loc_a101
===========================================================================
*/

--Primary key uniqueness
SELECT cid, COUNT(*) AS cnt
FROM dwh_silver.erp_loc_a101
GROUP BY cid
HAVING COUNT(*) > 1;

--  NULL check for critical columns
SELECT *
FROM dwh_silver.erp_loc_a101
WHERE cid IS NULL
   OR cntry IS NULL;

-- Unwanted spaces check
SELECT *
FROM dwh_silver.erp_loc_a101
WHERE cid <> TRIM(cid)
   OR cntry <> TRIM(cntry);

--  Standardized country values check
SELECT *
FROM dwh_silver.erp_loc_a101
WHERE cntry NOT IN ('Germany', 'United States', 'n/a');





/*
===========================================================================
Silver Layer Data Quality Checks: erp_px_cat_g1v2
===========================================================================
*/

-- Primary key uniqueness
SELECT id, COUNT(*) AS cnt
FROM dwh_silver.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1;

--NULLs in critical columns
SELECT *
FROM dwh_silver.erp_px_cat_g1v2
WHERE id IS NULL
   OR cat IS NULL
   OR subcat IS NULL;

-- Unwanted spaces in string columns
SELECT *
FROM dwh_silver.erp_px_cat_g1v2
WHERE TRIM(cat) <> cat
   OR TRIM(subcat) <> subcat
   OR TRIM(maintenance) <> maintenance;

