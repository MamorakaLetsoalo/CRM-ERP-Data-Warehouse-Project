--check for Nulls or duplicates in primary key
--Expectation: No result

SELECT cst_id,
COUNT(*)
FROM[bronze].[crm_cust_info]
GROUP BY cst_id
HAVING COUNT(*) > 1