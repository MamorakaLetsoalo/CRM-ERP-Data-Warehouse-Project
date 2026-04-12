
/*script purpose:
this script creates a new database named CRM_ERP_DataWarehouse,the script additionally sets up schemas within the data base namely bronze,silver and gold*/

--Create database 'DataWarehouse'

CREATE DATABASE CRM_ERP_DataWarehouse
GO

USE CRM_ERP_DataWarehouse

--create schemas

CREATE SCHEMA bronze

GO
CREATE SCHEMA silver

GO
CREATE SCHEMA gold
