CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY pn.prd_start_date, pn.prd_key) AS prodcut_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_num AS product_name,
	pn.prd_line AS product_line,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS prodcut_cost,
	pn.prd_start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erm_p_cat pc
ON pc.id=pn.cat_id
WHERE prd_end_date IS NULL



