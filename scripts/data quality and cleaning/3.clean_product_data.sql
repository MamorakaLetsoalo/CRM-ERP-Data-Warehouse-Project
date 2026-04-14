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
SUBSTRING (prd_key,1,5) AS cat_id,
    prd_nm,      
    prd_cost,     
    prd_line,     
    prd_start_dt, 
    prd_end_dt
FROM [bronze].[crm_prd_info]