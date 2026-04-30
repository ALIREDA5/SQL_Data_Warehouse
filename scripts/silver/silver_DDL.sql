/*
===============================================================
 Script: Silver Layer Tables Creation
 Layer : Silver
 Author: Ali Reda
 Date  : 2026-04-29

 Description:
 This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
 Run this script to re-define the DDL structure of 'bronze' Tables

 Tables:
 - crm_cst_info        : Customer master data (CRM)
 - crm_prd_info        : Product master data (CRM)
 - crm_sales_details   : Sales transactions (CRM)
 - erp_CUST_AZ12       : Customer demographics (ERP)
 - erp_LOC_A101        : Customer location data (ERP)
 - erp_PX_CAT_G1V2     : Product category mapping (ERP)
===============================================================
*/

-- Ensure schema exists
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA Silver');
END
GO

---------------------------------------------------------------
-- CRM CUSTOMER INFO
---------------------------------------------------------------
IF OBJECT_ID('silver.crm_cst_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cst_info;
GO

CREATE TABLE silver.crm_cst_info(
    cst_id numeric,
    cst_key nvarchar(20),
    cst_firstname nvarchar(20),
    cst_lastname nvarchar(20),
    cst_marital_status nvarchar(20),
    cst_gndr nvarchar(20),
    cst_create_date date,
	dwh_create_date datetime2 default getdate()
);
GO

---------------------------------------------------------------
-- CRM PRODUCT INFO
---------------------------------------------------------------
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info(
    prd_id numeric,
    catg_key nvarchar(20),
	prod_key nvarchar(20),
    prd_nm nvarchar(50),
    prd_cost numeric,
    prd_line nvarchar(20),
    prd_start_dt date,
    prd_end_dt date,
	dwh_create_date datetime2 default getdate()
);
GO

---------------------------------------------------------------
-- CRM SALES DETAILS
---------------------------------------------------------------
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details(
    sls_ord_num nvarchar(20),
    sls_prd_key nvarchar(20),
    sls_cust_id numeric,
    sls_order_dt date,
    sls_ship_dt date,
    sls_due_dt date,
    sls_sales numeric,
    sls_quantity numeric,
    sls_price numeric,
	dwh_create_date datetime2 default getdate()
);
GO

---------------------------------------------------------------
-- ERP CUSTOMER DEMOGRAPHICS
---------------------------------------------------------------
IF OBJECT_ID('silver.erp_CUST_AZ12', 'U') IS NOT NULL
    DROP TABLE silver.erp_CUST_AZ12;
GO

CREATE TABLE silver.erp_CUST_AZ12(
    CID nvarchar(20),
    BDATE date,
    GEN nvarchar(20),
	dwh_create_date datetime2 default getdate()
);
GO

---------------------------------------------------------------
-- ERP CUSTOMER LOCATION
---------------------------------------------------------------
IF OBJECT_ID('silver.erp_LOC_A101', 'U') IS NOT NULL
    DROP TABLE silver.erp_LOC_A101;
GO

CREATE TABLE silver.erp_LOC_A101(
    CID nvarchar(20),
    CNTRY nvarchar(20),
	dwh_create_date datetime2 default getdate()
);
GO

---------------------------------------------------------------
-- ERP PRODUCT CATEGORY
---------------------------------------------------------------
IF OBJECT_ID('silver.erp_PX_CAT_G1V2', 'U') IS NOT NULL
    DROP TABLE silver.erp_PX_CAT_G1V2;
GO

CREATE TABLE silver.erp_PX_CAT_G1V2(
    ID nvarchar(20),
    CAT nvarchar(20),
    SUBCAT nvarchar(20),
    MAINTENANCE nvarchar(10),
	dwh_create_date datetime2 default getdate()
);
GO