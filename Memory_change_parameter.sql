
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE WITH OVERRIDE;
EXEC sp_configure 'max server memory', 40960
RECONFIGURE WITH OVERRIDE;