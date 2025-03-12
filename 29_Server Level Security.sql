SELECT a.name as LoginName,a.type_desc AS LoginType, a.default_database_name AS DefaultDBName,
CASE WHEN b.sysadmin = 1 THEN 'sysadmin'
          WHEN b.securityadmin=1 THEN 'securityadmin'
          WHEN b.serveradmin=1 THEN 'serveradmin'
          WHEN b.setupadmin=1 THEN 'setupadmin'
          WHEN b.processadmin=1 THEN 'processadmin'
          WHEN b.diskadmin=1 THEN 'diskadmin'
          WHEN b.dbcreator=1 THEN 'dbcreator'
          WHEN b.bulkadmin=1 THEN 'bulkadmin'
          ELSE 'Public' 
		  END AS 'ServerRole'
FROM sys.server_principals a  JOIN master..syslogins b ON a.sid=b.sid WHERE a.type  <> 'R' AND 
a.name NOT LIKE '##%' AND a.name NOT LIKE 'NT%' AND a.name <> 'public'  ORDER BY a.Name
