--Change the data type from INT to DATE
USE [CRM_ERP_DataWarehouse]
SELECT
    sls_ord_num ,
    sls_prd_key,
    sls_cust_id,
CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
     ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
END AS sls_order_dt,
CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
     ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
END AS sls_ship_dt,
CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
     ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
END AS sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM [bronze].[crm_sales_details]

--check data consistency:between sales,Quantity and price
--sales = quantity*price
--values must not be null,zero or negatice

SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM [bronze].[crm_sales_details]
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR  sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales,sls_quantity,sls_price


--Rules:if sales is negative ,zero or null,derive it using quantity
  -- if price is zero or null,calculate it using sales and quantity
  --if price is negative,convrt it to a positive value


