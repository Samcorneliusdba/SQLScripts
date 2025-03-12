---Rebuild
select  'ALTER INDEX [' +dbindexes.[name]+ '] ON ' + dbschemas.[name] +'.' +'['+dbtables.[name] +'] REBUILD ;'
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
INNER JOIN sys.tables dbtables ON dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas ON dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
AND indexstats.index_id = dbindexes.index_id
WHERE indexstats.database_id = DB_ID() and indexstats.avg_fragmentation_in_percent >30 and dbindexes.[name] is not Null
ORDER BY indexstats.avg_fragmentation_in_percent DESC


--Reorganize
select  'ALTER INDEX [' +dbindexes.[name]+ '] ON ' + dbschemas.[name] +'.' +'['+dbtables.[name] +'] REORGANIZE  WITH ( LOB_COMPACTION = ON ) ;'
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
INNER JOIN sys.tables dbtables ON dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas ON dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
AND indexstats.index_id = dbindexes.index_id
WHERE indexstats.database_id = DB_ID() and indexstats.avg_fragmentation_in_percent <30 and dbindexes.[name] is not Null
ORDER BY indexstats.avg_fragmentation_in_percent DESC



--Script 1: Detecting index fragmentation

SELECT dbschemas.[name] AS 'Schema',
dbtables.[name] AS 'Table',
dbindexes.[name] AS 'Index',
indexstats.avg_fragmentation_in_percent AS 'Frag (%)',
indexstats.page_count AS 'Page count'
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
INNER JOIN sys.tables dbtables ON dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas ON dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
AND indexstats.index_id = dbindexes.index_id
WHERE indexstats.database_id = DB_ID() and indexstats.avg_fragmentation_in_percent >30 and dbindexes.[name] is not Null
ORDER BY indexstats.avg_fragmentation_in_percent DESC
