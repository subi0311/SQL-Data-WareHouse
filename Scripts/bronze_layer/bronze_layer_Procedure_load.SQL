#Queries for load procedure of bronze layer as well as performing bulk insert
EXEC bronze.load_bronze

	CREATE OR ALTER PROCEDURE bronze.load_bronze as 
	BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
	SET @batch_start_time = GETDATE();
	PRINT '========================================';
	PRINT 'LOADING BRONZE LAYER';
	PRINT '========================================';
	
	PRINT '-----------------------';
	PRINT 'TRUNCATING CRM TABLES';
	PRINT '-----------------------';
	SET @start_time = GETDATE();
	PRINT '>>> TRUNCATING TABLE: bronze.crm_cust_info';
	TRUNCATE TABLE bronze.crm_cust_info

	PRINT '>>> INSERTING INTO TABLE: bronze.crm_cust_info';
	BULK INSERT bronze.crm_cust_info
	FROM 'C:\Users\MUHAMMAD SUBHAN KHAN\Desktop\EVERYTHING IN IT\Data analyst portfolio projects\SQL Warehouse Project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'LOADING DURATION:' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + 'seconds';
	PRINT '>>>>>>>>>>>>>>>>>'

	SET @start_time = GETDATE();
	PRINT '>>> TRUNCATING TABLE: bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info

	PRINT '>>> INSERTING INTO TABLE: bronze.crm_prd_info';
	BULK INSERT bronze.crm_prd_info
	FROM 'C:\Users\MUHAMMAD SUBHAN KHAN\Desktop\EVERYTHING IN IT\Data analyst portfolio projects\SQL Warehouse Project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'LOADING DURATION:' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + 'seconds';
	PRINT '>>>>>>>>>>>>>>>>>'

	SET @start_time = GETDATE();
	PRINT '>>> TRUNCATING TABLE: bronze.crm_sales_details';
	TRUNCATE TABLE bronze.crm_sales_detail

	PRINT '>>> INSERTING INTO TABLE: bronze.crm_sales_detail';
	BULK INSERT bronze.crm_sales_detail
	FROM 'C:\Users\MUHAMMAD SUBHAN KHAN\Desktop\EVERYTHING IN IT\Data analyst portfolio projects\SQL Warehouse Project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'LOADING DURATION:' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + 'seconds';
	PRINT '>>>>>>>>>>>>>>>>>'

	PRINT '-----------------------';
	PRINT 'TRUNCATING ERM TABLES';
	PRINT '-----------------------';
	SET @start_time = GETDATE();
	PRINT '>>> TRUNCATING TABLE: bronze.erm_locs'
	TRUNCATE TABLE bronze.erm_loc

	PRINT '>>> INSERTING INTO TABLE: bronze.erm_loc';
	BULK INSERT bronze.erm_loc
	FROM  'C:\Users\MUHAMMAD SUBHAN KHAN\Desktop\EVERYTHING IN IT\Data analyst portfolio projects\SQL Warehouse Project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'LOADING DURATION:' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + 'seconds';
	PRINT '>>>>>>>>>>>>>>>>>'

	SET @start_time = GETDATE();
	PRINT '>>> TRUNCATING TABLE: bronze.erm_cust_AZ12';
	TRUNCATE TABLE bronze.erm_cust_AZ12

	PRINT '>>> INSERTING INTO TABLE: bronze.erm_cust_AZ12';
	BULK INSERT bronze.erm_cust_AZ12
	FROM 'C:\Users\MUHAMMAD SUBHAN KHAN\Desktop\EVERYTHING IN IT\Data analyst portfolio projects\SQL Warehouse Project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'LOADING DURATION:' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + 'seconds';
	PRINT '>>>>>>>>>>>>>>>>>'


	SET @start_time = GETDATE();
	PRINT '>>> TRUNCATING TABLE: bronze.erm_p_cat'
	TRUNCATE TABLE bronze.erm_p_cat

	PRINT '>>> INSERTING INTO TABLE: bronze.erm_p_cat';
	BULK INSERT bronze.erm_p_cat
	FROM 'C:\Users\MUHAMMAD SUBHAN KHAN\Desktop\EVERYTHING IN IT\Data analyst portfolio projects\SQL Warehouse Project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'LOADING DURATION:' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + 'seconds';
	PRINT '>>>>>>>>>>>>>>>>>';

	SET @batch_end_time = GETDATE()
	PRINT 'BRONZE LAYER IS COMPLETED';
	PRINT 'DURATION OF LOADING BRONZE LAYER IS'+ CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS NVARCHAR) + 'second'
	PRINT '====================================';
	END TRY
	BEGIN CATCH
	PRINT '================================='
	PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
	PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
	PRINT 'ERROR MESSAGE' + CAST(ERROR_NUMBER() AS NVARCHAR)
	PRINT 'ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR)

	PRINT '=================================';
	END CATCH
END
