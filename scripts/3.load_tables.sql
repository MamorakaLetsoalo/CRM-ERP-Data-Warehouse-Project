USE [CRM_ERP_DataWarehouse]

BULK INSERT [bronze].[crm_cust_info]
FROM 'C:\Users\Admin\Desktop\Data Engeneering Projects\CRM ERP Data warehouse project\CRM-ERP-Data-Warehouse-Project\raw_data\source CRM\cust_info.csv'
WITH(
     FIRSTROW = 2,
     FIELDTERMINATOR = ',',
     TABLOCK
     );

  