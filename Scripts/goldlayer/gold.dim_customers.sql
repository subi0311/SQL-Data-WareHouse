USE DatawareHouse
GO 
CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	la.cntry,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'n/a') 
		END AS gender,
	ci.cst_materialstatus,
	ca.bdate,
	ci.cst_createdate
	
FROM 
	silver.crm_cust_info ci
	LEFT JOIN silver.erm_cust_AZ ca
	ON   ci.cst_key=ca.cid
	LEFT JOIN  silver.erm_loc la
	ON   ci.cst_key=la.cid
	


