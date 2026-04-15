--Gold layer
--create customer dimension

SELECT
ci.cst_id, --ci is an alias we gonna use to join the tables with other tables
ci.cst_key,
ci.cst_firstname,
ci.cst_lastname,
ci.cst_marital_status,
ci.cst_gndr,
ci.cst_create_date,
ca.bdate,
ca.gen,
la.cntry
FROM [silver].[crm_cust_info] ci
LEFT JOIN [silver].[erp_cust_az12] ca
ON ci.cst_key = ca.cid
LEFT JOIN [silver].[erp_loc_a101] la
ON ci.cst_key = la.cid

--Data intergration between the table to solve the mismatch
SELECT
ci.cst_id, 
ci.cst_key,
ci.cst_firstname,
ci.cst_lastname,
ci.cst_gndr,
CASE WHEN ci.cst_marital_status != 'Unknown' THEN ci.cst_marital_status
     ELSE COALESCE(ca.gen, 'Unknown')
     END AS gen,
ci.cst_create_date,
ca.bdate,
la.cntry
FROM [silver].[crm_cust_info] ci
LEFT JOIN [silver].[erp_cust_az12] ca
ON ci.cst_key = ca.cid
LEFT JOIN [silver].[erp_loc_a101] la
ON ci.cst_key = la.cid





