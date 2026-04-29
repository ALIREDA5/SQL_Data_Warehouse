/*
===============================================================
 Script: Bronze Layer Tables Creation
 Layer : Bronze (Raw Ingestion Layer)
 Author: Ali Reda
 Date  : 2026-04-29

 Description:
 This script creates raw ingestion tables in the Bronze layer.
 The Bronze layer stores data as-is from source systems with 
 minimal or no transformations.

 Tables:
 - crm_cst_info        : Customer master data (CRM)
 - crm_prd_info        : Product master data (CRM)
 - crm_sales_details   : Sales transactions (CRM)
 - erp_CUST_AZ12       : Customer demographics (ERP)
 - erp_LOC_A101        : Customer location data (ERP)
 - erp_PX_CAT_G1V2     : Product category mapping (ERP)

 Notes:
 - Tables are dropped and recreated to ensure schema consistency.
 - No constraints applied (raw layer design).
===============================================================
*/

-- Ensure schema exists
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
END
GO

---------------------------------------------------------------
-- CRM CUSTOMER INFO
---------------------------------------------------------------
IF OBJECT_ID('bronze.crm_cst_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cst_info;
GO

CREATE TABLE bronze.crm_cst_info(
    cst_id numeric,
    cst_key nvarchar(20),
    cst_firstname nvarchar(20),
    cst_lastname nvarchar(20),
    cst_marital_status nvarchar(5),
    cst_gndr nvarchar(20),
    cst_create_date date
);
GO

---------------------------------------------------------------
-- CRM PRODUCT INFO
---------------------------------------------------------------
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info(
    prd_id numeric,
    prd_key nvarchar(20),
    prd_nm nvarchar(50),
    prd_cost numeric,
    prd_line nvarchar(5),
    prd_start_dt date,
    prd_end_dt date
);
GO

---------------------------------------------------------------
-- CRM SALES DETAILS
---------------------------------------------------------------
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details(
    sls_ord_num nvarchar(20),
    sls_prd_key nvarchar(20),
    sls_cust_id numeric,
    sls_order_dt numeric,
    sls_ship_dt numeric,
    sls_due_dt numeric,
    sls_sales numeric,
    sls_quantity numeric,
    sls_price numeric
);
GO

---------------------------------------------------------------
-- ERP CUSTOMER DEMOGRAPHICS
---------------------------------------------------------------
IF OBJECT_ID('bronze.erp_CUST_AZ12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_CUST_AZ12;
GO

CREATE TABLE bronze.erp_CUST_AZ12(
    CID nvarchar(20),
    BDATE date,
    GEN nvarchar(20)
);
GO

---------------------------------------------------------------
-- ERP CUSTOMER LOCATION
---------------------------------------------------------------
IF OBJECT_ID('bronze.erp_LOC_A101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_LOC_A101;
GO

CREATE TABLE bronze.erp_LOC_A101(
    CID nvarchar(20),
    CNTRY nvarchar(20)
);
GO

---------------------------------------------------------------
-- ERP PRODUCT CATEGORY
---------------------------------------------------------------
IF OBJECT_ID('bronze.erp_PX_CAT_G1V2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_PX_CAT_G1V2;
GO

CREATE TABLE bronze.erp_PX_CAT_G1V2(
    ID nvarchar(20),
    CAT nvarchar(20),
    SUBCAT nvarchar(20),
    MAINTENANCE nvarchar(10)
);
GO