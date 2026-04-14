USE [CRM_ERP_DataWarehouse]

INSERT INTO [silver].[crm_cust_info](
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_material_status,
cst_gndr,
cst_create_date)
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female' -- Change the gender column to use full words insead of letter,trim any spaces,use upper for the code to run on any case
	 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
ELSE 'Unknown'
END cst_gndr,
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single' -- Change the marital status column to use full words insead of letter,trim any spaces,use upper for the code to run on any case
	 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
ELSE 'Unknown'
END cst_marital_status,
cst_create_date
FROM 
( SELECT*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date desc) AS flag_last
FROM [bronze].[crm_cust_info]
WHERE cst_id IS NOT NULL)t
WHERE flag_last =1

SELECT * FROM [silver].[crm_cust_info]; 