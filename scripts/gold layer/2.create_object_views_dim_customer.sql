--surrogate key
--create objects: views
CREATE VIEW gold.dim_customers AS
SELECT
ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
ci.cst_id AS customer_id, 
ci.cst_key AS customer_number,
ci.cst_firstname AS first_name,
ci.cst_lastname AS last_name,
ci.cst_gndr AS marital_status,
CASE WHEN ci.cst_marital_status != 'Unknown' THEN ci.cst_marital_status --CRM is the master source
     ELSE COALESCE(ca.gen, 'Unknown')
     END AS gender,
ci.cst_create_date AS create_date,
ca.bdate AS birthdate,
la.cntry AS Country
FROM [silver].[crm_cust_info] ci
LEFT JOIN [silver].[erp_cust_az12] ca
ON ci.cst_key = ca.cid
LEFT JOIN [silver].[erp_loc_a101] la
ON ci.cst_key = la.cid;
