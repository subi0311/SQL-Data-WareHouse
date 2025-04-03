CREATE VIEW gold.fact_sales AS
SELECT 
sls_ord_num AS order_number,
pd.product_number,
cd.cst_id,
sls_order_dt AS order_date,
sls_ship_dt AS Ship_date,
sls_due_dt AS due_date,
sls_sales AS sales,
sls_quantity AS quantity,
sls_price AS price
FROM silver.crm_sales_detail sd
LEFT JOIN gold.dim_customers cd
ON sd.sls_cust_id = cd.cst_id
LEFT JOIN gold.dim_products pd
ON sd.sls_prd_key = pd.product_number

