-- Quality Assurance
--Checking Null Values
SELECT cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

--
USE DatawareHouse
GO
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL 

SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

SELECT * FROM
silver.crm_prd_info
 
--CHECKING INVALID DATE
		SELECT *
		FROM silver.crm_prd_info
		WHERE prd_end_date<prd_start_date



SELECT 
NULLIF(sls_order_dt,0) AS sls_order_dt
FROM bronze.crm_sales_detail
WHERE sls_order_dt <=0
OR LEN(sls_order_dt) !=8
OR sls_order_dt >20500101
OR sls_order_dt <19000101


SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM
bronze.crm_sales_detail
WHERE sls_sales != sls_price*sls_quantity
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0
ORDER BY sls_sales,sls_quantity,sls_price


USE DatawareHouse
GO
SELECT DISTINCT 
gen
FROM bronze.erm_cust_AZ12

EXEC bronze.load_bronze
EXEC silver.load_silver