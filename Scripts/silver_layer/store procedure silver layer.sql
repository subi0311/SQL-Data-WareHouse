-- Insert unique customer data into silver.crm_cust_info
--crm_cust_info
EXEC silver.load_silver

CREATE OR ALTER PROCEDURE  silver.load_silver AS
BEGIN

	PRINT '>>TRUNCATING silver.crm_cust_info'
	TRUNCATE TABLE silver.crm_cust_info;
	PRINT '>>INSERT INTO silver.crm_cust_info'
	INSERT INTO silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_materialstatus,
	cst_gndr,
	cst_createdate
	)
	SELECT 
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname,
		TRIM(cst_lastname) AS cst_lastname,
		CASE 
			WHEN UPPER(TRIM(cst_materialstatus)) = 'M' THEN 'Married'
			WHEN UPPER(TRIM(cst_materialstatus)) = 'S' THEN 'Single'
			ELSE 'N/A'
			END cst_materialstatus,
		CASE 
			WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
			WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
			ELSE 'N/A'
			END  cst_gndr,
			cst_createdate
	FROM (
		SELECT *, 
			   ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_createdate DESC) AS red_flag
		FROM bronze.crm_cust_info
	) t 
	WHERE red_flag = 1 AND cst_id IS NOT NULL;







	--crm prd_info
	IF OBJECT_ID('silver.crm_prd_info','U') IS NOT NULL
		DROP TABLE silver.crm_prd_info;
	CREATE TABLE silver.crm_prd_info(
	prd_id INT,
	cat_id NVARCHAR(30),
	prd_key NVARCHAR(50),
	prd_num NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(30),
	prd_start_date DATE,
	prd_end_date DATE,
	dwh_create_date DATETIME DEFAULT GETDATE()
	)



	--crm_prd_info
	
	PRINT '>>TRUNCATING silver.crm_prd_info'
	TRUNCATE TABLE silver.crm_prd_info;
	PRINT '>>INSERTING INTO silver.crm_prd_info'
	INSERT INTO silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_num,
	prd_cost,
	prd_line,
	prd_start_date,
	prd_end_date
	)
	SELECT 
		prd_id,
		REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
		SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
		prd_nm,
		ISNULL(prd_cost, 0) AS prd_cost,
		CASE UPPER(TRIM(prd_line)) 
			WHEN 'R' THEN 'ROAD'
			WHEN 'S' THEN 'OTHER SALES' 
			WHEN 'M' THEN 'MOUNTAIN'
			WHEN 'T' THEN 'TOURING'
			ELSE 'N/A'
		END AS prd_line,
		CAST(prd_start_dt AS DATE) AS prd_start_date,
		DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
	FROM bronze.crm_prd_info;




	--crm sales detail
	IF OBJECT_ID('silver.crm_sales_detail','U') IS NOT NULL
		DROP TABLE silver.crm_sales_detail;

	CREATE TABLE silver.crm_sales_detail(
		sls_ord_num NVARCHAR(50),
		sls_prd_key NVARCHAR(50),
		sls_cust_id INT,
		sls_order_dt DATE,
		sls_ship_dt DATE,
		sls_due_dt DATE,
		sls_sales INT,
		sls_quantity INT,
		sls_price INT,
		dwh_create_date DATETIME2 DEFAULT GETDATE()

	);

	PRINT '>>TRUNCATING silver.crm_sales_detail'
	TRUNCATE TABLE silver.crm_sales_detail;
	PRINT '>>INSERTING INTO silver.crm_sales_detail'
	INSERT INTO silver.crm_sales_detail(
		sls_ord_num,
		sls_prd_key ,
		sls_cust_id ,
		sls_order_dt ,
		sls_ship_dt ,
		sls_due_dt ,
		sls_sales ,
		sls_quantity ,
		sls_price 
	)
	SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE WHEN 
		sls_order_dt <=0
		OR LEN(sls_order_dt) !=8 THEN NULL
		ELSE CAST(CAST(sls_order_dt AS nvarchar) AS DATE)
	END AS sls_order_dt,
	CASE WHEN 
		sls_ship_dt <=0
		OR LEN(sls_ship_dt) !=8 THEN NULL
		ELSE CAST(CAST(sls_ship_dt AS nvarchar) AS DATE)
	END AS sls_ship_dt,
	CASE WHEN 
		sls_due_dt <=0
		OR LEN(sls_due_dt) !=8 THEN NULL
		ELSE CAST(CAST(sls_due_dt AS nvarchar) AS DATE)
	END AS sls_order_dt,
	CASE WHEN sls_sales IS NULL OR sls_sales<=0 OR sls_sales!= sls_quantity*ABS(sls_price)
		THEN sls_quantity*ABS(sls_price)
		ELSE sls_sales
		END sls_sales,
	sls_quantity,
	CASE WHEN sls_price IS NULL OR sls_price <=0
		THEN sls_sales/NULLIF(sls_quantity,0)
		ELSE sls_price
		END AS sls_price
	FROM
	bronze.crm_sales_detail



	-- Silver.erm_cst_AZ
	
	PRINT '>>TRUNCATING silver.erm_cust_AZ'
	TRUNCATE TABLE silver.erm_cust_AZ;
	PRINT '>>INSERTING INTO silver.erm_cust_AZ'
	INSERT INTO silver.erm_cust_AZ(
	cid,
	bdate,
	gen)
	SELECT 
	CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
	ELSE cid
	END cid,
	CASE WHEN bdate> GETDATE() THEN NULL
	ELSE bdate
	END as bdate,
	CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
		WHEN UPPER(TRIM(gen)) IN  ('M','MALE') THEN 'Male'
		ELSE 'N/A'
		END AS gen
	FROM bronze.erm_cust_AZ12



	--erm location
	PRINT '>>TRUNCATING silver.erm_loc'
	TRUNCATE TABLE silver.erm_loc;
	PRINT '>>INSERTING INTO silver.erm_loc'
	INSERT INTO silver.erm_loc(
	cid,
	cntry)
	SELECT 
	REPLACE(cid,'-','') cid,
	CASE WHEN TRIM(cntry) ='DE' THEN 'GERMANY'
		 WHEN TRIM(cntry) IN ('US','USA') THEN 'UNITED STATES'
		 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
		 ELSE TRIM(cntry)
		 END AS cntry
	FROM
	bronze.erm_loc




	--erm_prd_cat
	PRINT '>>TRUNCATING silver.erm_p_cat'
	TRUNCATE TABLE silver.erm_p_cat;
	PRINT '>>INSERTING INTO silver.erm_p_cat'
	INSERT INTO silver.erm_p_cat
	(id,
	cat,
	subcat,
	maintenance)
	SELECT * FROM bronze.erm_p_cat
END











