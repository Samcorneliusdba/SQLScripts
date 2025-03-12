declare @DBNAME VARCHAR(128) 
set @DBNAME = '<not supplied>'
declare @COUNT INT 
set @COUNT = 100
declare  @ORDERBY VARCHAR(4) 
set @ORDERBY = 'ACPU'

-- Check for valid @ORDERBY parameter
IF ((SELECT CASE WHEN 
          @ORDERBY in ('ACPU','TCPU','AE','TE','EC','AIO','TIO','ALR','TLR','ALW','TLW','APR','TPR') 
             THEN 1 ELSE 0 END) = 0)
BEGIN 
   -- abort if invalid @ORDERBY parameter entered
   RAISERROR('@ORDERBY parameter not APCU, TCPU, AE, TE, EC, AIO, TIO, ALR, TLR, ALW, TLW, APR or TPR',11,1)
   RETURN
 END
 SELECT TOP (@COUNT) 
         COALESCE(DB_NAME(st.dbid), 
                  DB_NAME(CAST(pa.value AS INT))+'*', 
                 'Resource') AS [Database Name]  
         -- find the offset of the actual statement being executed
         
         ,OBJECT_SCHEMA_NAME(st.objectid,dbid) [Schema Name] 
         ,OBJECT_NAME(st.objectid,dbid) [Object Name]   
         ,objtype [Cached Plan objtype] 
         ,execution_count [Execution Count]  
         ,total_worker_time / execution_count [Avg CPU] 
         ,total_worker_time [Total CPU] 
         ,total_elapsed_time / execution_count [Avg Elapsed Time] 
         ,total_elapsed_time  [Total Elasped Time] 
         ,(total_logical_reads + total_logical_writes + total_physical_reads )/execution_count [Average IOs] 
         ,total_logical_reads + total_logical_writes + total_physical_reads [Total IOs]  
         ,total_logical_reads/execution_count [Avg Logical Reads] 
         ,total_logical_reads [Total Logical Reads]  
         ,total_logical_writes/execution_count [Avg Logical Writes]  
         ,total_logical_writes [Total Logical Writes]  
         ,total_physical_reads/execution_count [Avg Physical Reads] 
         ,total_physical_reads [Total Physical Reads]   
         ,last_execution_time [Last Execution Time]
		 ,replace(replace(SUBSTRING(text, 
                   CASE WHEN statement_start_offset = 0 
                          OR statement_start_offset IS NULL  
                           THEN 1  
                           ELSE statement_start_offset/2 + 1 END, 
                   CASE WHEN statement_end_offset = 0 
                          OR statement_end_offset = -1  
                          OR statement_end_offset IS NULL  
                           THEN LEN(text)  
                           ELSE statement_end_offset/2 END - 
                     CASE WHEN statement_start_offset = 0 
                            OR statement_start_offset IS NULL 
                             THEN 1  
                             ELSE statement_start_offset/2  END + 1 
                  )
			, char(13), ' '), char(10), ' ')
			AS [Statement]  
    FROM sys.dm_exec_query_stats qs  
    JOIN sys.dm_exec_cached_plans cp ON qs.plan_handle = cp.plan_handle 
    CROSS APPLY sys.dm_exec_sql_text(qs.plan_handle) st 
    OUTER APPLY sys.dm_exec_plan_attributes(qs.plan_handle) pa 
    WHERE attribute = 'dbid' AND  
     CASE when @DBNAME = '<not supplied>' THEN '<not supplied>'
                               ELSE COALESCE(DB_NAME(st.dbid), 
                                          DB_NAME(CAST(pa.value AS INT)) + '*', 
                                          'Resource') END
                                    IN (RTRIM(@DBNAME),RTRIM(@DBNAME) + '*')  
      
    ORDER BY CASE 
                WHEN @ORDERBY = 'ACPU' THEN total_worker_time / execution_count 
                WHEN @ORDERBY = 'TCPU'  THEN total_worker_time
                WHEN @ORDERBY = 'AE'   THEN total_elapsed_time / execution_count
                WHEN @ORDERBY = 'TE'   THEN total_elapsed_time  
                WHEN @ORDERBY = 'EC'   THEN execution_count
                WHEN @ORDERBY = 'AIO'  THEN (total_logical_reads + total_logical_writes + total_physical_reads) / execution_count  
                WHEN @ORDERBY = 'TIO'  THEN total_logical_reads + total_logical_writes + total_physical_reads
                WHEN @ORDERBY = 'ALR'  THEN total_logical_reads  / execution_count
                WHEN @ORDERBY = 'TLR'  THEN total_logical_reads 
                WHEN @ORDERBY = 'ALW'  THEN total_logical_writes / execution_count
                WHEN @ORDERBY = 'TLW'  THEN total_logical_writes  
                WHEN @ORDERBY = 'APR'  THEN total_physical_reads / execution_count 
                WHEN @ORDERBY = 'TPR'  THEN total_physical_reads
           END DESC
		   