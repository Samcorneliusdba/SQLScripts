-- write everything from your buffers to the disc!
CHECKPOINT; 
GO
-- Clean all buffers and caches
DBCC DROPCLEANBUFFERS; 
DBCC FREEPROCCACHE;
DBCC FREESYSTEMCACHE('ALL');
DBCC FREESESSIONCACHE;
GO
-- Now shrink the file to your desired size
DBCC SHRINKFILE (TEMPDb4, 4);
