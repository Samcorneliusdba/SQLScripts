SELECT a.index_id, name, avg_fragmentation_in_percent, DB_NAME(Db_Id())
FROM sys.dm_db_index_physical_stats (DB_ID(N'All'), OBJECT_ID(N' All'), NULL, NULL, NULL) AS a  
    JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id  
    where name is not null
    order by 3 desc