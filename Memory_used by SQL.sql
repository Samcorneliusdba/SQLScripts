SELECT  
@@servername,
(physical_memory_in_use_kb/1024000) AS Memory_usedby_Sqlserver_GB,  
(locked_page_allocations_kb/1024) AS Locked_pages_used_Sqlserver_MB,  
(total_virtual_address_space_kb/1024000) AS Total_VAS_in_GB,  
process_physical_memory_low,  
process_virtual_memory_low  
FROM sys.dm_os_process_memory;  