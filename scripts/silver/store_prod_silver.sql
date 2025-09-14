
/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Purpose:
    Populate Silver tables from Bronze by truncating and inserting cleaned data.
    Performs ETL transformations to prepare data for the Gold layer.

Usage:
    EXEC Silver.load_silver;
===============================================================================
*/



DELIMITER //

CREATE PROCEDURE dwh_silver.load_silver()
BEGIN
    DECLARE start_time DATETIME;
    DECLARE end_time DATETIME;
    DECLARE batch_start_time DATETIME;
    DECLARE batch_end_time DATETIME;
    DECLARE error_msg VARCHAR(255);
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_msg = MESSAGE_TEXT;
SELECT CONCAT('ERROR OCCURRED: ', error_msg) AS message;
    END;

    -- Batch start
    SET batch_start_time = NOW();

SELECT '================================================' AS message;
SELECT 'Load the Data in Bronze to Silver AS message' AS message;
SELECT '================================================' AS message;

    -- ===================== CRM Tables =====================
SELECT '------------------------------------------------' AS message;
SELECT 'Loading CRM Tables' AS message;
SELECT '------------------------------------------------' AS message;

    -- crm_cust_info
    SET start_time = NOW();
    BEGIN
    
		SELECT'Truncate Table --->>dwh_silver.crm_cust_info<<----  ';
		TRUNCATE dwh_silver.crm_cust_info;
		SELECT'Insert Table --->>dwh_silver.crm_cust_info<<---- ';
		INSERT INTO dwh_silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date)

		SELECT
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname,
		TRIM(cst_lastname) AS cst_lastname,
		CASE WHEN UPPER(TRIM(cst_marital_status)) = "M" THEN "Married"
			 WHEN UPPER(TRIM(cst_marital_status))="S" THEN "Single"
			 ELSE "n/a"
		END AS cst_marital_status,
		CASE WHEN UPPER(TRIM(cst_gndr)) = "M" THEN "Male"
			 WHEN UPPER(TRIM(cst_gndr))="F" THEN "Female"
			 ELSE "n/a"
		END AS cst_gndr,
		cst_create_date
		FROM(
		SELECT 
		*,
		ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) flage_first
		FROM dwh_bronze.crm_cust_info
		) t WHERE flage_first=1 AND cst_create_date IS NOT NULL;

    END;
    SET end_time = NOW();
SELECT 
    CONCAT('>> Load Duration: ',TIMESTAMPDIFF(SECOND,start_time,end_time),' seconds') AS message;

    -- crm_prd_info
    SET start_time = NOW();
    BEGIN
    
		SELECT'Truncate Table --->>dwh_silver.crm_prd_info<<----  ';
		TRUNCATE dwh_silver.crm_prd_info;
		SELECT'Insert Table --->>dwh_silver.crm_prd_info<<----    ';
		INSERT INTO dwh_silver.crm_prd_info(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
		)
		SELECT prd_id,
		REPLACE(SUBSTRING(prd_key,1,5),'-','_')AS cat_id,
		SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key,
		TRIM(prd_nm) AS prd_nm,
		IFNULL(prd_cost, 0) AS prd_cost,
		CASE upper(TRIM(prd_line))
			WHEN "M" THEN "Mountain"
			WHEN "R" THEN "Road"
			WHEN "S" THEN "Other Sales"
			WHEN "T" THEN "Touring"
			ELSE "n/a"
		END AS prd_line  ,
		prd_start_dt,
		LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) -INTERVAL +1 DAY as prd_end_dt
		FROM dwh_bronze.crm_prd_info;
    END;
    SET end_time = NOW();
SELECT 
    CONCAT('>> Load Duration: ',TIMESTAMPDIFF(SECOND,start_time,end_time),' seconds') AS message;

    -- crm_sales_details
    SET start_time = NOW();
    BEGIN
			
		SELECT'Truncate Table --->>dwh_silver.crm_sales_details<<----  ';
		TRUNCATE dwh_silver.crm_sales_details;
		SELECT'Insert Table --->>dwh_silver.crm_sales_details<<----    ';
		INSERT INTO dwh_silver.crm_sales_details(
			sls_ord_num,
			ls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price)
		SELECT 
			sls_ord_num,
			ls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price )
				 THEN sls_quantity * ABS(sls_price)
				 ELSE sls_sales
			END AS sales   ,
			sls_quantity,
			CASE WHEN sls_price IS NULL OR sls_price <=0 
				 THEN sls_sales / NULLIF(sls_quantity,0)
				 ELSE sls_price
			END AS sls_price     
		FROM dwh_bronze.crm_sales_details;
    
    END;
    SET end_time = NOW();
SELECT 
    CONCAT('>> Load Duration: ',TIMESTAMPDIFF(SECOND,start_time,end_time),' seconds') AS message;

    -- ===================== ERP Tables =====================
SELECT '------------------------------------------------' AS message;
SELECT 'Loading ERP Tables' AS message;
SELECT '------------------------------------------------' AS message;

    -- erp_cust_az12
    SET start_time = NOW();
    BEGIN
    
		SELECT'Truncate Table --->>dwh_silver.erp_cust_az12<<----  ';
		TRUNCATE dwh_silver.erp_cust_az12;
		SELECT'Insert Table --->>dwh_silver.erp_cust_az12<<----    ';
		INSERT INTO dwh_silver.erp_cust_az12(
			cid,
			bdate,
			gen)

		SELECT 
		CASE WHEN cid LIKE 'NASA%' THEN SUBSTRING(cid,4,LENGTH(cid)) 
			 ELSE cid
		END AS cid,
		CASE WHEN bdate >NOW() THEN null
			 ELSE bdate
		END AS bdate,
		CASE
			WHEN REGEXP_LIKE(gen, '^[[:space:]]*(M|MALE)[[:space:]]*$', 'i') THEN 'Male'
			WHEN REGEXP_LIKE(gen, '^[[:space:]]*(F|FEMALE|FEMAL)[[:space:]]*$', 'i') THEN 'Female'
			ELSE 'n/a'
		  END AS gen_clean   
		 FROM dwh_bronze.erp_cust_az12;
			  
    END;
    SET end_time = NOW();
SELECT 
    CONCAT('>> Load Duration: ',TIMESTAMPDIFF(SECOND,start_time,end_time),' seconds') AS message;

    -- erp_loc_a101
    SET start_time = NOW();
    BEGIN
       
		SELECT'Truncate Table --->>dwh_silver.erp_loc_a101<<----  ';
		TRUNCATE dwh_silver.erp_loc_a101;
		SELECT'Insert Table --->>dwh_silver.erp_loc_a101<<----    ';
		INSERT INTO dwh_silver.erp_loc_a101(
			cid,
			cntry
			)
		SELECT 
		REPLACE (cid,'-','') as cid,
		CASE
				WHEN REGEXP_LIKE(cntry, '^[[:space:]]*DE[[:space:]]*$', 'i') THEN 'Germany'
				WHEN REGEXP_LIKE(cntry, '^[[:space:]]*(US|USA)[[:space:]]*$', 'i') THEN 'United States'
				WHEN cntry IS NULL OR TRIM(cntry) = '' THEN 'n/a'
				ELSE TRIM(cntry)
			END AS cntry_clean
		FROM dwh_bronze.erp_loc_a101;
        
    END;
    SET end_time = NOW();
SELECT 
    CONCAT('>> Load Duration: ',TIMESTAMPDIFF(SECOND,start_time,end_time),' seconds') AS message;

    -- erp_px_cat_g1v2
    SET start_time = NOW();
    BEGIN
      
		SELECT'Truncate Table --->>dwh_silver.erp_px_cat_g1v2<<----  ';
		TRUNCATE dwh_silver.erp_px_cat_g1v2;
		SELECT'Insert Table --->>dwh_silver.erp_px_cat_g1v2<<----    ';
		INSERT INTO dwh_silver.erp_px_cat_g1v2(
			id,
			cat,
			subcat,
			maintenance
			)
		SELECT id,
			cat,
			subcat,
			maintenance
		FROM dwh_bronze.erp_px_cat_g1v2;
        
    END;
    SET end_time = NOW();
SELECT 
    CONCAT('>> Load Duration: ',TIMESTAMPDIFF(SECOND,start_time,end_time),' seconds') AS message;

    -- Batch end
    SET batch_end_time = NOW();
SELECT '================================================' AS message;
SELECT 
    CONCAT('Total Load Duration: ',TIMESTAMPDIFF(SECOND,batch_start_time,batch_end_time),' seconds') AS message;
    
SELECT 'Finished loading Bronze Layer (CRM + ERP tables)' AS message;
SELECT '================================================' AS message;

END //

DELIMITER ;


CALL dwh_silver.load_silver()
