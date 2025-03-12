SELECT 
--s.server_name,
s.database_name as 'DB Name',
CAST(CAST(s.backup_size / 1000000 AS INT) AS VARCHAR(14)) + ' ' + 'MB' AS Backup_Size,
CAST(DATEDIFF(SECOND, s.backup_start_date,
s.backup_finish_date) AS VARCHAR(400)) + ' ' + 'Seconds' TimeTaken,
s.backup_start_date as 'Start Time',
s.backup_finish_date as 'End Time',
CASE s.[type]
WHEN 'D' THEN 'Full'
WHEN 'I' THEN 'Differential'
WHEN 'L' THEN 'Transaction Log'
END AS BackupType,
s.recovery_model,
m.physical_device_name

FROM msdb.dbo.backupset s
INNER JOIN msdb.dbo.backupmediafamily m ON s.media_set_id = m.media_set_id
--WHERE s.database_name = DB_NAME() -- Remove this line for all the database

where  (convert(datetime, s.backup_start_date, 102) >= getdate() - 7)  
ORDER BY 
backup_start_date DESC, backup_finish_date
GO