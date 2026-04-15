--check for Nulls or duplicates in primary key
--Expectation: No result

SELECT prd_id,
COUNT(*)
FROM[bronze].[crm_prd_info]
GROUP BY prd_id
HAVING COUNT(*) > 1


--create cat-id column to connect to the erp product table
SELECT
    prd_id,      
    prd_key,
REPLACE(SUBSTRING (prd_key,1,5), '-','_') AS cat_id, --match data structure between the two tables
SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key, --specify the length of the column, product key used to join table sales details
 prd_nm,      
    prd_cost,     
    prd_line,     
    prd_start_dt, 
    prd_end_dt
FROM [bronze].[crm_prd_info]

--replace null values
SELECT
    prd_id,      
    prd_key,
REPLACE(SUBSTRING (prd_key,1,5), '-','_') AS cat_id, --match data structure between the two tables
SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key, --specify the length of the column, product key used to join table sales details
 prd_nm,
 ISNULL( prd_cost,0) AS prd_cost, --replace null values with zero
    prd_line,
    prd_start_dt, 
    prd_end_dt
FROM [bronze].[crm_prd_info]

----Data standardization and consistency
SELECT
    prd_id,      
    prd_key,
REPLACE(SUBSTRING (prd_key,1,5), '-','_') AS cat_id, --match data structure between the two tables
SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key, --specify the length of the column, product key used to join table sales details
 prd_nm,
 ISNULL( prd_cost,0) AS prd_cost, --replace null values with zero
CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain' -- Change the product line column to use full words insead of letter,trim any spaces,use upper for the code to run on any case
	 WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
     WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
     WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Touring'
     ELSE 'Unknown'
END AS prd_line,
    prd_start_dt, 
    prd_end_dt
FROM [bronze].[crm_prd_info]

--check for invalid date orders
--end date must not be ealier than start date
SELECT *
FROM [bronze].[crm_prd_info]
WHERE prd_end_dt < prd_start_dt

--solution :end date = start date of the "NEXT' record minus 1 day
SELECT
    prd_id,      
REPLACE(SUBSTRING (prd_key,1,5), '-','_') AS cat_id, --match data structure between the two tables
SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key, --specify the length of the column, product key used to join table sales details
 prd_nm,
ISNULL( prd_cost,0) AS prd_cost, --replace null values with zero
CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain' -- Change the product line column to use full words insead of letter,trim any spaces,use upper for the code to run on any case
	 WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
     WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
     WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Touring'
     ELSE 'Unknown'
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt, --cast the date column to change from datetime to date, remove the time stamps because they have no valuable information
CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_date
FROM [bronze].[crm_prd_info]

