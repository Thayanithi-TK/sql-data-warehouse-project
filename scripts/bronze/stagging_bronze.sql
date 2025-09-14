
/*
================================================================
-- Staging Tables Creation
-- Stored procedures in this project cannot directly load data 
-- into the DWH Bronze tables. 
-- To handle this, we first create staging tables with the same 
-- structure as the source (Bronze layer).
-- Data is initially loaded into these staging tables, and then 
-- moved/transformed into the main warehouse tables via 
-- stored procedures.
=================================================================
*/

-- Staging tables --
CREATE TABLE IF NOT EXISTS staging_crm_cust_info LIKE dwh_bronze.crm_cust_info;
CREATE TABLE IF NOT EXISTS staging_crm_prd_info LIKE dwh_bronze.crm_prd_info;
CREATE TABLE IF NOT EXISTS staging_crm_sales_details LIKE dwh_bronze.crm_sales_details;
CREATE TABLE IF NOT EXISTS staging_erp_cust_az12 LIKE dwh_bronze.erp_cust_az12;
CREATE TABLE IF NOT EXISTS staging_erp_loc_a101 LIKE dwh_bronze.erp_loc_a101;
CREATE TABLE IF NOT EXISTS staging_erp_px_cat_g1v2 LIKE dwh_bronze.erp_px_cat_g1v2;
