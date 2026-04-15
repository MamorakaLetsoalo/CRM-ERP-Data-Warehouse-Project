--Clean the erp customer table

SELECT
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4 ,LEN(cid))
     ELSE cid
END cid,
bdate,
gen
FROM [bronze].[erp_cust_az12]

--check the out of range dates
SELECT DISTINCT
bdate
FROM [bronze].[erp_cust_az12]
WHERE BDATE< '1924-01-01' OR bdate > GETDATE() --Check for cutomers olader than 100 years and customers with future value dates 