IF OBJECT_ID('silver.crm_cust_info','U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_materialstatus NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_createdate DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)

IF OBJECT_ID('silver.crm_prd_info','U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()

);

IF OBJECT_ID('silver.crm_sales_detail','U') IS NOT NULL
	DROP TABLE silver.crm_sales_detail;

CREATE TABLE silver.crm_sales_detail(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()

);

IF OBJECT_ID('silver.erm_cust_AZ','U') IS NOT NULL
	DROP TABLE silver.erm_cust_AZ;

CREATE TABLE silver.erm_cust_AZ(
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);


IF OBJECT_ID('silver.erm_loc','U') IS NOT NULL
	DROP TABLE silver.erm_loc;

CREATE TABLE silver.erm_loc(
	cid NVARCHAR(50),
	cntry NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()

);

IF OBJECT_ID('silver.erm_p_cat','U') IS NOT NULL
	DROP TABLE silver.erm_p_cat;

CREATE TABLE silver.erm_p_cat(
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()

);
