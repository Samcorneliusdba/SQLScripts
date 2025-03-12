--Below is a script to analyze the buffer pool and break down by database the amount of space being taken up in 
--the buffer pool and how much of that space is empty space. For systems with a 100s of GB of memory in use, this 
--query may take a while to run:

 
SELECT
    (CASE WHEN ([database_id] = 32767)
        THEN N'Resource Database'
        ELSE DB_NAME ([database_id]) END) AS [DatabaseName],
    COUNT (*) * 8 / 1024 AS [MBUsed],
    SUM (CAST ([free_space_in_bytes] AS BIGINT)) / (1024 * 1024) AS [MBEmpty]
FROM sys.dm_os_buffer_descriptors
GROUP BY [database_id]
order by 2 desc
GO
 