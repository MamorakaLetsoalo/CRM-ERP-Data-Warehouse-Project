--check for Nulls or duplicates in primary key
--Expectation: No result

SELECT prd_id,
COUNT(*)
FROM[bronze].[crm_prd_info]
GROUP BY prd_id
HAVING COUNT(*) > 1