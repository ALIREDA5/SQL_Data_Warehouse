/*
===============================================================
 Script: Bronze Layer Data Load (BULK INSERT)
 Layer : Bronze (Raw Data Ingestion)
 Author: Ali Reda
 Date  : 2026-04-29

 Description:
 This script loads raw CSV data into Bronze layer tables using 
 BULK INSERT. Data is ingested as-is with minimal transformation.

 Features:
 - Truncate tables before load (full refresh)
 - Handles CSV with quoted fields
 - Supports UTF-8 encoding
 - Optimized with TABLOCK for performance

 Source Systems:
 - CRM: Customer, Product, Sales
 - ERP: Customer Demographics, Location, Product Categories
===============================================================
*/

---------------------------------------------------------------
-- COMMON OPTIONS (for readability reference)
---------------------------------------------------------------
-- FIRSTROW = 2        → Skip header
-- FIELDTERMINATOR = , → CSV separator
-- FIELDQUOTE = "      → Handle commas inside text
-- CODEPAGE = 65001    → UTF-8 encoding
-- TABLOCK             → Faster bulk load

---------------------------------------------------------------
-- CRM CUSTOMER INFO
---------------------------------------------------------------
TRUNCATE TABLE bronze.crm_cst_info;

BULK INSERT bronze.crm_cst_info
FROM 'D:\Data analysis\SQL_Data_Warehouse\datasets\source_crm\cust_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    TABLOCK
);

---------------------------------------------------------------
-- CRM PRODUCT INFO
---------------------------------------------------------------
TRUNCATE TABLE bronze.crm_prd_info;

BULK INSERT bronze.crm_prd_info
FROM 'D:\Data analysis\SQL_Data_Warehouse\datasets\source_crm\prd_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    TABLOCK
);

---------------------------------------------------------------
-- CRM SALES DETAILS
---------------------------------------------------------------
TRUNCATE TABLE bronze.crm_sales_details;

BULK INSERT bronze.crm_sales_details
FROM 'D:\Data analysis\SQL_Data_Warehouse\datasets\source_crm\sales_details.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    TABLOCK
);

---------------------------------------------------------------
-- ERP CUSTOMER DEMOGRAPHICS
---------------------------------------------------------------
TRUNCATE TABLE bronze.erp_CUST_AZ12;

BULK INSERT bronze.erp_CUST_AZ12
FROM 'D:\Data analysis\SQL_Data_Warehouse\datasets\source_erp\CUST_AZ12.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    TABLOCK
);

---------------------------------------------------------------
-- ERP CUSTOMER LOCATION
---------------------------------------------------------------
TRUNCATE TABLE bronze.erp_LOC_A101;

BULK INSERT bronze.erp_LOC_A101
FROM 'D:\Data analysis\SQL_Data_Warehouse\datasets\source_erp\LOC_A101.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    TABLOCK
);

---------------------------------------------------------------
-- ERP PRODUCT CATEGORY
---------------------------------------------------------------
TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;

BULK INSERT bronze.erp_PX_CAT_G1V2
FROM 'D:\Data analysis\SQL_Data_Warehouse\datasets\source_erp\PX_CAT_G1V2.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    TABLOCK
);