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