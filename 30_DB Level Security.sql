set nocount off


DECLARE @db_name sysname
DECLARE @exec_stmt nvarchar(3550)
Declare
       @charMaxLenLoginName            varchar(11)
      ,@charMaxLenDBName               varchar(11)
      ,@charMaxLenUserName             varchar(11)
      ,@charMaxLenLangName             varchar(11)

declare
	@user_name			sysname
   ,@login_name			sysname
   ,@alias				char(8)
   ,@review				varchar(2)
   ,@default_db			varchar(255)
   ,@public				varchar(1)
   ,@db_owner			varchar(1)
   ,@db_datareader		varchar(1)
   ,@db_datawriter		varchar(1)
   ,@db_accessadmin		varchar(1)
   ,@db_securityadmin	varchar(1)
   ,@db_ddladmin		varchar(1)
   ,@db_backupoperator	varchar(1)
   ,@db_denydatareader	varchar(1)
   ,@db_denydatawriter	varchar(1)

CREATE Table #tb1
   (
    DBName		sysname			
   ,UserName		sysname		
   ,LoginName		sysname		
   ,UserOrAlias		char(8)		
   ,Review		varchar(2)	DEFAULT 'Ok'
   ,DefaultDB		varchar(255)	DEFAULT ''	
   ,[public]		varchar(1)	DEFAULT '0'
   ,db_owner		varchar(1)	DEFAULT '0'
   ,db_datareader	varchar(1)	DEFAULT '0' 	
   ,db_datawriter	varchar(1)	DEFAULT '0' 	
   ,db_accessadmin	varchar(1)	DEFAULT '0'	
   ,db_securityadmin	varchar(1)	DEFAULT '0' 	
   ,db_ddladmin		varchar(1)	DEFAULT '0' 	
   ,db_backupoperator	varchar(1)	DEFAULT '0' 	
   ,db_denydatareader	varchar(1)	DEFAULT '0' 	
   ,db_denydatawriter	varchar(1)	DEFAULT '0' 
)

CREATE Table #tb2
   (
    DBName		sysname		
   ,UserName		sysname		
   ,LoginName		sysname		
   ,Review		varchar(2)	DEFAULT 'Ok'
   ,DefaultDB		varchar(255)	DEFAULT ''	
   ,[public]		varchar(1)	DEFAULT '0'
   ,db_owner		varchar(1)	DEFAULT '0'
   ,db_datareader	varchar(1)	DEFAULT '0' 	
   ,db_datawriter	varchar(1)	DEFAULT '0' 	
   ,db_accessadmin	varchar(1)	DEFAULT '0'	
   ,db_securityadmin	varchar(1)	DEFAULT '0' 	
   ,db_ddladmin		varchar(1)	DEFAULT '0' 	
   ,db_backupoperator	varchar(1)	DEFAULT '0' 	
   ,db_denydatareader	varchar(1)	DEFAULT '0' 	
   ,db_denydatawriter	varchar(1)	DEFAULT '0'
   ,another_permissions	varchar(1)	DEFAULT '0'
   ,another_permissions_char	varchar(1000)	DEFAULT ''
)










DECLARE db_names_cursor Cursor local static For
SELECT [name] from master.dbo.sysdatabases

OPEN db_names_cursor

FETCH NEXT FROM db_names_cursor INTO @db_name
WHILE @@FETCH_STATUS = 0
BEGIN


set @exec_stmt = '
   INSERT    #tb1
            (
             DBName
            ,LoginName
            ,UserName
            ,UserOrAlias
			,DefaultDB
            )
      Select
             N' + quotename(@db_name, '''') + '
            ,l.loginname
            ,u.name
            ,''User''
			,l.dbname
         from
             ' + quotename(@db_name, '[') + '.dbo.sysusers       u
            ,master.dbo.syslogins                  l
         where ' + 
             ' u.sid  = l.sid ' 
			--+ ' AND isaliased=0 '
      +
      'UNION
      Select

             N' + quotename(@db_name, '''') + '
            ,l.loginname
            ,u2.name
            ,''MemberOf''
			,l.dbname
         from
             ' + quotename(@db_name, '[')+ '.dbo.sysmembers	   m
            ,' + quotename(@db_name, '[')+ '.dbo.sysusers       u1
            ,' + quotename(@db_name, '[')+ '.dbo.sysusers       u2
            ,master.dbo.syslogins                  l
         where			 
             u1.sid     = l.sid
         and m.memberuid = u1.uid
		 and m.groupuid  = u2.uid'



   EXECUTE(@exec_stmt)



   FETCH NEXT FROM db_names_cursor INTO @db_name

END





SELECT
	 @charMaxLenLoginName   = convert ( varchar ,isnull ( max(datalength(LoginName)) ,9))
	,@charMaxLenDBName      = convert ( varchar ,isnull ( max(datalength(DBName)) ,6))
	,@charMaxLenUserName    = convert ( varchar ,isnull ( max(datalength(UserName)) ,8))
    from #tb1












CLOSE db_names_cursor
DEALLOCATE db_names_cursor





insert #tb2 (DBName ,UserName ,LoginName ,DefaultDB, [public]) 
       select DISTINCT  DBName, UserName, LoginName, DefaultDB, '1' from #tb1 where UserOrAlias = 'User'







DECLARE dbms_cursor Cursor local static For
SELECT * from #tb1

OPEN dbms_cursor

FETCH NEXT FROM dbms_cursor INTO 
    @db_name
   ,@user_name			
   ,@login_name			
   ,@alias				
   ,@review				
   ,@default_db			
   ,@public				
   ,@db_owner			
   ,@db_datareader		
   ,@db_datawriter		
   ,@db_accessadmin		
   ,@db_securityadmin	
   ,@db_ddladmin		
   ,@db_backupoperator	
   ,@db_denydatareader	
   ,@db_denydatawriter	

WHILE @@FETCH_STATUS = 0
BEGIN

set @exec_stmt = ''

IF @alias = 'MemberOf'
BEGIN
   set @exec_stmt = 
   CASE @user_name 
      WHEN 'db_owner' THEN 'update #tb2 SET db_owner = 1 WHERE dbname = ' + quotename(@db_name, '''') + ' and LoginName = ' + quotename(@login_name, '''')
      WHEN 'db_datareader' THEN 'update #tb2 SET db_datareader = 1 WHERE dbname = ' + quotename(@db_name, '''') + ' and LoginName = ' + quotename(@login_name, '''')
      WHEN 'db_datawriter' THEN 'update #tb2 SET db_datawriter = 1 WHERE dbname = ' + quotename(@db_name, '''') + ' and LoginName = ' + quotename(@login_name, '''')
      WHEN 'db_accessadmin' THEN 'update #tb2 SET db_accessadmin = 1 WHERE dbname = ' + quotename(@db_name, '''') + ' and LoginName = ' + quotename(@login_name, '''')
      WHEN 'db_securityadmin' THEN 'update #tb2 SET db_securityadmin = 1 WHERE dbname = ' + quotename(@db_name, '''') + ' and LoginName = ' + quotename(@login_name, '''')
      WHEN 'db_ddladmin' THEN 'update #tb2 SET db_ddladmin = 1 WHERE dbname = ' + quotename(@db_name, '''') + ' and LoginName = ' + quotename(@login_name, '''')
      WHEN 'db_backupoperator' THEN 'update #tb2 SET db_backupoperator = 1 WHERE dbname = ' + quotename(@db_name, '''') + ' and LoginName = ' + quotename(@login_name, '''')
      WHEN 'db_denydatareader' THEN 'update #tb2 SET db_denydatareader = 1 WHERE dbname = ' + quotename(@db_name, '''') + ' and LoginName = ' + quotename(@login_name, '''')
      WHEN 'db_denydatawriter' THEN 'update #tb2 SET db_denydatawriter = 1 WHERE dbname = ' + quotename(@db_name, '''') + ' and LoginName = ' + quotename(@login_name, '''')
      ELSE 'update #tb2 SET another_permissions = 1, another_permissions_char = ' + quotename(@user_name, '''') + ' WHERE dbname = ' + quotename(@db_name, '''') + ' and LoginName = ' + quotename(@login_name, '''')
      --ELSE 'update #tb2 SET another_permissions = 1 WHERE dbname = ' + quotename(@db_name, '''') + ' and LoginName = ' + quotename(@login_name, '''')
   END
END

--select @exec_stmt

if @exec_stmt <> ''   EXECUTE(@exec_stmt)
	

FETCH NEXT FROM dbms_cursor INTO 
    @db_name
   ,@user_name			
   ,@login_name			
   ,@alias				
   ,@review				
   ,@default_db			
   ,@public				
   ,@db_owner			
   ,@db_datareader		
   ,@db_datawriter		
   ,@db_accessadmin		
   ,@db_securityadmin	
   ,@db_ddladmin		
   ,@db_backupoperator	
   ,@db_denydatareader	
   ,@db_denydatawriter

END



CLOSE dbms_cursor
DEALLOCATE dbms_cursor








--SELECT * FROM #tb1
DROP TABLE #tb1

SELECT * FROM #tb2
DROP TABLE #tb2



