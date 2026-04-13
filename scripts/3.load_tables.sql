USE [CRM_ERP_DataWarehouse]


--Load data into customer info table
TRUNCATE TABLE [bronze].[crm_cust_info]
BULK INSERT [bronze].[crm_cust_info]
FROM 'C:\Users\Admin\Desktop\Data Engeneering Projects\CRM ERP Data warehouse project\CRM-ERP-Data-Warehouse-Project\raw_data\source CRM\cust_info.csv'
WITH(
     FIRSTROW = 2,
     FIELDTERMINATOR = ',',
     TABLOCK
     );

--Load data into product info table
TRUNCATE TABLE [bronze].[crm_prd_info]
BULK INSERT [bronze].[crm_prd_info]
FROM 'C:\Users\Admin\Desktop\Data Engeneering Projects\CRM ERP Data warehouse project\CRM-ERP-Data-Warehouse-Project\raw_data\source CRM\prd_info.csv'
WITH(
     FIRSTROW = 2,
     FIELDTERMINATOR = ',',
     TABLOCK
     );
  
  --Load data into product info table
TRUNCATE TABLE [bronze].[crm_sales_details]
BULK INSERT [bronze].[crm_sales_details]
FROM 'C:\Users\Admin\Desktop\Data Engeneering Projects\CRM ERP Data warehouse project\CRM-ERP-Data-Warehouse-Project\raw_data\source CRM\sales_details.csv'
WITH(
     FIRSTROW = 2,
     FIELDTERMINATOR = ',',
     TABLOCK
     );
