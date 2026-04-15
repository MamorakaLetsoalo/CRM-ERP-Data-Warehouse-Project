--Remove the dashed in the cid column and replace them with nothing
SELECT 
REPLACE(cid, '-','')cid,
cntry
FROM [bronze].[erp_loc_a101]