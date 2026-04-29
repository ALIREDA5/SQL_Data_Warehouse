CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME,
	    @rows INT;

    SET @batch_start_time = GETDATE();

    BEGIN TRY

        ---------------------------------------------------------------
        -- CRM CUSTOMER INFO
        ---------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '---------------------------------------------------------------';
        PRINT '-- CRM CUSTOMER INFO';
        PRINT '---------------------------------------------------------------';

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

        SET @end_time = GETDATE();
		SELECT @rows = COUNT(*) FROM bronze.crm_cst_info;
		PRINT '>> Rows Loaded: ' + CAST(@rows AS NVARCHAR);
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        ---------------------------------------------------------------
        -- CRM PRODUCT INFO
        ---------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '---------------------------------------------------------------';
        PRINT '-- CRM PRODUCT INFO';
        PRINT '---------------------------------------------------------------';

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

        SET @end_time = GETDATE();
        SELECT @rows = COUNT(*) FROM bronze.crm_prd_info;
		PRINT '>> Rows Loaded: ' + CAST(@rows AS NVARCHAR);
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        ---------------------------------------------------------------
        -- CRM SALES DETAILS
        ---------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '---------------------------------------------------------------';
        PRINT '-- CRM SALES DETAILS';
        PRINT '---------------------------------------------------------------';

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

        SET @end_time = GETDATE();
        SELECT @rows = COUNT(*) FROM bronze.crm_sales_details;
		PRINT '>> Rows Loaded: ' + CAST(@rows AS NVARCHAR);
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        ---------------------------------------------------------------
        -- ERP CUSTOMER DEMOGRAPHICS
        ---------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '---------------------------------------------------------------';
        PRINT '-- ERP CUSTOMER DEMOGRAPHICS';
        PRINT '---------------------------------------------------------------';

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

        SET @end_time = GETDATE();
        SELECT @rows = COUNT(*) FROM bronze.erp_CUST_AZ12;
		PRINT '>> Rows Loaded: ' + CAST(@rows AS NVARCHAR);
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        ---------------------------------------------------------------
        -- ERP CUSTOMER LOCATION
        ---------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '---------------------------------------------------------------';
        PRINT '-- ERP CUSTOMER LOCATION';
        PRINT '---------------------------------------------------------------';

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

        SET @end_time = GETDATE();
        SELECT @rows = COUNT(*) FROM bronze.erp_LOC_A101;
		PRINT '>> Rows Loaded: ' + CAST(@rows AS NVARCHAR);
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        ---------------------------------------------------------------
        -- ERP PRODUCT CATEGORY
        ---------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '---------------------------------------------------------------';
        PRINT '-- ERP PRODUCT CATEGORY';
        PRINT '---------------------------------------------------------------';

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

        SET @end_time = GETDATE();
        SELECT @rows = COUNT(*) FROM bronze.erp_PX_CAT_G1V2;
		PRINT '>> Rows Loaded: ' + CAST(@rows AS NVARCHAR);
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

    END TRY
    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State  : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';

        -- 🔥 IMPORTANT: rethrow error for pipelines
        THROW;
    END CATCH;

    SET @batch_end_time = GETDATE();

    PRINT '================================================';
    PRINT '>> Batch Load Duration: ' 
        + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) 
        + ' seconds';
    PRINT '================================================';

END;