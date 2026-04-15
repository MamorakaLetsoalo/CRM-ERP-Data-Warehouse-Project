--Load cleaned data in the erp location silver table

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