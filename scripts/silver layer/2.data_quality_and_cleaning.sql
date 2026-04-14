--check for Nulls or duplicates in primary key
--Expectation: No result

SELECT cst_id,
COUNT(*)
FROM[bronze].[crm_cust_info]
GROUP BY cst_id
HAVING COUNT(*) > 1

--window function to rank duplicates to find the newest data

SELECT *,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date desc) AS flag_last
FROM [bronze].[crm_cust_info]
WHERE cst_id = 29466

--subquery: Create a temporary table to see the data that is causing duplicates in the primary key
SELECT *
FROM(
SELECT*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date desc) AS flag_last
FROM [bronze].[crm_cust_info])t
WHERE flag_last !=1 

--check all values without duplicates
SELECT *
FROM(
SELECT*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date desc) AS flag_last
FROM [bronze].[crm_cust_info])t
WHERE flag_last =1 

--check for unwanted spaces
SELECT cst_firstname
FROM [bronze].[crm_cust_info]
WHERE cst_firstname != TRIM(cst_firstname)

--trim the spaces

SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
FROM 
( SELECT*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date desc) AS flag_last
FROM [bronze].[crm_cust_info]
WHERE cst_id IS NOT NULL)t
WHERE flag_last =1

--Data standardization and consistency 
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info

SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
cst_marital_status,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female' -- Change the gender column to use full words insead of letter,trim any spaces,use upper for the code to run on any case
	 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
ELSE 'Unknown'
END cst_gndr,
cst_create_date
FROM 
( SELECT*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date desc) AS flag_last
FROM [bronze].[crm_cust_info]
WHERE cst_id IS NOT NULL)t
WHERE flag_last =1