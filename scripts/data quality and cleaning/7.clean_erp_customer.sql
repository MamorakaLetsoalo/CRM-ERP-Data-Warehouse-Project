--Clean the erp customer table

SELECT
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4 ,LEN(cid))
     ELSE cid
END cid,
bdate,
gen
FROM [bronze].[erp_cust_az12]