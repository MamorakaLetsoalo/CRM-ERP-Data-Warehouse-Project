--Remove the dashed in the cid column and replace them with nothing
SELECT 
REPLACE(cid, '-','')cid,
cntry
FROM [bronze].[erp_loc_a101]

--datastandardisation and consistency 
SELECT 
REPLACE(cid, '-','')cid,
CASE WHEN TRIM(cntry) = 'DE' THEN 'GERMANY'
     WHEN TRIM(cntry) IN ('US' ,'USA') THEN 'UnitedS tates'
     WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'Unknown'
     ELSE TRIM(cntry)
END AS cntry
FROM [bronze].[erp_loc_a101]