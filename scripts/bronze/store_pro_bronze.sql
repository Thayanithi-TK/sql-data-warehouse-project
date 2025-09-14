/*
======================================================================
Create Store Procedure : dwh_bronze.load_bronze()
======================================================================
-- Procedure: dwh_bronze.load_bronze()
-- Loads data from staging tables into Bronze layer.
-- Steps: Truncate Bronze tables → Insert from staging → Log duration.
-- Used to refresh CRM & ERP Bronze tables with latest staged data.
*/


DELIMITER //

CREATE PROCEDURE dwh_bronze.load_bronze()
BEGIN
    DECLARE start_time DATETIME;
    DECLARE end_time DATETIME;
    DECLARE batch_start_time DATETIME;
    DECLARE batch_end_time DATETIME;
    DECLARE error_msg VARCHAR(255);

    -- Error handler
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
		    error_msg = MESSAGE_TEXT;
SELECT CONCAT('ERROR OCCURRED: ', error_msg) AS message;
    END;

    -- Batch start
    SET batch_start_time = NOW();

SELECT '================================================' AS message;
SELECT 'Loading Bronze Layer - CRM + ERP Tables' AS message;
SELECT '================================================' AS message;

    -- ===================== CRM Tables =====================
SELECT '------------------------------------------------' AS message;
SELECT 'Loading CRM Tables' AS message;
SELECT '------------------------------------------------' AS message;

    -- crm_cust_info
    SET start_time = NOW();
    BEGIN
        SELECT '>> Truncating Table: dwh_bronze.crm_cust_info' AS message;
        TRUNCATE TABLE dwh_bronze.crm_cust_info;
SELECT '>> Inserting Data Into: dwh_bronze.crm_cust_info' AS message;
        INSERT INTO dwh_bronze.crm_cust_info (
            cst_id, cst_key, cst_firstname, cst_lastname,
            cst_marital_status, cst_gndr, cst_create_date
        )
        SELECT
            cst_id, cst_key, cst_firstname, cst_lastname,
            cst_marital_status, cst_gndr,
            NULLIF(cst_create_date, '0000-00-00')
        FROM staging_crm_cust_info;
    END;
    SET end_time = NOW();
SELECT 
    CONCAT('>> Load Duration: ',
            TIMESTAMPDIFF(SECOND,
                start_time,
                end_time),
            ' seconds') AS message;

    -- crm_prd_info
    SET start_time = NOW();
    BEGIN
        SELECT '>> Truncating Table: dwh_bronze.crm_prd_info' AS message;
        TRUNCATE TABLE dwh_bronze.crm_prd_info;
SELECT '>> Inserting Data Into: dwh_bronze.crm_prd_info' AS message;
        INSERT INTO dwh_bronze.crm_prd_info
        SELECT * FROM staging_crm_prd_info;
    END;
    SET end_time = NOW();
SELECT 
    CONCAT('>> Load Duration: ',
            TIMESTAMPDIFF(SECOND,
                start_time,
                end_time),
            ' seconds') AS message;

    -- crm_sales_details
    SET start_time = NOW();
    BEGIN
        SELECT '>> Truncating Table: dwh_bronze.crm_sales_details' AS message;
        TRUNCATE TABLE dwh_bronze.crm_sales_details;
SELECT '>> Inserting Data Into: dwh_bronze.crm_sales_details' AS message;
        INSERT INTO dwh_bronze.crm_sales_details
        SELECT * FROM staging_crm_sales_details;
    END;
    SET end_time = NOW();
SELECT 
    CONCAT('>> Load Duration: ',
            TIMESTAMPDIFF(SECOND,
                start_time,
                end_time),
            ' seconds') AS message;

    -- ===================== ERP Tables =====================
SELECT '------------------------------------------------' AS message;
SELECT 'Loading ERP Tables' AS message;
SELECT '------------------------------------------------' AS message;

    -- erp_cust_az12
    SET start_time = NOW();
    BEGIN
        SELECT '>> Truncating Table: dwh_bronze.erp_cust_az12' AS message;
        TRUNCATE TABLE dwh_bronze.erp_cust_az12;
SELECT '>> Inserting Data Into: dwh_bronze.erp_cust_az12' AS message;
        INSERT INTO dwh_bronze.erp_cust_az12
        SELECT * FROM staging_erp_cust_az12;
    END;
    SET end_time = NOW();
SELECT 
    CONCAT('>> Load Duration: ',
            TIMESTAMPDIFF(SECOND,
                start_time,
                end_time),
            ' seconds') AS message;

    -- erp_loc_a101
    SET start_time = NOW();
    BEGIN
        SELECT '>> Truncating Table: dwh_bronze.erp_loc_a101' AS message;
        TRUNCATE TABLE dwh_bronze.erp_loc_a101;
SELECT '>> Inserting Data Into: dwh_bronze.erp_loc_a101' AS message;
        INSERT INTO dwh_bronze.erp_loc_a101
        SELECT * FROM staging_erp_loc_a101;
    END;
    SET end_time = NOW();
SELECT 
    CONCAT('>> Load Duration: ',
            TIMESTAMPDIFF(SECOND,
                start_time,
                end_time),
            ' seconds') AS message;

    -- erp_px_cat_g1v2
    SET start_time = NOW();
    BEGIN
        SELECT '>> Truncating Table: dwh_bronze.erp_px_cat_g1v2' AS message;
        TRUNCATE TABLE dwh_bronze.erp_px_cat_g1v2;
SELECT '>> Inserting Data Into: dwh_bronze.erp_px_cat_g1v2' AS message;
        INSERT INTO dwh_bronze.erp_px_cat_g1v2
        SELECT * FROM staging_erp_px_cat_g1v2;
    END;
    SET end_time = NOW();
SELECT 
    CONCAT('>> Load Duration: ',
            TIMESTAMPDIFF(SECOND,
                start_time,
                end_time),
            ' seconds') AS message;

    -- Batch end
    SET batch_end_time = NOW();
SELECT '================================================' AS message;
SELECT 
    CONCAT('Total Load Duration: ',
            TIMESTAMPDIFF(SECOND,
                batch_start_time,
                batch_end_time),
            ' seconds') AS message;
SELECT 'Finished loading Bronze Layer (CRM + ERP tables)' AS message;
SELECT '================================================' AS message;

END //

DELIMITER ;
