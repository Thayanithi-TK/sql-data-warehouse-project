/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Purpose:
    Create business-ready views in the Gold layer (Star Schema).
    Views transform and join Silver layer data into clean fact & dimension tables.

Usage:
    Query these views directly for analytics and reporting.
===============================================================================
*/


/*
===============================================================================
Create Dimention (Views)
===============================================================================
*/


-- Create View dwh_gold.dim_customer
CREATE VIEW dwh_gold.dim_customer AS
    SELECT 
      ROW_NUMBER() OVER( ORDER BY ca.cst_id ) AS customer_key,
        ca.cst_id AS customer_id,
        ca.cst_key AS customer_number,
        ca.cst_firstname AS first_name,
        ca.cst_lastname AS last_name,
        cl.cntry AS country,
        cb.bdate AS birthdate,
        CASE WHEN ca.cst_gndr !='n/a' THEN ca.cst_gndr
             ELSE COALESCE(cb.gen,'n/a')
        END AS gender,
        ca.cst_marital_status AS marital_status,
        ca.cst_create_date AS create_date
    FROM dwh_silver.crm_cust_info ca
    LEFT JOIN dwh_silver.erp_cust_az12 cb
    ON ca.cst_key =cb.cid
    LEFT JOIN dwh_silver.erp_loc_a101 cl
    ON ca.cst_key = cl.cid


--Create View dwh_gold.dim_product

CREATE VIEW dwh_gold.dim_product AS
  	SELECT 
    		ROW_NUMBER() OVER(ORDER BY pi.prd_id ) AS product_key,
    		pi.prd_id AS product_id,
    		pi.prd_key AS product_number,
    		pi.prd_nm AS product_name ,
    		pi.cat_id AS category_id,
    		pc.cat AS category,
    		pc.subcat AS subcategory,
    		pc.maintenance,
    		pi.prd_cost AS cost,
    		pi.prd_line AS product_line,
    		pi.prd_start_dt AS start_date
  	FROM dwh_silver.crm_prd_info pi
  	LEFT JOIN dwh_silver.erp_px_cat_g1v2 pc
  	ON pi.cat_id =pc.id
  	WHERE pi.prd_end_dt IS NULL -- current data only filter historical data
  
  

/*
===============================================================================
Create Fact (Views)
===============================================================================
*/

--Create View dwh_gold.fact_sales

CREATE VIEW dwh_gold.fact_sales AS
    SELECT 
        sl.sls_ord_num AS order_number,
        pr.product_key ,
        cr.customer_key,
        sl.sls_cust_id AS customer_id,
        sl.sls_order_dt AS order_date,
        sl.sls_ship_dt AS shipping_date,
        sl.sls_due_dt AS due_date,
        sl.sls_sales AS sales_amount,
        sl.sls_quantity AS quantity,
        sl.sls_price AS price
     FROM dwh_silver.crm_sales_details sl
     LEFT JOIN dwh_gold.dim_product pr
     ON sl.ls_prd_key=pr.product_number
     LEFT JOIN dwh_gold.dim_customer cr
     ON sl.sls_cust_id = cr.customer_id
     





