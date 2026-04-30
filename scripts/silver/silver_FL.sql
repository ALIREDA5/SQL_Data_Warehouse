
create or alter procedure silver.load_silver as
begin
	DECLARE 
		@start_time DATETIME,
		@end_time DATETIME,
		@batch_start_time DATETIME,
		@batch_end_time DATETIME; 

		BEGIN TRY
			SET @batch_start_time = GETDATE();
			PRINT '================================================';
			PRINT 'Loading Silver Layer';
			PRINT '================================================';

			PRINT '------------------------------------------------';
			PRINT 'Loading CRM Tables';
			PRINT '------------------------------------------------';
	-- ====================================================================
	--  'silver.crm'
	-- ====================================================================

	-- Loading silver.crm_cust_info

			SET @start_time = GETDATE();
			PRINT '>> Truncating Table: silver.crm_cust_info';
			TRUNCATE TABLE silver.crm_cst_info;
			PRINT '>> Inserting Data Into: silver.crm_cust_info';
			insert into silver.crm_cst_info(
				cst_id,
				cst_key,
				cst_firstname,
				cst_lastname,
				cst_marital_status,
				cst_gndr,
				cst_create_date
			)
			select 
				cst_id,
				cst_key,
				TRIM(cst_firstname) as cst_firstname,
				TRIM(cst_lastname) as cst_lastname,
				case UPPER(cst_marital_status)
					when 'M' then 'Married'
					when 'S' then 'Single'
					else 'N/A'
				end,
				case UPPER(cst_gndr)
					when 'M' then 'Male'
					when 'F' then 'Female'
					else 'N/A'
				end,
				cst_create_date
			from(
				select *,
					ROW_NUMBER() over(partition by cst_id order by c.cst_create_date desc) as rn
				from bronze.crm_cst_info c
				where c.cst_id is not null) t
			where rn = 1

			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> -------------';

	-- Loading silver.crm_prd_info

			SET @start_time = GETDATE();
			PRINT '>> Truncating Table: silver.crm_prd_info';
			TRUNCATE TABLE silver.crm_prd_info;
			PRINT '>> Inserting Data Into: silver.crm_prd_info';
			insert into silver.crm_prd_info(
				prd_id,
				catg_key,
				prod_key,
				prd_nm,
				prd_cost,
				prd_line,
				prd_start_dt,
				prd_end_dt
			)
			select 
				prd_id,
				SUBSTRING(prd_key, 1, 5) as catg_key,
				SUBSTRING(prd_key, 7, len(prd_key)) as prod_key,
				UPPER(TRIM(prd_nm)) as prd_nm,
				ISNULL(prd_cost, 0),
				case UPPER(prd_line)
					when 'M' then 'Mountain'
					when 'R' then 'Road'
					when 'S' THEN 'Other Sales'
					when 'T' THEN 'Touring'
					else 'N/A'
				end,
				prd_start_dt,
				lead(prd_end_dt) over(partition by prd_key order by prd_start_dt) as lead_prd_end_dt
			from bronze.crm_prd_info c
			

			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> -------------';

	-- Loading silver.crm_sales_details

			SET @start_time = GETDATE();
			PRINT '>> Truncating Table: silver.crm_sales_details';
			TRUNCATE TABLE silver.crm_sales_details;
			PRINT '>> Inserting Data Into: silver.crm_sales_details';

			Insert into silver.crm_sales_details( 
				sls_ord_num ,
				sls_prd_key ,
				sls_cust_id ,
				sls_order_dt ,
				sls_ship_dt ,
				sls_due_dt ,
				sls_sales ,
				sls_quantity ,
				sls_price)
			select 	
				sls_ord_num ,
				sls_prd_key ,
				sls_cust_id ,
				TRY_CONVERT(DATE, CAST(sls_order_dt AS VARCHAR(8)), 112) AS sls_order_dt,
				TRY_CONVERT(DATE, CAST(sls_ship_dt AS VARCHAR(8)), 112) AS sls_ship_dt,
				TRY_CONVERT(DATE, CAST(sls_due_dt AS VARCHAR(8)), 112) AS sls_due_dt,
				case when sls_sales is null or sls_sales < 0 or sls_sales != sls_quantity * sls_price
					then sls_quantity * abs(sls_price)
					else sls_sales
				end as sls_sales,
				sls_quantity ,
				case when sls_price is null or sls_price < 0 
					then sls_sales / sls_quantity
					else sls_price
				end as sls_price
			from bronze.crm_sales_details 

			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> -------------';


	-- Loading silver.erp_CUST_AZ12

			SET @start_time = GETDATE();
			PRINT '>> Truncating Table: silver.erp_CUST_AZ12';
			TRUNCATE TABLE silver.erp_CUST_AZ12;
			PRINT '>> Inserting Data Into: silver.erp_CUST_AZ12';

			Insert into silver.erp_CUST_AZ12(
				CID,
				BDATE,
				gen
			)
			select 
			   case when cid like 'NAS%' then SUBSTRING(cid, 4, len(cid))
			   else cid
			   end as cid,
			   case 
					when BDATE > GETDATE() then NULL
					else BDATE
			   end,
			   case 
					when trim(UPPER(gen))  in('M' , 'Male') then 'Male'
					when trim(UPPER(gen))  in('F' , 'Female') then 'Female'
					else 'N/A'
			   end as gen
			from bronze.erp_CUST_AZ12

			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> -------------';

	-- Loading silver.erp_LOC_A101

			SET @start_time = GETDATE();
			PRINT '>> Truncating Table: silver.erp_LOC_A101';
			TRUNCATE TABLE silver.erp_LOC_A101;
			PRINT '>> Inserting Data Into: silver.erp_LOC_A101';

			Insert into silver.erp_LOC_A101(
				CID,
				CNTRY
			)
			select 
				REPLACE(cid, '-', '') as cid,
				case
					when cntry in ('DE', 'Germany') then 'Germany'
					when cntry in ('US', 'United States', 'USA') then 'United States'
					when cntry = '' or CNTRY is Null then 'N/A'
					else CNTRY
				end as cntry	
			from bronze.erp_LOC_A101

			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> -------------';

	-- Loading silver.erp_px_cat_g1v2

			SET @start_time = GETDATE();
			PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';
			TRUNCATE TABLE silver.erp_px_cat_g1v2;
			PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2';

			Insert into silver.erp_px_cat_g1v2(
				ID,
				CAT,
				SUBCAT,
				MAINTENANCE
			)
			select 
				replace(ID, '_', '-') as ID,
				cat,
				subcat,
				maintenance
			from bronze.erp_px_cat_g1v2

			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> -------------';

			SET @batch_end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';

		end try
		begin catch 
			print 'error message:' + error_message();
			THROW;
		end catch
end