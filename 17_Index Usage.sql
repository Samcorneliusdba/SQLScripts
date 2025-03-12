SELECT 
	db_name() as [DB Name],sch.name + '.' + t.name AS [Table Name], 
	i.name AS [Index Name], 
	i.type_desc,  
	s.user_lookups,
	s.user_scans,
	s.user_seeks,
	ISNULL(user_seeks + user_scans + user_lookups,0) AS [Total Reads],
	ISNULL(user_updates,0) AS [Total Writes], 
	ISNULL(user_updates,0) - ISNULL((user_seeks + user_scans + user_lookups),0) AS [W-R=Difference],  
	s.last_user_seek, 
	s.last_user_scan ,
	s.last_user_lookup,
	p.reserved_page_count * 8.0 / 1024 as SpaceInMB,
	p.row_count
	
FROM sys.indexes AS i WITH (NOLOCK)  
	LEFT OUTER JOIN sys.dm_db_index_usage_stats AS s	WITH (NOLOCK) ON s.object_id = i.object_id  AND i.index_id = s.index_id  AND s.database_id=db_id()  AND objectproperty(s.object_id,'IsUserTable') = 1  
	INNER JOIN		sys.tables					AS t	WITH (NOLOCK) ON i.object_id = t.object_id  
	INNER JOIN		sys.schemas					AS sch	WITH (NOLOCK) ON t.schema_id = sch.schema_id  
	LEFT OUTER JOIN sys.dm_db_partition_stats	AS p	WITH (NOLOCK) ON i.index_id = p.index_id and i.object_id = p.object_id
WHERE i.name IS NOT NULL
	--AND ISNULL(user_updates,0) >= ISNULL((user_seeks + user_scans + user_lookups),0) --shows all indexes including those that have not been used  
	--AND ISNULL(user_updates,0) - ISNULL((user_seeks + user_scans + user_lookups),0)>0 --only shows those indexes which have been used  
	--AND i.index_id > 1			-- Only non-first indexes (I.E. non-primary key)
	--AND i.is_primary_key<>1		-- Only those that are not defined as a Primary Key)
	--AND i.is_unique_constraint<>1 -- Only those that are not classed as "UniqueConstraints".  
ORDER BY [W-R=Difference] desc,[Table Name], [index name]
