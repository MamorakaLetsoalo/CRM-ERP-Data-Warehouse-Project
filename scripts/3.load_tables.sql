
/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

DECLARE @start_time  DATETIME, @end_time DATETIME;
--CRM TABLES
--Load data into customer info table

SET @start_time = GETDATE();
TRUNCATE TABLE [bronze].[crm_cust_info]
BULK INSERT [bronze].[crm_cust_info]
FROM 'C:\Users\Admin\Desktop\Data Engeneering Projects\CRM ERP Data warehouse project\CRM-ERP-Data-Warehouse-Project\raw_data\source CRM\cust_info.csv'
WITH(
     FIRSTROW = 2,
     FIELDTERMINATOR = ',',
     TABLOCK
     );
SET @end_time = GETDATE()
PRINT '>> load Duration: ' + CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR);


--Load data into product info table

TRUNCATE TABLE [bronze].[crm_prd_info]
BULK INSERT [bronze].[crm_prd_info]
FROM 'C:\Users\Admin\Desktop\Data Engeneering Projects\CRM ERP Data warehouse project\CRM-ERP-Data-Warehouse-Project\raw_data\source CRM\prd_info.csv'
WITH(
     FIRSTROW = 2,
     FIELDTERMINATOR = ',',
     TABLOCK
     );
  
  --Load data into sales details info table
TRUNCATE TABLE [bronze].[crm_sales_details]
BULK INSERT [bronze].[crm_sales_details]
FROM 'C:\Users\Admin\Desktop\Data Engeneering Projects\CRM ERP Data warehouse project\CRM-ERP-Data-Warehouse-Project\raw_data\source CRM\sales_details.csv'
WITH(
     FIRSTROW = 2,
     FIELDTERMINATOR = ',',
     TABLOCK
     );

     --ERP TABLES

  --Load data into customer erp info table
TRUNCATE TABLE [bronze].[erp_cust_az12]
BULK INSERT [bronze].[erp_cust_az12]
FROM 'C:\Users\Admin\Desktop\Data Engeneering Projects\CRM ERP Data warehouse project\CRM-ERP-Data-Warehouse-Project\raw_data\source ERP\CUST_AZ12.csv'
WITH(
     FIRSTROW = 2,
     FIELDTERMINATOR = ',',
     TABLOCK
     );

    --Load data into location erp info table
TRUNCATE TABLE [bronze].[erp_loc_a101]
BULK INSERT [bronze].[erp_loc_a101]
FROM 'C:\Users\Admin\Desktop\Data Engeneering Projects\CRM ERP Data warehouse project\CRM-ERP-Data-Warehouse-Project\raw_data\source ERP\LOC_A101.csv'
WITH(
     FIRSTROW = 2,
     FIELDTERMINATOR = ',',
     TABLOCK
     );  
     
--Load data into category erp info table
TRUNCATE TABLE [bronze].[erp_px_cat_g1v2]
BULK INSERT [bronze].[erp_px_cat_g1v2]
FROM 'C:\Users\Admin\Desktop\Data Engeneering Projects\CRM ERP Data warehouse project\CRM-ERP-Data-Warehouse-Project\raw_data\source ERP\PX_CAT_G1V2.csv'
WITH(
     FIRSTROW = 2,
     FIELDTERMINATOR = ',',
     TABLOCK
     );
END