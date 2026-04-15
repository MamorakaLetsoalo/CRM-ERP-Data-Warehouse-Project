/* 
script porpose : this dtored ptocedure performs the ETL process to populate the silver schema tables from bronze schema.
Actions perforemed:
          -truncate silver table
          -inserts transformed and cleansed data from bronze into silver tables

Prameters:None
this stored procedure does not accept any parameters or return any values.
*/

--Create a stored procedure

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
--1.
  TRUNCATE TABLE [silver].[crm_cust_info];
  INSERT INTO [silver].[crm_cust_info](
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date)
SELECT 
cst_id,
cst_key,
--data cleaning (trim unwanted spaces)
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
--Data normalisation and standardization(maps coded values to meaningful,user-friendly descriptions)
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female' -- Change the gender column to use full words insead of letter,trim any spaces,use upper for the code to run on any case
	 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
ELSE 'Unknown'
END AS cst_gndr,
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single' -- Change the marital status column to use full words insead of letter,trim any spaces,use upper for the code to run on any case
	 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
ELSE 'Unknown' --Handling missing data
END AS cst_marital_status,
cst_create_date
FROM 
( SELECT*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date desc) AS flag_last
FROM [bronze].[crm_cust_info]
WHERE cst_id IS NOT NULL)t--remove duplicates
WHERE flag_last =1 -- select the most recent record per customer

--2.
TRUNCATE TABLE [silver].[crm_prd_info];
INSERT INTO [silver].[crm_prd_info] (
    prd_id,       
    cat_id,     
    prd_key,     
    prd_nm,     
    prd_cost,    
    prd_line,    
    prd_start_dt, 
    prd_end_dt
 )
--cleaned data for silver layer
SELECT
    prd_id,
--derived new columns based on transformations
REPLACE(SUBSTRING (prd_key,1,5), '-','_') AS cat_id, --match data structure between the two tables(extract category)
SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key, --specify the length of the column, product key used to join table sales details(extract product key)
 prd_nm,
ISNULL( prd_cost,0) AS prd_cost, --replace null values with zero
CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain' -- Change the product line column to use full words insead of letter,trim any spaces,use upper for the code to run on any case
	 WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
     WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
     WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Touring'
     ELSE 'Unknown'
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt, --cast the date column to change from datetime to date, remove the time stamps because they have no valuable information
--Data enrichment
CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_date
FROM [bronze].[crm_prd_info]

--3.
TRUNCATE TABLE [silver].[crm_sales_details];
INSERT INTO [silver].[crm_sales_details] (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
SELECT
    sls_ord_num ,
    sls_prd_key,
    sls_cust_id,
CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
     ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
END AS sls_order_dt,
CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
     ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
END AS sls_ship_dt,
CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
     ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
END AS sls_due_dt,
CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price) -- ABS convert negative to positive values
     THEN sls_quantity * ABS(sls_price)
     ELSE sls_sales
END AS sls_sales,
sls_quantity,
--Convert the price
CASE WHEN sls_price IS NULL OR sls_price <=0
     THEN sls_sales / NULLIF(sls_quantity,0) --if the value is zero replace it with a NULL
     ELSE sls_price
     END AS sls_price
FROM [bronze].[crm_sales_details]

--4.
TRUNCATE TABLE [silver].[erp_cust_az12];
INSERT INTO [silver].[erp_cust_az12] (
cid,
bdate,
gen
)
SELECT
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4 ,LEN(cid))
     ELSE cid
END cid,
CASE WHEN bdate > GETDATE() THEN NULL --if birthday is larger that current date then NULL
     ELSE bdate
     END AS bdate,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
     WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
     ELSE 'Unkown'
     END AS gen
FROM [bronze].[erp_cust_az12]

--5.
TRUNCATE TABLE [silver].[erp_loc_az12];
INSERT INTO [silver].[erp_loc_a101](
cid,
cntry
)
SELECT 
REPLACE(cid, '-','')cid,
CASE WHEN TRIM(cntry) = 'DE' THEN 'GERMANY'
     WHEN TRIM(cntry) IN ('US' ,'USA') THEN 'UnitedS tates'
     WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'Unknown'
     ELSE TRIM(cntry)
END AS cntry
FROM [bronze].[erp_loc_a101]

--6.
TRUNCATE TABLE [silver].[erp_px_cat_g1v2];
INSERT INTO [silver].[erp_px_cat_g1v2] 
(id,cat,subcat,maintenance)
SELECT
id,
cat,
subcat,
maintenance
FROM [bronze].[erp_px_cat_g1v2]
END



