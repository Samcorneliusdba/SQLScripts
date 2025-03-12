Use [tempdb]
go
-----------------------------------------------
-- Declaring variables, tables and settings --
-----------------------------------------------

DECLARE @versionnumber varchar(max)
DECLARE @notupgradable bit
DECLARE @maxram bigint
DECLARE @totalram bigint
DECLARE @aweenabled bit
DECLARE @version int
DECLARE @SQL NVARCHAR(1000)

DECLARE @sum_drives bit
DECLARE @sum_backup bit
DECLARE @sum_jobs bit
DECLARE @sum_errorlog bit

IF OBJECT_ID('tempdb.dbo.##ReviewResults', 'U') IS NOT NULL
DROP TABLE dbo.##ReviewResults

CREATE TABLE dbo.##ReviewResults (
	FirstValue varchar(max) NULL DEFAULT '',
	SecondValue varchar(max) NULL DEFAULT '',
	ThirdValue varchar(max) NULL DEFAULT '',
	FourthValue varchar(max) NULL DEFAULT '',
	FifthValue varchar(max) NULL DEFAULT '',
	SixthValue varchar(max) NULL DEFAULT '',
	SeventhValue varchar(max) NULL DEFAULT '',
	EighthValue varchar(max) NULL DEFAULT '',
	NinethValue varchar(max) NULL DEFAULT '',
	TenthValue varchar(max) NULL DEFAULT '',
	ElevenValue varchar(max) NULL DEFAULT '',
	TwelfthValue varchar(max) NULL DEFAULT '',
	ThirteenValue varchar(max) NULL DEFAULT '',
	FourteenValue varchar(max) NULL DEFAULT '',
	FiveTeenValue varchar(max) NULL DEFAULT '',
	SixteenValue varchar(max) NULL DEFAULT '',
	SevenTeenValue varchar(max) NULL DEFAULT '',
	EighteenValue varchar(max) NULL DEFAULT '',
	NineteenValue varchar(max) NULL DEFAULT '',
	TwentyValue varchar(max) NULL DEFAULT '',
	TwentyOneValue varchar(max) NULL DEFAULT '',
	TwentyTwoValue varchar(max) NULL DEFAULT '',
	TwentyThreeValue varchar(max) NULL DEFAULT '',
	TwentyFourValue varchar(max) NULL DEFAULT '',
	TwentyFiveValue varchar(max) NULL DEFAULT '',
	TwentySixValue varchar(max) NULL DEFAULT '',
	TwentySevenValue varchar(max) NULL DEFAULT '',
	TwentyEightValue varchar(max) NULL DEFAULT '',
	TwentyNineValue varchar(max) NULL DEFAULT ''
);

IF OBJECT_ID('tempdb.dbo.##FinalReviewResults', 'U') IS NOT NULL
  DROP TABLE dbo.##FinalReviewResults;

CREATE TABLE dbo.##FinalReviewResults (
	FirstValue varchar(max) NULL DEFAULT '',
	SecondValue varchar(max) NULL DEFAULT '',
	ThirdValue varchar(max) NULL DEFAULT '',
	FourthValue varchar(max) NULL DEFAULT '',
	FifthValue varchar(max) NULL DEFAULT '',
	SixthValue varchar(max) NULL DEFAULT '',
	SeventhValue varchar(max) NULL DEFAULT '',
	EighthValue varchar(max) NULL DEFAULT '',
	NinethValue varchar(max) NULL DEFAULT '',
	TenthValue varchar(max) NULL DEFAULT '',
	ElevenValue varchar(max) NULL DEFAULT '',
	TwelfthValue varchar(max) NULL DEFAULT '',
	ThirteenValue varchar(max) NULL DEFAULT '',
	FourteenValue varchar(max) NULL DEFAULT '',
	FiveTeenValue varchar(max) NULL DEFAULT '',
	SixteenValue varchar(max) NULL DEFAULT '',
	SevenTeenValue varchar(max) NULL DEFAULT '',
	EighteenValue varchar(max) NULL DEFAULT '',
	NineteenValue varchar(max) NULL DEFAULT '',
	TwentyValue varchar(max) NULL DEFAULT '',
	TwentyOneValue varchar(max) NULL DEFAULT '',
	TwentyTwoValue varchar(max) NULL DEFAULT '',
	TwentyThreeValue varchar(max) NULL DEFAULT '',
	TwentyFourValue varchar(max) NULL DEFAULT '',
	TwentyFiveValue varchar(max) NULL DEFAULT '',
	TwentySixValue varchar(max) NULL DEFAULT '',
	TwentySevenValue varchar(max) NULL DEFAULT '',
	TwentyEightValue varchar(max) NULL DEFAULT '',
	TwentyNineValue varchar(max) NULL DEFAULT ''
);

SET ARITHIGNORE ON
SET NOCOUNT ON

declare @chkCMDShell as sql_variant
declare @ShAdvOpt as sql_variant
select @chkCMDShell = value from sys.configurations where name = 'xp_cmdshell'
select @ShAdvOpt=value from sys.configurations where name like 'show advanced options'

if @chkCMDShell = 0 and @ShAdvOpt = 0
begin
	EXEC sp_configure 'show advanced options', 1
	RECONFIGURE;
	
	EXEC sp_configure 'xp_cmdshell', 1
	RECONFIGURE;
	
end
else if @chkCMDShell = 0 and @ShAdvOpt = 1
    Begin
	EXEC sp_configure 'xp_cmdshell', 1
	RECONFIGURE;
	end
else
begin
 Print 'xp_cmdshell is already enabled'
end


---------------------------------------------------------------------------
---- Server Information 
--------------------------------------------------------------------------

INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
INSERT INTO dbo.##ReviewResults SELECT 'SERVER INFORMATION', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';


IF EXISTS(SELECT 1 FROM tempdb..sysobjects where name ='##ServerReview') 
	DROP table ##ServerReview 
  CREATE TABLE ##ServerReview 
		(
			ServerName varchar(255),
			InstName varchar(255) ,
			[Edition] varchar(255),
			[Platform] varchar(255),
			[Processors] varchar(255),
			[WindowsVersion] varchar(255),
			[OSVersion] varchar(255),
			StartTime varchar(255),
			[IsClustered] varchar(255),
			[Active Cluster Node] varchar(255),
			[IsFullTextInstalled] varchar(255),
			[IsIntegratedSecurityOnly] varchar(255)
		)



DECLARE @sname VARCHAR(255)
DECLARE @insname VARCHAR(255)
DECLARE @Edition varchar(255)
DECLARE @Platform varchar(255)
DECLARE @Processors varchar(255)
DECLARE @starttime VARCHAR(255)
DECLARE @WindowsVersion varchar(255)
DECLARE @OSVersion varchar(255)
DECLARE @IsClustered varchar(255)
DECLARE @ActiveClusterNode varchar(255)
DECLARE @IsFullTextInstalled varchar(255)
DECLARE @IsIntegratedSecurityOnly varchar(255)


-- get server name
SELECT @sname = @@SERVERNAME


--get instance name
IF (serverproperty('InstanceName')) IS NOT NULL
	BEGIN
		SET @insname='mssql$'+CONVERT(VARCHAR(40),serverproperty('InstanceName'))		
	END
ELSE
	BEGIN
		SET @insname='mssqlserver'
	END

--Create ##server table for fetching details of platform,processor count,version

  IF EXISTS(SELECT 1 FROM tempdb..sysobjects where name ='##server') 
	DROP table ##server
    CREATE TABLE ##server
		(	ID int,
			Name  sysname null,
			Internal_Value int null,
			Value nvarchar(512) null
		)

IF OBJECT_ID('tempdb.dbo.#WinNames','U') IS NOT NULL
DROP TABLE #WinNames
CREATE TABLE #WinNames
(
WinID float,
WinName varchar(max)
)

insert into #WinNames values (3.10,'Windows NT 3.1')
insert into #WinNames values (3.50,'Windows NT 3.5')
insert into #WinNames values (3.51,'Windows NT 3.51')
insert into #WinNames values (4.0,'Windows NT 4.0')
insert into #WinNames values (5.0,'Windows 2000')
insert into #WinNames values (5.1,'Windows Server 2003')
insert into #WinNames values (5.2,'Windows Server 2003 R2')
insert into #WinNames values (3.50,'Windows NT 3.5')
insert into #WinNames values (3.10,'Windows NT 3.1')
insert into #WinNames values (6.0,'Windows Server 2008')
insert into #WinNames values (6.1,'Windows Server 2008 R2')
insert into #WinNames values (6.2,'Windows Server 2012')
insert into #WinNames values (6.3,'Windows Server 2012 R2')

IF OBJECT_ID('tempdb.dbo.#WVer', 'U') IS NOT NULL
DROP TABLE #WVer

IF OBJECT_ID('tempdb.dbo.#WVer1', 'U') IS NOT NULL
DROP TABLE #WVer1

SELECT OSVersion =RIGHT(@@version, LEN(@@version)- 3 -charindex (' ON ', @@VERSION)) into #WVer

select SUBSTRING(OSVersion, 11,4 ) AS WinID, OSVersion into  #WVer1 from #WVer


--Fetch details in server table
insert ##server exec master.dbo.xp_msver

-- get Edition
select @Edition = CAST(SERVERPROPERTY(N'Edition') AS sysname)

-- get Platform
select @Platform =  Value from ##server where Name = N'Platform' 

-- get Processors#
select @Processors = Internal_Value from ##server where Name = N'ProcessorCount'

-- get winodws Version
select @WindowsVersion = WinName from #WinNames 

-- get OS Version 
select @OSVersion = OSVersion from #WVer 

-- get start time
SELECT @starttime=CONVERT(VARCHAR(30),create_date,109) from sys.databases where database_id=2

drop table #WVer1
drop table #WVer
drop table #WinNames


 -- get IsClustered
If SERVERPROPERTY('IsClustered')= 0 Set @IsClustered = 'No'
 ELSE  SET @IsClustered = 'Yes'

 -- get Active Cluster Node
If SERVERPROPERTY('IsClustered')= 1 SET  @ActiveClusterNode = CAST(SERVERPROPERTY('ComputerNamePhysicalNetBIOS')AS VARCHAR)
 ELSE SET  @ActiveClusterNode ='NA'

 -- get IsFullTextInstalled
If SERVERPROPERTY('IsFullTextInstalled') = 0  SET @IsFullTextInstalled = 'No'
 ELSE SET @IsFullTextInstalled = 'Yes'

 -- get IsIntegratedSecurity
If SERVERPROPERTY('IsIntegratedSecurityOnly') = 0 SET @IsIntegratedSecurityOnly = 'No'
 ELSE SET @IsIntegratedSecurityOnly = 'Yes'

 -- collect output and put in table


Insert into ##ServerReview  values (@sname, @insname, @Edition, @Platform, @Processors,@WindowsVersion , @OSVersion, @starttime, @IsClustered, @ActiveClusterNode, @IsFullTextInstalled, @IsIntegratedSecurityOnly)


INSERT INTO dbo.##ReviewResults SELECT 'ServerName' , 'Instance Name'  , 'Edition', 'Platform' , 'Processors' , 'WindowsVersion' , 'OSVersion', 'StartTime' ,  'IsClustered', 'Active Cluster Node' , 'IsFullTextInstalled' , 'IsIntegratedSecurityOnly','','','','','','','','','','','','','','','','','';							

INSERT INTO dbo.##ReviewResults select *,'', '','','','','','','','','','','','','','','','' from ##ServerReview



-----------------------------------------------
-- Version check ---
-----------------------------------------------

INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';;
INSERT INTO dbo.##ReviewResults SELECT 'VERSION CHECK', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';;


SET @versionnumber = CONVERT(varchar,SERVERPROPERTY('productversion'));

IF @versionnumber = '13.0.1601.5' OR @versionnumber = '12.0.5000.0' OR @versionnumber = '11.00.6020.0' OR @versionnumber = '10.50.6000.34' OR @versionnumber = '10.0.6000.29' OR @versionnumber = '9.0.5000.0'
	SET @notupgradable = 1
ELSE
	
	SET @notupgradable = 0
IF @versionnumber LIKE '%13.0%' SET @version = 16
IF @versionnumber LIKE '%12.0%' SET @version = 14	
IF @versionnumber LIKE '%11.0%' SET @version = 12
IF @versionnumber LIKE '%10.5%' SET @version = 82
IF @versionnumber LIKE '%10.0%' SET @version = 8
IF @versionnumber LIKE '%9.0%' SET @version = 5


IF @versionnumber LIKE '%12.0.5%' SET @notupgradable = 1
IF @versionnumber LIKE '%11.0.6%' SET @notupgradable = 1
IF @versionnumber LIKE '%10.50.6%' SET @notupgradable = 1
IF @versionnumber LIKE '%10.00.6%' SET @notupgradable = 1
IF @versionnumber LIKE '%10.0.6%' SET @notupgradable = 1
IF @versionnumber LIKE '%9.00.5%' SET @notupgradable = 1
IF @versionnumber LIKE '%9.0.5%' SET @notupgradable = 1


INSERT INTO dbo.##ReviewResults SELECT 'Current MS SQL Version', 'Recommendations','Recommended version','','','','','','','','','','','','','','', '','','','','','','','','','','','';

IF @notupgradable = 1
	INSERT INTO dbo.##ReviewResults SELECT @versionnumber, CASE @notupgradable WHEN 1 THEN 'Latest version' ELSE 'Updates available' END,'-','','','','','','','','','','','','','','', '','','','','','','','','','','','';
ELSE
	INSERT INTO dbo.##ReviewResults SELECT @versionnumber, CASE @notupgradable WHEN 1 THEN 'Latest version' ELSE 'Updates available' END, CASE @version when 14 then '12.0.5000.0 SP2'  WHEN 12 THEN '11.0.6020.0, SP3' WHEN 82 THEN '10.50.6000.34, SP3' WHEN 8 THEN '10.0.6000.29, SP4' WHEN 5 THEN '9.0.5000, SP4' END,'','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';;

-----------------------------------------------
-- RAM check --
-----------------------------------------------

INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
INSERT INTO dbo.##ReviewResults SELECT 'MEMORY CHECK', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';



SET @maxram = CONVERT(bigint,(SELECT value AS 'Max SQL RAM' FROM sys.configurations WHERE name like '%x server memory%'))

IF @versionnumber LIKE '%9%'
BEGIN
	IF OBJECT_ID('tempdb.dbo.###SVer', 'U') IS NOT NULL
	  DROP TABLE dbo.##SVer;

	CREATE TABLE ##SVer(ID int,  Name  sysname, Internal_Value int, Value nvarchar(512))
	INSERT ##SVer exec master.dbo.xp_msver

	SELECT @totalram = Internal_Value FROM ##SVer WHere Name = 'PhysicalMemory'

	DROP TABLE ##SVer
END

ELSE SET @totalram = (select total_physical_memory_kb/1024 from sys.dm_os_sys_memory)


INSERT INTO dbo.##ReviewResults SELECT 'Current Max MS SQL RAM Setting', 'Total Server RAM','Recommendations','Recommended action','','','','','','','','','','','','','','','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT @maxram, @totalram, CASE @maxram WHEN 2147483647 THEN 'Recommended to change' ELSE 'Setting OK' END,CASE @maxram WHEN 2147483647 THEN 'Configure MAX SQL Server RAM' ELSE '' END,'','','','','','','','','','','','','','','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

-----------------------------------------------
-- AWE check --
-----------------------------------------------


INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
INSERT INTO dbo.##ReviewResults SELECT 'AWE CHECK', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

SET @aweenabled = CONVERT(bit, (select value from sys.configurations where description like '%awe%'))

INSERT INTO dbo.##ReviewResults SELECT 'Current AWE Setting', 'Recommendations','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT CASE @aweenabled WHEN 1 THEN 'Enabled' ELSE 'Disabled' END, CASE @aweenabled WHEN 1 THEN 'Upgrade to x64 OS and SQL' ELSE 'No actions required' END,'','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';


-----------------------------------------------------------------------------
----- High availability and disaster recovery status
-----------------------------------------------------------------------------


INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
INSERT INTO dbo.##ReviewResults SELECT 'HIGH AVAILABILITY AND DISASTER RECOVERY STATUS', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';



DECLARE @mirstatus varchar(255),@lsstatus varchar(255),@replstatus varchar(255), @agstatus varchar(255)


IF OBJECT_ID('TEMPDB.DBO.##HACONFIG', 'U') IS NOT NULL
DROP TABLE ##HACONFIG
CREATE TABLE ##HACONFIG
( Mirroring_Status varchar(255),
			LS_Status varchar(255),
			Repl_Status varchar(255),
			AG_Status varchar(255)
)


--Check if Mirroring is enabled for any DB, if yes then check if working propely or not
IF EXISTS (SELECT 1 FROM sys.database_mirroring WHERE mirroring_role_desc IN ('PRINCIPAL','MIRROR'))
	BEGIN
   		IF EXISTS ( SELECT 1 FROM sys.database_mirroring WHERE mirroring_state_desc NOT IN ('SYNCHRONIZED','SYNCHRONIZING'))
			BEGIN
				SET @mirstatus = 'Mirroring is broken for Some of the database(s)'
			END
		ELSE
			BEGIN
				SET @mirstatus = 'GOOD'
			END
	END
ELSE
	BEGIN
		SET @mirstatus = 'N/A'
	END

-- Check if Replication is enabled for any DB, if yes then check if working propely or not
IF EXISTS ( select 1  from sys.databases  where is_published = 1 or is_subscribed = 1 or  is_merge_published = 1 or is_distributor = 1 )
	BEGIN
		IF EXISTS (select 1 from msdb.dbo.sysjobhistory h JOIN msdb.dbo.sysjobs j ON j.job_id = h.job_id JOIN msdb.dbo.syscategories c ON j.category_id = c.category_id
						where @starttime < msdb.dbo.agent_datetime(h.run_date, h.run_time) and c.name like '%REPL%' and h.run_status = 0)
			BEGIN
					SET @replstatus = 'Replication Job Faild'
			END
		ELSE
			BEGIN
					SET @replstatus = 'GOOD'
			END
	END
ELSE
	BEGIN
		SET @replstatus = 'N/A'
	END



-- Check if Log Shipping is enabled for any DB If yes then check if working properly or not
IF exists ( select 1 from tempdb..sysobjects where name = '##log_shipping_monitor')
	drop table ##log_shipping_monitor

CREATE TABLE ##log_shipping_monitor
    (
        status bit null
        ,is_primary bit not null default 0
        ,[server] sysname 
        ,database_name sysname
        ,time_since_last_backup int null
        ,last_backup_file nvarchar(500) null
        ,backup_threshold int null
        ,is_backup_alert_enabled bit null
        ,time_since_last_copy int null
        ,last_copied_file nvarchar(500) null
        ,time_since_last_restore int null
        ,last_restored_file nvarchar(500) null
        ,last_restored_latency int null
        ,restore_threshold int null
        ,is_restore_alert_enabled bit null
    )
Insert Into ##log_shipping_monitor exec master.dbo.sp_help_log_shipping_monitor
IF EXISTS ( SELECT 1 FROM msdb..log_shipping_primary_databases pt full join msdb..[log_shipping_monitor_secondary] st ON pt.primary_database = st.secondary_database )
	BEGIN
	     IF EXISTS ( select 1 from ##log_shipping_monitor where status = 0 )
			BEGIN
                 SET @lsstatus = 'GOOD'
			END
         ELSE 
			BEGIN
                SET @lsstatus = 'NOT SYNCED'
			END
	END
ELSE
	BEGIN
		SET @lsstatus = 'N/A'
	END

--Check if AOAG is enabled for any DB, if yes then check if working properly or not
IF SERVERPROPERTY ('IsHadrEnabled') = 1
	BEGIN
       IF EXISTS (select 1 from sys.dm_hadr_availability_replica_states where synchronization_health_desc NOT like 'HEALTHY')
	   BEGIN
			SET @agstatus = 'NOT HEALTHY'
	   END
	   ELSE IF EXISTS (select 1 from sys.availability_group_listener_ip_addresses where state_desc not like 'ONLINE')
			BEGIN
				SET @agstatus = 'Listner Down'
			END
		ELSE
			BEGIN
				SET @agstatus = 'GOOD'
			END
	END
ELSE
  BEGIN
	SET @agstatus = 'N/A'
  END

  INSERT INTO ##HACONFIG SELECT @mirstatus, @lsstatus, @replstatus, @agstatus

  --SELECT * FROM ##HACONFIG


INSERT INTO dbo.##ReviewResults SELECT 'Mirroring Status' , 'Log Shipping Status' , 'Replication Status', 'AlwaysON HA Status' , '' , '' , '', '' , '' , '' , '',	'' , '', '' , '' , '','','','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT *,'' , '' , '', '' , '' , '' , '' , '' , '', '' , '' , '','','','','','','','','','','','','',''  FROM ##HACONFIG;

----- 

DECLARE @HAConfigStatus varchar(255)
DECLARE @HAConfig_State int


SET @HAConfigStatus = ( select count(*) from ##HACONFIG where  Mirroring_Status <> 'GOOD' and LS_Status <> 'GOOD' and Repl_Status <> 'GOOD' and AG_Status <> 'GOOD' )

IF @HAConfig_State > 0

	SET @HAConfig_State = 0

ELSE

	SET @HAConfig_State = 1


-------------------------------------------------------------------------
---- Database Configuration Check
------------------------------------------------------------------------

INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
INSERT INTO dbo.##ReviewResults SELECT 'DATABASE CONFIGURATION CHECK', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';


IF OBJECT_ID('tempdb.dbo.##DBCONFIGURATION', 'U') IS NOT NULL
DROP TABLE ##DBCONFIGURATION
CREATE TABLE ##DBCONFIGURATION
(	 database_id VARCHAR(255)
	,Name VARCHAR(255)
	,create_date DATETIME
	,owner_sid VARCHAR(255)
	,state_desc VARCHAR(255)
	,recovery_model_desc VARCHAR(255)
	,collation_name VARCHAR(255)
	,user_access_desc VARCHAR(255)
	,compatibility_level VARCHAR(255)
	,page_verify_option_desc VARCHAR(255)
	,is_read_only VARCHAR(255)
	,is_auto_close_on VARCHAR(255)
	,is_auto_shrink_on VARCHAR(255)
	,is_auto_create_stats_on VARCHAR(255)
	,is_auto_update_stats_on VARCHAR(255)
	,is_fulltext_enabled VARCHAR(255)
	,is_trustworthy_on VARCHAR(255)
	--,is_encrypted VARCHAR(255)
	--,is_cdc_enabled VARCHAR(255)
	,is_published VARCHAR(255)
	,is_subscribed VARCHAR(255)
	,primary_database VARCHAR(255)
	,mirroring_state_desc VARCHAR(255)
	,mirroring_partner_name VARCHAR(255)
	,mirroring_role_desc VARCHAR(255)
	,mirroring_safety_level_desc VARCHAR(255)
	,mirroring_witness_name VARCHAR(255) 
)



INSERT INTO ##DBCONFIGURATION
SELECT
sysDB.database_id,
sysDB.Name as 'Database Name',
sysdb.create_date as 'Date Created',
case when SUSER_SNAME(sysdb.owner_sid) iS NULL then 'Not Available' else SUSER_SNAME(sysdb.owner_sid) end [DB Owner],
sysDB.state_desc as 'DB_Status',
sysDB.recovery_model_desc as 'Recovery Mode',
sysDB.collation_name as 'Collation',
sysDB.user_access_desc as 'User Access',
sysDB.compatibility_level as compatibility_level,
sysDB.page_verify_option_desc as 'Page Verify Option',
case when sysDB.is_read_only =1 then 'Read_Only' else 'Read_Write' end [ReadOnly or Read_Write],
case when sysDB.is_auto_close_on = 1 then 'On' else 'Off' end [Auto Close Status],
case when sysDB.is_auto_shrink_on = 1 then 'On' else 'Off' end [Auto Shrink Status],
case when sysDB.is_auto_create_stats_on = 1 then 'On' else 'Off' end [Auto Create Stats Status],
case when sysDB.is_auto_update_stats_on = 1 then 'On' else 'Off' end [Auto Update Stats Status],
case when sysDB.is_fulltext_enabled = 1 then 'Enabled' else 'Not Enabled' end [Full Text Status],
case when sysDB.is_trustworthy_on = 1 then 'Yes' else 'No' end [Is_Database_Trustworthy],
--case when sysDB.is_encrypted = 1 then 'Yes' else 'No' end [Is_Database_Encrypted],
--case when sysdb.is_cdc_enabled = 1 then 'Enabled' else 'Not Enabled' end [Is_CDC_Enabled] ,
case when sysDB.is_published = 1 then  'Yes' else 'No' end [Is_Database_Published],
case when sysdb.is_subscribed = 1 then 'Yes' else 'No' end [Is_Database_Subscribed],
case when lp.primary_database IS not null then 'Yes' else 'No' end LSConfigured,
case when sd.mirroring_state_desc IS NULL then 'Not Available' else sd.mirroring_state_desc end [Mirror State Desc] ,
case when sd.mirroring_partner_name IS NULL then 'Not Available' else sd.mirroring_partner_name end  [Partner Name],
case when sd.mirroring_role_desc IS NULL then 'Not Available' else sd.mirroring_role_desc end [Mirror Role] , 
case when sd.mirroring_safety_level_desc  IS NULL then 'Not Available' else sd.mirroring_safety_level_desc end [Safety Level],
case when sd.mirroring_witness_name  IS NULL then 'Not Available' else sd.mirroring_witness_name end [Witness]
  
from sys.databases sysDB
Inner JOIN sys.database_mirroring sd ON sysDB.database_id = sd.database_id
Left JOIN msdb.dbo.log_shipping_monitor_primary LP on lp.primary_database=sysDB.name

--select * from ##DBCONFIGURATION


DECLARE @Version1 VARCHAR(20)
SELECT	@Version1 = CAST (SERVERPROPERTY('ProductVersion') AS VARCHAR(20))

DECLARE @compatibility_level VARCHAR(20)
SET @compatibility_level = CASE WHEN @Version1 LIKE '9%' THEN 90
								WHEN @Version1 LIKE '10%' THEN 100
								WHEN @Version1 LIKE '10.5%' THEN 100
								WHEN @Version1 LIKE '11%' THEN 110 
								WHEN @Version1 LIKE '12%' THEN 120 
								WHEN @Version1 LIKE '13%' THEN 130 ELSE '' END
								

IF OBJECT_ID('TEMPDB.DBO.##dbstatuswarning','U') IS NOT NULL
DROP TABLE ##dbstatuswarning
CREATE TABLE dbo.##dbstatuswarning (
	databasename varchar(max) NOT NULL,
	warning_dbs_state_desc varchar(max), 
	warning_dbs_user_access_desc varchar(max), 
	warning_dbs_compatibility_level varchar(max) ,
	warning_dbs_page_verify_option_desc varchar(max),
	warning_is_auto_shrink_on varchar(max)
	)

DECLARE @dbs_Name varchar(255)
declare @dbs_state_desc varchar(255)
declare @dbs_user_access_desc varchar(255)
declare @dbs_compatibility_level VARCHAR(255)
declare @dbs_page_verify_option_desc varchar(255)
declare @is_auto_shrink_on varchar(255)


DECLARE dbstatuswarning_cursor CURSOR FOR
SELECT name, state_desc, user_access_desc, compatibility_level, page_verify_option_desc, is_auto_shrink_on
FROM dbo.##DBCONFIGURATION

OPEN dbstatuswarning_cursor 

FETCH NEXT from dbstatuswarning_cursor
INTO @dbs_Name, @dbs_state_desc , @dbs_user_access_desc,@dbs_compatibility_level,@dbs_page_verify_option_desc,@is_auto_shrink_on

WHILE @@FETCH_STATUS = 0
BEGIN 
		IF @dbs_state_desc = 'ONLINE'
				BEGIN
				IF @dbs_user_access_desc = 'MULTI_USER'
				BEGIN 
					INSERT INTO ##dbstatuswarning SELECT @dbs_Name,'','','','',''
				END 
				ELSE
				BEGIN
					INSERT INTO ##dbstatuswarning SELECT @dbs_Name,'','Check user access ','','',''
				END
				IF  @dbs_compatibility_level = @compatibility_level
				BEGIN 
					INSERT INTO ##dbstatuswarning SELECT @dbs_Name,'','','','',''
				END 
				ELSE
				BEGIN
					INSERT INTO ##dbstatuswarning SELECT @dbs_Name,'','','Check Compability level ','',''
				END
				IF @dbs_page_verify_option_desc = 'CHECKSUM'
				BEGIN 
					INSERT INTO ##dbstatuswarning SELECT @dbs_Name,'','','','',''
				END 
				ELSE
				BEGIN
					INSERT INTO ##dbstatuswarning SELECT @dbs_Name,'','','','Check page Verify Option ',''
				END
				IF @is_auto_shrink_on = 'OFF'
				BEGIN 
					INSERT INTO ##dbstatuswarning SELECT @dbs_Name,'','','','',''
				END 
				ELSE
				BEGIN
					INSERT INTO ##dbstatuswarning SELECT @dbs_Name,'','','','','Check auto shirnk option '
				END
			END
		ELSE
			BEGIN 
				INSERT INTO ##dbstatuswarning SELECT @dbs_Name,'Skipped: DB not online ','','','',''
			END
						
FETCH NEXT from dbstatuswarning_cursor
INTO @dbs_Name, @dbs_state_desc , @dbs_user_access_desc,@dbs_compatibility_level,@dbs_page_verify_option_desc,@is_auto_shrink_on
END

CLOSE dbstatuswarning_cursor
DEALLOCATE dbstatuswarning_cursor

 --------

if OBJECT_ID('tempdb.dbo.##dbs_status', 'U') IS NOT NULL
drop table ##dbs_status
create table ##dbs_status ( dbname varchar(255), dbs_status VARCHAR(255) )

INSERT INTO ##dbs_status SELECT databasename, warning_dbs_state_desc + warning_dbs_user_access_desc + warning_dbs_compatibility_level + warning_dbs_page_verify_option_desc + warning_is_auto_shrink_on as db_status FROM ##dbstatuswarning

if OBJECT_ID('tempdb.dbo.##dbs_status1', 'U') IS NOT NULL
drop table ##dbs_status1
create table ##dbs_status1 ( dbname1 varchar(255), dbs_status1 VARCHAR(255) )


INSERT INTO ##dbs_status1
SELECT dbname,
           MAX( CASE seq WHEN 1 THEN dbs_status ELSE '' END ) + ' ' +
           MAX( CASE seq WHEN 2 THEN dbs_status ELSE '' END ) + ' ' + 
           MAX( CASE seq WHEN 3 THEN dbs_status ELSE '' END ) + ' ' +
		   MAX( CASE seq WHEN 4 THEN dbs_status ELSE '' END ) + ' ' +
           MAX( CASE seq WHEN 5 THEN dbs_status ELSE '' END ) AS DB_STATUS
      FROM ( SELECT p1.dbname, p1.dbs_status,
                    ( SELECT COUNT(*) 
                        FROM ##dbs_status p2
                        WHERE p2.dbname = p1.dbname
                        AND p2.dbs_status <= p1.dbs_status )
             FROM ##dbs_status p1 ) D ( dbname, dbs_status, seq )
     GROUP BY dbname ;

UPDATE ##dbs_status1 set dbs_status1 = 'OK' where dbs_status1 LIKE ''

INSERT INTO ##ReviewResults SELECT 'DB Configuration Status','Database Id','Database Name','Date Created','DB Owner','DB Status','Recovery Mode','Collation'	,'User Access',	'Compatibility_Level','Page Verify Option',	'ReadOnly or Read_Write','Auto Close Status','Auto Shrink Status',	'Auto Create Stats Status',	'Auto Update Stats Status',	'Full Text Status',
	'Is_Database_Trustworthy','Is_Database_Published','Is_Database_Subscribed','LSConfigured','Mirror State Desc','Partner Name',	'Mirror Role','Safety Level','Witness','','','';


INSERT INTO dbo.##ReviewResults
SELECT ##dbs_status1.dbs_status1,##DBCONFIGURATION.* ,'','','' FROM ##dbs_status1
JOIN ##DBCONFIGURATION 
ON ##dbs_status1.dbname1 = ##DBCONFIGURATION.Name

--select * from dbo.##ReviewResults
--- check status for summary 

declare @db_status1 int

set @db_status1  = ( SELECT COUNT(1) FROM ##dbs_status1
 where ##dbs_status1.dbs_status1 <> 'OK')

print @db_status1

if @db_status1 > 0

	set @db_status1 = 1
else 
	set @db_status1 = 0


------------------------------------------------------------------
---- DATABASE FILES AND AUTOGROWTH CHECK
-----------------------------------------------------------------


INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT 'DATABASE FILES AND AUTOGROWTH CHECK', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';


IF OBJECT_ID('tempdb.dbo.##dbautoconfiguration', 'U') IS NOT NULL
  DROP TABLE dbo.##dbautoconfiguration;

CREATE TABLE dbo.##dbautoconfiguration (
	dbname varchar(max) NULL DEFAULT '',
	type_desc varchar(max) NULL DEFAULT '',
	filegroup varchar(max) NULL DEFAULT '',
	name varchar(max) NULL DEFAULT '',
	current_MB varchar(max) NULL DEFAULT '',
	max_MB varchar(max) NULL DEFAULT '',
	grow_by varchar(max) NULL DEFAULT '',
	grow_type varchar(max) NULL DEFAULT '',
	physical_name varchar(max) NULL DEFAULT ''
	)

INSERT INTO ##dbautoconfiguration
select 
       db_name(database_id) dbname
       ,type_desc
       ,filegroup_name(data_space_id) as filegroup
       ,name
       ,size*8/1024 as 'current_MB'
       ,max_MB = 
              CASE 
                     WHEN max_size = -1 OR max_size = 268435456 THEN 'UNLIMITED'
                     WHEN max_size = 0 THEN 'NO_GROWTH' 
                     WHEN max_size <> -1 OR max_size <> 0 THEN CAST(((max_size * 8) / 1024) AS varchar(15))
                     ELSE 'Unknown'
              END
       ,grow_by = 
              CASE
                     WHEN is_percent_growth = 1 THEN growth
                     WHEN is_percent_growth = 0 THEN growth*8/1024
              END
       ,grow_type =
              CASE
                     WHEN is_percent_growth = 1 THEN 'PERCENT'
                     WHEN is_percent_growth = 0 THEN 'MB'
              END
       ,physical_name
from master.sys.master_files
order by dbname, name


INSERT INTO dbo.##ReviewResults SELECT 'Database Name', 'Type Desc','Filegroup Name','Name','Current Size (MB)','Max Configuration (MB)','Grow By','Grow type','Physical File Name','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT * , '','','','','','','','', '','','','','','','','','','','','' FROM ##dbautoconfiguration






-----------------------------------------------------------------------
--- Database consistency Check 
-----------------------------------------------------------------------



INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT 'DATABASE CONSISTENCY CHECK:', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';


IF OBJECT_ID('tempdb.dbo.#DBInfo', 'U') IS NOT NULL
DROP TABLE #DBInfo
CREATE TABLE #DBInfo (
       Id INT IDENTITY(1,1),
       ParentObject VARCHAR(255),
       [Object] VARCHAR(255),
       Field VARCHAR(255),
       [Value] VARCHAR(255)
)

IF OBJECT_ID('tempdb.dbo.#Value', 'U') IS NOT NULL
DROP TABLE #Value
CREATE TABLE #Value(
DatabaseName VARCHAR(255),
LastDBCCCheckDB_RunDate VARCHAR(255),
DBCC_Status VARCHAR(255)
)

EXECUTE SP_MSFOREACHDB'INSERT INTO #DBInfo Execute (''DBCC DBINFO ( ''''?'''') WITH TABLERESULTS'');
INSERT INTO #Value (DatabaseName) SELECT [Value] FROM #DBInfo WHERE Field IN (''dbi_dbname'');
UPDATE #Value SET LastDBCCCHeckDB_RunDate=(SELECT TOP 1 [Value] FROM #DBInfo WHERE Field IN (''dbi_dbccLastKnownGood'')) where LastDBCCCHeckDB_RunDate is NULL;
TRUNCATE TABLE #DBInfo';



UPDATE #Value set DBCC_Status = CASE 
									 WHEN LastDBCCCHeckDB_RunDate = '1900-01-01 00:00:00.000' THEN 'Never Run'
									 WHEN LastDBCCCHeckDB_RunDate <= getdate() - 7 THEN 'WARNING'
									 WHEN LastDBCCCHeckDB_RunDate > getdate() - 7 THEN 'OK'
									END


INSERT INTO dbo.##ReviewResults SELECT 'Database Name', 'Last DBCC Check','DBCC Status','','','','','','','','','','','','','','', '','','','','','','','','','','','';


INSERT INTO dbo.##ReviewResults
SELECT DatabaseName, LastDBCCCheckDB_RunDate,DBCC_Status,'','','','','','','','','','','','','','', '','','','','','','','','','','','' FROM #Value where DatabaseName <> 'tempdb'


INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';


 ------------- check status

 DECLARE @DBCCStatus varchar(255)

 DECLARE @DBCC_State int

 SET @DBCCStatus = (select count(DBCC_Status) from #Value where DBCC_Status IN ( 'WARNING', 'Never Run') and DatabaseName <> 'tempdb')

 IF @DBCCStatus > 0

	SET @DBCC_State = 1

ELSE
  
  SET @DBCC_State = 0



-----------------------------------------------------------------------------------------
--- Configuration deatils ----
--------------------------------------------------------------------------------------


INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT 'CONFIGURATION DETAILS:', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT 'Name', 'Live In Use','Default Value','','','','','','','','','','','','','','', '','','','','','','','','','','','';


if OBJECT_ID('tempdb.dbo.##configurations') IS NOT NULL
DROP TABLE tempdb.dbo.##configurations
CREATE TABLE dbo.##configurations (
	Name varchar(max) NULL DEFAULT '',
	Live_In_USE varchar(max) NULL DEFAULT '',
	Default_Value varchar(max) NULL DEFAULT ''
	
);

Declare @Configuration int

DECLARE @Version_New VARCHAR(20)
SELECT	@Version_New = CAST (SERVERPROPERTY('ProductVersion') AS VARCHAR(20))

--IF  @Version_New NOT LIKE '10%' 
--and @Version_New NOT LIKE '11%'
--and @Version_New NOT LIKE '12%'
--and @Version_New NOT LIKE '13%'

BEGIN

PRINT 'Currently this works only on SQL Server 2008, 2008R2 and 2012'

END

IF @Version_New LIKE '9%'
BEGIN

Print 'SQL Server 2005 Check'
PRINT ''

-- SQL Server 2008R2 Defaults
DECLARE @Default_configurations_options_table_2005 TABLE
(name varchar(500), Default_Value BIGINT)

insert into @Default_configurations_options_table_2005 values('Ad Hoc Distributed Queries',0)
insert into @Default_configurations_options_table_2005 values('affinity I/O mask',0)
insert into @Default_configurations_options_table_2005 values('affinity mask',0)
insert into @Default_configurations_options_table_2005 values('Agent XPs',0)
insert into @Default_configurations_options_table_2005 values('allow updates',0)
insert into @Default_configurations_options_table_2005 values('awe enabled',0)
insert into @Default_configurations_options_table_2005 values('blocked process threshold',0)
insert into @Default_configurations_options_table_2005 values('c2 audit mode',0)
insert into @Default_configurations_options_table_2005 values('clr enabled',0)
insert into @Default_configurations_options_table_2005 values('cost threshold for parallelism',5)
insert into @Default_configurations_options_table_2005 values('cross db ownership chaining',0)
insert into @Default_configurations_options_table_2005 values('cursor threshold',-1)
insert into @Default_configurations_options_table_2005 values('Database Mail XPs',0)
insert into @Default_configurations_options_table_2005 values('default full-text language',1033)
insert into @Default_configurations_options_table_2005 values('default language',0)
insert into @Default_configurations_options_table_2005 values('default trace enabled',1)
insert into @Default_configurations_options_table_2005 values('disallow results from triggers',0)
insert into @Default_configurations_options_table_2005 values('fill factor (%)',0)
insert into @Default_configurations_options_table_2005 values('ft crawl bandwidth (max)',100)
insert into @Default_configurations_options_table_2005 values('ft crawl bandwidth (min)',0)
insert into @Default_configurations_options_table_2005 values('ft notify bandwidth (max)',100)
insert into @Default_configurations_options_table_2005 values('ft notify bandwidth (min)',0)
insert into @Default_configurations_options_table_2005 values('index create memory (KB)',0)
insert into @Default_configurations_options_table_2005 values('in-doubt xact resolution',0)
insert into @Default_configurations_options_table_2005 values('lightweight pooling',0)
insert into @Default_configurations_options_table_2005 values('locks',0)
insert into @Default_configurations_options_table_2005 values('max degree of parallelism',0)
insert into @Default_configurations_options_table_2005 values('max full-text crawl range',4)
insert into @Default_configurations_options_table_2005 values('max server memory (MB)',2147483647)
insert into @Default_configurations_options_table_2005 values('max text repl size (B)',65536)
insert into @Default_configurations_options_table_2005 values('max worker threads',0)
insert into @Default_configurations_options_table_2005 values('media retention',0)
insert into @Default_configurations_options_table_2005 values('min memory per query (KB)',1024)
insert into @Default_configurations_options_table_2005 values('min server memory (MB)',0)
insert into @Default_configurations_options_table_2005 values('nested triggers',1)
insert into @Default_configurations_options_table_2005 values('network packet size (B)',4096)
insert into @Default_configurations_options_table_2005 values('Ole Automation Procedures',0)
insert into @Default_configurations_options_table_2005 values('open objects',0)
insert into @Default_configurations_options_table_2005 values('PH timeout (s)',60)
insert into @Default_configurations_options_table_2005 values('precompute rank',0)
insert into @Default_configurations_options_table_2005 values('priority boost',0)
insert into @Default_configurations_options_table_2005 values('query governor cost limit',0)
insert into @Default_configurations_options_table_2005 values('query wait (s)',-1)
insert into @Default_configurations_options_table_2005 values('recovery interval (min)',0)
insert into @Default_configurations_options_table_2005 values('remote access',1)
insert into @Default_configurations_options_table_2005 values('remote admin connections',0)
insert into @Default_configurations_options_table_2005 values('remote login timeout (s)',20)
insert into @Default_configurations_options_table_2005 values('remote proc trans',0)
insert into @Default_configurations_options_table_2005 values('remote query timeout (s)',600)
insert into @Default_configurations_options_table_2005 values('Replication XPs',0)
insert into @Default_configurations_options_table_2005 values('RPC parameter data validation',0)
insert into @Default_configurations_options_table_2005 values('scan for startup procs',0)
insert into @Default_configurations_options_table_2005 values('server trigger recursion',1)
insert into @Default_configurations_options_table_2005 values('set working set size',0)
insert into @Default_configurations_options_table_2005 values('show advanced options',0)
insert into @Default_configurations_options_table_2005 values('SMO and DMO XPs',1)
insert into @Default_configurations_options_table_2005 values('SQL Mail XPs',0)
insert into @Default_configurations_options_table_2005 values('transform noise words',0)
insert into @Default_configurations_options_table_2005 values('two digit year cutoff',2049)
insert into @Default_configurations_options_table_2005 values('user connections',0)
insert into @Default_configurations_options_table_2005 values('user options',0)
insert into @Default_configurations_options_table_2005 values('Web Assistant Procedures',0)
insert into @Default_configurations_options_table_2005 values('xp_cmdshell',0)


PRINT 'In Use Value Differs from Default'

INSERT INTO ##configurations
SELECT Live.name, 
       CAST(Live.value_in_use AS VARCHAR(15)) AS Live_In_Use, 
	   CAST(Defaults.Default_Value AS VARCHAR(15)) AS Default_Value 
FROM sys.configurations Live
  INNER JOIN @Default_configurations_options_table_2005 Defaults
   ON Live.name = Defaults.name 
  AND Live.value_in_use <> Defaults.Default_Value



INSERT INTO dbo.##ReviewResults
SELECT Name, Live_in_Use, Default_value, '','','','','','','','','','','','','' ,'', '','','','','','','','','','','','' FROM ##configurations


set @Configuration = (

SELECT count(Live.name) 
      
FROM sys.configurations Live
  INNER JOIN @Default_configurations_options_table_2005 Defaults
   ON Live.name = Defaults.name 
  AND Live.value_in_use <> Defaults.Default_Value)

if @Configuration >= 0
	
	set @Configuration = 1
else
	set @Configuration = 0

END




IF @Version_New LIKE '10.0%'
BEGIN

Print 'SQL Server 2008 Check'
PRINT ''

-- SQL Server 2008 Defaults
DECLARE @Default_configurations_options_table2008 TABLE
(name varchar(500), Default_Value BIGINT)


insert into @Default_configurations_options_table2008 values ('access check cache bucket count',0)
insert into @Default_configurations_options_table2008 values ('access check cache quota',0)
insert into @Default_configurations_options_table2008 values ('Ad Hoc Distributed Queries',0)
insert into @Default_configurations_options_table2008 values ('affinity I/O mask',0)
insert into @Default_configurations_options_table2008 values ('affinity mask',0)
insert into @Default_configurations_options_table2008 values ('affinity64 I/O mask',0)
insert into @Default_configurations_options_table2008 values ('affinity64 mask',0)
insert into @Default_configurations_options_table2008 values ('Agent XPs',1)
insert into @Default_configurations_options_table2008 values ('allow updates',0)
insert into @Default_configurations_options_table2008 values ('awe enabled',0)
insert into @Default_configurations_options_table2008 values ('backup compression default',0)
insert into @Default_configurations_options_table2008 values ('blocked process threshold (s)',0)
insert into @Default_configurations_options_table2008 values ('c2 audit mode',0)
insert into @Default_configurations_options_table2008 values ('clr enabled',0)
insert into @Default_configurations_options_table2008 values ('common criteria compliance enabled',0)
insert into @Default_configurations_options_table2008 values ('cost threshold for parallelism',5)
insert into @Default_configurations_options_table2008 values ('cross db ownership chaining',0)
insert into @Default_configurations_options_table2008 values ('cursor threshold',-1)
insert into @Default_configurations_options_table2008 values ('Database Mail XPs',0)
insert into @Default_configurations_options_table2008 values ('default full-text language',1033)
insert into @Default_configurations_options_table2008 values ('default language',0)
insert into @Default_configurations_options_table2008 values ('default trace enabled',1)
insert into @Default_configurations_options_table2008 values ('disallow results from triggers',0)
insert into @Default_configurations_options_table2008 values ('EKM provider enabled',0)
insert into @Default_configurations_options_table2008 values ('filestream access level',0)
insert into @Default_configurations_options_table2008 values ('fill factor (%)',0)
insert into @Default_configurations_options_table2008 values ('ft crawl bandwidth (max)',100)
insert into @Default_configurations_options_table2008 values ('ft crawl bandwidth (min)',0)
insert into @Default_configurations_options_table2008 values ('ft notify bandwidth (max)',100)
insert into @Default_configurations_options_table2008 values ('ft notify bandwidth (min)',0)
insert into @Default_configurations_options_table2008 values ('index create memory (KB)',0)
insert into @Default_configurations_options_table2008 values ('in-doubt xact resolution',0)
insert into @Default_configurations_options_table2008 values ('lightweight pooling',0)
insert into @Default_configurations_options_table2008 values ('locks',0)
insert into @Default_configurations_options_table2008 values ('max degree of parallelism',0)
insert into @Default_configurations_options_table2008 values ('max full-text crawl range',4)
insert into @Default_configurations_options_table2008 values ('max server memory (MB)',2147483647)
insert into @Default_configurations_options_table2008 values ('max text repl size (B)',65536)
insert into @Default_configurations_options_table2008 values ('max worker threads',0)
insert into @Default_configurations_options_table2008 values ('media retention',0)
insert into @Default_configurations_options_table2008 values ('min memory per query (KB)',1024)
insert into @Default_configurations_options_table2008 values ('min server memory (MB)',0)
insert into @Default_configurations_options_table2008 values ('nested triggers',1)
insert into @Default_configurations_options_table2008 values ('network packet size (B)',4096)
insert into @Default_configurations_options_table2008 values ('Ole Automation Procedures',0)
insert into @Default_configurations_options_table2008 values ('open objects',0)
insert into @Default_configurations_options_table2008 values ('optimize for ad hoc workloads',0)
insert into @Default_configurations_options_table2008 values ('PH timeout (s)',60)
insert into @Default_configurations_options_table2008 values ('precompute rank',0)
insert into @Default_configurations_options_table2008 values ('priority boost',0)
insert into @Default_configurations_options_table2008 values ('query governor cost limit',0)
insert into @Default_configurations_options_table2008 values ('query wait (s)',-1)
insert into @Default_configurations_options_table2008 values ('recovery interval (min)',0)
insert into @Default_configurations_options_table2008 values ('remote access',1)
insert into @Default_configurations_options_table2008 values ('remote admin connections',0)
insert into @Default_configurations_options_table2008 values ('remote login timeout (s)',20)
insert into @Default_configurations_options_table2008 values ('remote proc trans',0)
insert into @Default_configurations_options_table2008 values ('remote query timeout (s)',600)
insert into @Default_configurations_options_table2008 values ('Replication XPs',0)
insert into @Default_configurations_options_table2008 values ('scan for startup procs',0)
insert into @Default_configurations_options_table2008 values ('server trigger recursion',1)
insert into @Default_configurations_options_table2008 values ('set working set size',0)
insert into @Default_configurations_options_table2008 values ('show advanced options',0)
insert into @Default_configurations_options_table2008 values ('SMO and DMO XPs',1)
insert into @Default_configurations_options_table2008 values ('SQL Mail XPs',0)
insert into @Default_configurations_options_table2008 values ('transform noise words',0)
insert into @Default_configurations_options_table2008 values ('two digit year cutoff',2049)
insert into @Default_configurations_options_table2008 values ('user connections',0)
insert into @Default_configurations_options_table2008 values ('user options',0)
insert into @Default_configurations_options_table2008 values ('xp_cmdshell',0)



-- Report Findings



-- Value In Use differs from SQL Server Deafults
-- Not always bad and with certain options this can be expected/desired
PRINT 'In Use Value Differs from Default'

INSERT INTO ##configurations
SELECT Live.name, 
       CAST(Live.value_in_use AS VARCHAR(15)) AS Live_In_Use, 
	   CAST(Defaults.Default_Value AS VARCHAR(15)) AS Default_Value 
FROM sys.configurations Live
  INNER JOIN @Default_configurations_options_table2008 Defaults
   ON Live.name = Defaults.name 
  AND Live.value_in_use <> Defaults.Default_Value

INSERT INTO dbo.##ReviewResults
SELECT Name, Live_in_Use, Default_value, '','','','','','','','','','','','','' ,'', '','','','','','','','','','','','' FROM ##configurations

---- condition for summary ------

set @Configuration = (

SELECT count(Live.name)       
FROM sys.configurations Live
  INNER JOIN @Default_configurations_options_table2008 Defaults
   ON Live.name = Defaults.name 
  AND Live.value_in_use <> Defaults.Default_Value)

if @Configuration >= 0
	
	set @Configuration = 1
else
	set @Configuration = 0

END




IF @Version_New LIKE '10.50%'
BEGIN

Print 'SQL Server 2008 R2 Check'
PRINT ''

-- SQL Server 2008R2 Defaults
DECLARE @Default_configurations_options_table TABLE
(name varchar(500), Default_Value BIGINT)


insert into @Default_configurations_options_table values ('access check cache bucket count',0)
insert into @Default_configurations_options_table values ('access check cache quota',0)
insert into @Default_configurations_options_table values ('Ad Hoc Distributed Queries',0)
insert into @Default_configurations_options_table values ('affinity I/O mask',0)
insert into @Default_configurations_options_table values ('affinity mask',0)
insert into @Default_configurations_options_table values ('affinity64 I/O mask',0)
insert into @Default_configurations_options_table values ('affinity64 mask',0)
insert into @Default_configurations_options_table values ('Agent XPs',1)
insert into @Default_configurations_options_table values ('allow updates',0)
insert into @Default_configurations_options_table values ('awe enabled',0)
insert into @Default_configurations_options_table values ('backup compression default',0)
insert into @Default_configurations_options_table values ('blocked process threshold (s)',0)
insert into @Default_configurations_options_table values ('c2 audit mode',0)
insert into @Default_configurations_options_table values ('clr enabled',0)
insert into @Default_configurations_options_table values ('common criteria compliance enabled',0)
insert into @Default_configurations_options_table values ('cost threshold for parallelism',5)
insert into @Default_configurations_options_table values ('cross db ownership chaining',0)
insert into @Default_configurations_options_table values ('cursor threshold',-1)
insert into @Default_configurations_options_table values ('Database Mail XPs',0)
insert into @Default_configurations_options_table values ('default full-text language',1033)
insert into @Default_configurations_options_table values ('default language',0)
insert into @Default_configurations_options_table values ('default trace enabled',1)
insert into @Default_configurations_options_table values ('disallow results from triggers',0)
insert into @Default_configurations_options_table values ('EKM provider enabled',0)
insert into @Default_configurations_options_table values ('filestream access level',0)
insert into @Default_configurations_options_table values ('fill factor (%)',0)
insert into @Default_configurations_options_table values ('ft crawl bandwidth (max)',100)
insert into @Default_configurations_options_table values ('ft crawl bandwidth (min)',0)
insert into @Default_configurations_options_table values ('ft notify bandwidth (max)',100)
insert into @Default_configurations_options_table values ('ft notify bandwidth (min)',0)
insert into @Default_configurations_options_table values ('index create memory (KB)',0)
insert into @Default_configurations_options_table values ('in-doubt xact resolution',0)
insert into @Default_configurations_options_table values ('lightweight pooling',0)
insert into @Default_configurations_options_table values ('locks',0)
insert into @Default_configurations_options_table values ('max degree of parallelism',0)
insert into @Default_configurations_options_table values ('max full-text crawl range',4)
insert into @Default_configurations_options_table values ('max server memory (MB)',2147483647)
insert into @Default_configurations_options_table values ('max text repl size (B)',65536)
insert into @Default_configurations_options_table values ('max worker threads',0)
insert into @Default_configurations_options_table values ('media retention',0)
insert into @Default_configurations_options_table values ('min memory per query (KB)',1024)
insert into @Default_configurations_options_table values ('min server memory (MB)',0)
insert into @Default_configurations_options_table values ('nested triggers',1)
insert into @Default_configurations_options_table values ('network packet size (B)',4096)
insert into @Default_configurations_options_table values ('Ole Automation Procedures',0)
insert into @Default_configurations_options_table values ('open objects',0)
insert into @Default_configurations_options_table values ('optimize for ad hoc workloads',0)
insert into @Default_configurations_options_table values ('PH timeout (s)',60)
insert into @Default_configurations_options_table values ('precompute rank',0)
insert into @Default_configurations_options_table values ('priority boost',0)
insert into @Default_configurations_options_table values ('query governor cost limit',0)
insert into @Default_configurations_options_table values ('query wait (s)',-1)
insert into @Default_configurations_options_table values ('recovery interval (min)',0)
insert into @Default_configurations_options_table values ('remote access',1)
insert into @Default_configurations_options_table values ('remote admin connections',0)
insert into @Default_configurations_options_table values ('remote login timeout (s)',20)
insert into @Default_configurations_options_table values ('remote proc trans',0)
insert into @Default_configurations_options_table values ('remote query timeout (s)',600)
insert into @Default_configurations_options_table values ('Replication XPs',0)
insert into @Default_configurations_options_table values ('scan for startup procs',0)
insert into @Default_configurations_options_table values ('server trigger recursion',1)
insert into @Default_configurations_options_table values ('set working set size',0)
insert into @Default_configurations_options_table values ('show advanced options',0)
insert into @Default_configurations_options_table values ('SMO and DMO XPs',1)
insert into @Default_configurations_options_table values ('SQL Mail XPs',0)
insert into @Default_configurations_options_table values ('transform noise words',0)
insert into @Default_configurations_options_table values ('two digit year cutoff',2049)
insert into @Default_configurations_options_table values ('user connections',0)
insert into @Default_configurations_options_table values ('user options',0)
insert into @Default_configurations_options_table values ('xp_cmdshell',0)


-- Report Findings


-- Value In Use differs from SQL Server Deafults
-- Not always bad and with certain options this can be expected/desired
PRINT 'In Use Value Differs from Default'

INSERT INTO ##configurations
SELECT Live.name, 
       CAST(Live.value_in_use AS VARCHAR(15)) AS Live_In_Use, 
	   CAST(Defaults.Default_Value AS VARCHAR(15)) AS Default_Value 
FROM sys.configurations Live
  INNER JOIN @Default_configurations_options_table Defaults
   ON Live.name = Defaults.name 
  AND Live.value_in_use <> Defaults.Default_Value


INSERT INTO dbo.##ReviewResults
SELECT Name, Live_in_Use, Default_value, '','','','','','','','','','','','','' ,'', '','','','','','','','','','','','' FROM ##configurations


set @Configuration = (

SELECT count(Live.name) 
      
FROM sys.configurations Live
  INNER JOIN @Default_configurations_options_table Defaults
   ON Live.name = Defaults.name 
  AND Live.value_in_use <> Defaults.Default_Value)

if @Configuration >= 0
	
	set @Configuration = 1
else
	set @Configuration = 0


END


IF @Version_New LIKE '11%'
BEGIN
PRINT 'SQL Server 2012 Check'
PRINT ''

-- SQL Server 2008R2 Defaults
DECLARE @Default_configurations_options_table2012 TABLE
(name varchar(500), Default_Value BIGINT)


insert into @Default_configurations_options_table2012 values ('access check cache bucket count',0)
insert into @Default_configurations_options_table2012 values ('access check cache quota',0)
insert into @Default_configurations_options_table2012 values ('Ad Hoc Distributed Queries',0)
insert into @Default_configurations_options_table2012 values ('affinity I/O mask',0)
insert into @Default_configurations_options_table2012 values ('affinity mask',0)
insert into @Default_configurations_options_table2012 values ('affinity64 I/O mask',0)
insert into @Default_configurations_options_table2012 values ('affinity64 mask',0)
insert into @Default_configurations_options_table2012 values ('Agent XPs',1)	
insert into @Default_configurations_options_table2012 values ('allow updates',0)
insert into @Default_configurations_options_table2012 values ('backup compression default',0)
insert into @Default_configurations_options_table2012 values ('blocked process threshold (s)',0)
insert into @Default_configurations_options_table2012 values ('c2 audit mode',0)
insert into @Default_configurations_options_table2012 values ('clr enabled',0)
insert into @Default_configurations_options_table2012 values ('common criteria compliance enabled',0)
insert into @Default_configurations_options_table2012 values ('contained database authentication',0)
insert into @Default_configurations_options_table2012 values ('cost threshold for parallelism',5)
insert into @Default_configurations_options_table2012 values ('cross db ownership chaining',0)
insert into @Default_configurations_options_table2012 values ('cursor threshold',-1)
insert into @Default_configurations_options_table2012 values ('Database Mail XPs',0)
insert into @Default_configurations_options_table2012 values ('default full-text language',1033)
insert into @Default_configurations_options_table2012 values ('default language',0)
insert into @Default_configurations_options_table2012 values ('default trace enabled',1)
insert into @Default_configurations_options_table2012 values ('disallow results from triggers',0)
insert into @Default_configurations_options_table2012 values ('EKM provider enabled',0)
insert into @Default_configurations_options_table2012 values ('filestream access level',0)
insert into @Default_configurations_options_table2012 values ('fill factor (%)',0)
insert into @Default_configurations_options_table2012 values ('ft crawl bandwidth (max)',100)
insert into @Default_configurations_options_table2012 values ('ft crawl bandwidth (min)',0)
insert into @Default_configurations_options_table2012 values ('ft notify bandwidth (max)',100)
insert into @Default_configurations_options_table2012 values ('ft notify bandwidth (min)',0)
insert into @Default_configurations_options_table2012 values ('index create memory (KB)',0)
insert into @Default_configurations_options_table2012 values ('in-doubt xact resolution',0)
insert into @Default_configurations_options_table2012 values ('lightweight pooling',0)
insert into @Default_configurations_options_table2012 values ('locks',0)
insert into @Default_configurations_options_table2012 values ('max degree of parallelism',0)
insert into @Default_configurations_options_table2012 values ('max full-text crawl range',4)
insert into @Default_configurations_options_table2012 values ('max server memory (MB)',2147483647)
insert into @Default_configurations_options_table2012 values ('max text repl size (B)',65536)
insert into @Default_configurations_options_table2012 values ('max worker threads',0)
insert into @Default_configurations_options_table2012 values ('media retention',0)
insert into @Default_configurations_options_table2012 values ('min memory per query (KB)',1024)
insert into @Default_configurations_options_table2012 values ('min server memory (MB)',0)
insert into @Default_configurations_options_table2012 values ('nested triggers',1)
insert into @Default_configurations_options_table2012 values ('network packet size (B)',4096)
insert into @Default_configurations_options_table2012 values ('Ole Automation Procedures',0)
insert into @Default_configurations_options_table2012 values ('open objects',0)
insert into @Default_configurations_options_table2012 values ('optimize for ad hoc workloads',0)
insert into @Default_configurations_options_table2012 values ('PH timeout (s)',60)
insert into @Default_configurations_options_table2012 values ('precompute rank',0)
insert into @Default_configurations_options_table2012 values ('priority boost',0)
insert into @Default_configurations_options_table2012 values ('query governor cost limit',0)
insert into @Default_configurations_options_table2012 values ('query wait (s)',-1)
insert into @Default_configurations_options_table2012 values ('recovery interval (min)',0)
insert into @Default_configurations_options_table2012 values ('remote access',1)
insert into @Default_configurations_options_table2012 values ('remote admin connections',0)
insert into @Default_configurations_options_table2012 values ('remote login timeout (s)',10)
insert into @Default_configurations_options_table2012 values ('remote proc trans',0)
insert into @Default_configurations_options_table2012 values ('remote query timeout (s)',600)
insert into @Default_configurations_options_table2012 values ('Replication XPs',0)
insert into @Default_configurations_options_table2012 values ('scan for startup procs',0)
insert into @Default_configurations_options_table2012 values ('server trigger recursion',1)
insert into @Default_configurations_options_table2012 values ('set working set size',0)
insert into @Default_configurations_options_table2012 values ('show advanced options',0)
insert into @Default_configurations_options_table2012 values ('SMO and DMO XPs',1)
insert into @Default_configurations_options_table2012 values ('transform noise words',0)
insert into @Default_configurations_options_table2012 values ('two digit year cutoff',2049)
insert into @Default_configurations_options_table2012 values ('user connections',0)
insert into @Default_configurations_options_table2012 values ('user options',0)
insert into @Default_configurations_options_table2012 values ('xp_cmdshell',0)


-- Report Findings


PRINT 'In Use Value Differs from Default'
INSERT INTO ##configurations
SELECT Live.name, 
       CAST(Live.value_in_use AS VARCHAR(15)) AS Live_In_Use, 
	   CAST(Defaults.Default_Value AS VARCHAR(15)) AS Default_Value 
FROM sys.configurations Live
  INNER JOIN @Default_configurations_options_table2012 Defaults
   ON Live.name = Defaults.name 
  AND Live.value_in_use <> Defaults.Default_Value

INSERT INTO dbo.##ReviewResults
SELECT Name, Live_in_Use, Default_value, '','','','','','','','','','','','','' ,'', '','','','','','','','','','','','' FROM ##configurations


set @Configuration = (

SELECT count(Live.name)
        
FROM sys.configurations Live
  INNER JOIN @Default_configurations_options_table2012 Defaults
   ON Live.name = Defaults.name 
  AND Live.value_in_use <> Defaults.Default_Value)

if @Configuration >= 0
	
	set @Configuration = 1
else
	set @Configuration = 0

END

----- SQL 2014



IF @Version_New LIKE '12%'
BEGIN
PRINT 'SQL Server 2014 Check'
PRINT ''

-- SQL Server 2008R2 Defaults
DECLARE @Default_configurations_options_table2014 TABLE
(name varchar(500), Default_Value BIGINT)


insert into @Default_configurations_options_table2014 values ('access check cache bucket count',0)
insert into @Default_configurations_options_table2014 values ('access check cache quota',0)
insert into @Default_configurations_options_table2014 values ('Ad Hoc Distributed Queries',0)
insert into @Default_configurations_options_table2014 values ('affinity I/O mask',0)
insert into @Default_configurations_options_table2014 values ('affinity mask',0)
insert into @Default_configurations_options_table2014 values ('affinity64 I/O mask',0)
insert into @Default_configurations_options_table2014 values ('affinity64 mask',0)
insert into @Default_configurations_options_table2014 values ('Agent XPs',1)	
insert into @Default_configurations_options_table2014 values ('allow updates',0)
insert into @Default_configurations_options_table2014 values ('backup compression default',0)
insert into @Default_configurations_options_table2014 values ('blocked process threshold (s)',0)
insert into @Default_configurations_options_table2014 values ('c2 audit mode',0)
insert into @Default_configurations_options_table2014 values ('clr enabled',0)
insert into @Default_configurations_options_table2014 values ('common criteria compliance enabled',0)
insert into @Default_configurations_options_table2014 values ('contained database authentication',0)
insert into @Default_configurations_options_table2014 values ('cost threshold for parallelism',5)
insert into @Default_configurations_options_table2014 values ('cross db ownership chaining',0)
insert into @Default_configurations_options_table2014 values ('cursor threshold',-1)
insert into @Default_configurations_options_table2014 values ('Database Mail XPs',0)
insert into @Default_configurations_options_table2014 values ('default full-text language',1033)
insert into @Default_configurations_options_table2014 values ('default language',0)
insert into @Default_configurations_options_table2014 values ('default trace enabled',1)
insert into @Default_configurations_options_table2014 values ('disallow results from triggers',0)
insert into @Default_configurations_options_table2014 values ('EKM provider enabled',0)
insert into @Default_configurations_options_table2014 values ('filestream access level',0)
insert into @Default_configurations_options_table2014 values ('fill factor (%)',0)
insert into @Default_configurations_options_table2014 values ('ft crawl bandwidth (max)',100)
insert into @Default_configurations_options_table2014 values ('ft crawl bandwidth (min)',0)
insert into @Default_configurations_options_table2014 values ('ft notify bandwidth (max)',100)
insert into @Default_configurations_options_table2014 values ('ft notify bandwidth (min)',0)
insert into @Default_configurations_options_table2014 values ('index create memory (KB)',0)
insert into @Default_configurations_options_table2014 values ('in-doubt xact resolution',0)
insert into @Default_configurations_options_table2014 values ('lightweight pooling',0)
insert into @Default_configurations_options_table2014 values ('locks',0)
insert into @Default_configurations_options_table2014 values ('max degree of parallelism',0)
insert into @Default_configurations_options_table2014 values ('max full-text crawl range',4)
insert into @Default_configurations_options_table2014 values ('max server memory (MB)',2147483647)
insert into @Default_configurations_options_table2014 values ('max text repl size (B)',65536)
insert into @Default_configurations_options_table2014 values ('max worker threads',0)
insert into @Default_configurations_options_table2014 values ('media retention',0)
insert into @Default_configurations_options_table2014 values ('min memory per query (KB)',1024)
insert into @Default_configurations_options_table2014 values ('min server memory (MB)',0)
insert into @Default_configurations_options_table2014 values ('nested triggers',1)
insert into @Default_configurations_options_table2014 values ('network packet size (B)',4096)
insert into @Default_configurations_options_table2014 values ('Ole Automation Procedures',0)
insert into @Default_configurations_options_table2014 values ('open objects',0)
insert into @Default_configurations_options_table2014 values ('optimize for ad hoc workloads',0)
insert into @Default_configurations_options_table2014 values ('PH timeout (s)',60)
insert into @Default_configurations_options_table2014 values ('precompute rank',0)
insert into @Default_configurations_options_table2014 values ('priority boost',0)
insert into @Default_configurations_options_table2014 values ('query governor cost limit',0)
insert into @Default_configurations_options_table2014 values ('query wait (s)',-1)
insert into @Default_configurations_options_table2014 values ('recovery interval (min)',0)
insert into @Default_configurations_options_table2014 values ('remote access',1)
insert into @Default_configurations_options_table2014 values ('remote admin connections',0)
insert into @Default_configurations_options_table2014 values ('remote login timeout (s)',10)
insert into @Default_configurations_options_table2014 values ('remote proc trans',0)
insert into @Default_configurations_options_table2014 values ('remote query timeout (s)',600)
insert into @Default_configurations_options_table2014 values ('Replication XPs',0)
insert into @Default_configurations_options_table2014 values ('scan for startup procs',0)
insert into @Default_configurations_options_table2014 values ('server trigger recursion',1)
insert into @Default_configurations_options_table2014 values ('set working set size',0)
insert into @Default_configurations_options_table2014 values ('show advanced options',0)
insert into @Default_configurations_options_table2014 values ('SMO and DMO XPs',1)
insert into @Default_configurations_options_table2014 values ('transform noise words',0)
insert into @Default_configurations_options_table2014 values ('two digit year cutoff',2049)
insert into @Default_configurations_options_table2014 values ('user connections',0)
insert into @Default_configurations_options_table2014 values ('user options',0)
insert into @Default_configurations_options_table2014 values ('xp_cmdshell',0)


-- Report Findings


PRINT 'In Use Value Differs from Default'
INSERT INTO ##configurations
SELECT Live.name, 
       CAST(Live.value_in_use AS VARCHAR(15)) AS Live_In_Use, 
	   CAST(Defaults.Default_Value AS VARCHAR(15)) AS Default_Value 
FROM sys.configurations Live
  INNER JOIN @Default_configurations_options_table2014 Defaults
   ON Live.name = Defaults.name 
  AND Live.value_in_use <> Defaults.Default_Value

INSERT INTO dbo.##ReviewResults
SELECT Name, Live_in_Use, Default_value, '','','','','','','','','','','','','' ,'', '','','','','','','','','','','','' FROM ##configurations

set @Configuration = (

SELECT count(Live.name)
        
FROM sys.configurations Live
  INNER JOIN @Default_configurations_options_table2014 Defaults
   ON Live.name = Defaults.name 
  AND Live.value_in_use <> Defaults.Default_Value)

if @Configuration >= 0
	
	set @Configuration = 1
else
	set @Configuration = 0

END

----- SQL 2016

IF @Version_New LIKE '13%'
BEGIN
PRINT 'SQL Server 2016 Check'
PRINT ''

-- SQL Server 2008R2 Defaults
DECLARE @Default_configurations_options_table2016 TABLE
(name varchar(500), Default_Value BIGINT)


insert into @Default_configurations_options_table2016 values ('access check cache bucket count',0)
insert into @Default_configurations_options_table2016 values ('access check cache quota',0)
insert into @Default_configurations_options_table2016 values ('Ad Hoc Distributed Queries',0)
insert into @Default_configurations_options_table2016 values ('affinity I/O mask',0)
insert into @Default_configurations_options_table2016 values ('affinity mask',0)
insert into @Default_configurations_options_table2016 values ('affinity64 I/O mask',0)
insert into @Default_configurations_options_table2016 values ('affinity64 mask',0)
insert into @Default_configurations_options_table2016 values ('Agent XPs',1)	
insert into @Default_configurations_options_table2016 values ('allow updates',0)
insert into @Default_configurations_options_table2016 values ('backup compression default',0)
insert into @Default_configurations_options_table2016 values ('blocked process threshold (s)',0)
insert into @Default_configurations_options_table2016 values ('c2 audit mode',0)
insert into @Default_configurations_options_table2016 values ('clr enabled',0)
insert into @Default_configurations_options_table2016 values ('common criteria compliance enabled',0)
insert into @Default_configurations_options_table2016 values ('contained database authentication',0)
insert into @Default_configurations_options_table2016 values ('cost threshold for parallelism',5)
insert into @Default_configurations_options_table2016 values ('cross db ownership chaining',0)
insert into @Default_configurations_options_table2016 values ('cursor threshold',-1)
insert into @Default_configurations_options_table2016 values ('Database Mail XPs',0)
insert into @Default_configurations_options_table2016 values ('default full-text language',1033)
insert into @Default_configurations_options_table2016 values ('default language',0)
insert into @Default_configurations_options_table2016 values ('default trace enabled',1)
insert into @Default_configurations_options_table2016 values ('disallow results from triggers',0)
insert into @Default_configurations_options_table2016 values ('EKM provider enabled',0)
insert into @Default_configurations_options_table2016 values ('filestream access level',0)
insert into @Default_configurations_options_table2016 values ('fill factor (%)',0)
insert into @Default_configurations_options_table2016 values ('ft crawl bandwidth (max)',100)
insert into @Default_configurations_options_table2016 values ('ft crawl bandwidth (min)',0)
insert into @Default_configurations_options_table2016 values ('ft notify bandwidth (max)',100)
insert into @Default_configurations_options_table2016 values ('ft notify bandwidth (min)',0)
insert into @Default_configurations_options_table2016 values ('index create memory (KB)',0)
insert into @Default_configurations_options_table2016 values ('in-doubt xact resolution',0)
insert into @Default_configurations_options_table2016 values ('lightweight pooling',0)
insert into @Default_configurations_options_table2016 values ('locks',0)
insert into @Default_configurations_options_table2016 values ('max degree of parallelism',0)
insert into @Default_configurations_options_table2016 values ('max full-text crawl range',4)
insert into @Default_configurations_options_table2016 values ('max server memory (MB)',2147483647)
insert into @Default_configurations_options_table2016 values ('max text repl size (B)',65536)
insert into @Default_configurations_options_table2016 values ('max worker threads',0)
insert into @Default_configurations_options_table2016 values ('media retention',0)
insert into @Default_configurations_options_table2016 values ('min memory per query (KB)',1024)
insert into @Default_configurations_options_table2016 values ('min server memory (MB)',0)
insert into @Default_configurations_options_table2016 values ('nested triggers',1)
insert into @Default_configurations_options_table2016 values ('network packet size (B)',4096)
insert into @Default_configurations_options_table2016 values ('Ole Automation Procedures',0)
insert into @Default_configurations_options_table2016 values ('open objects',0)
insert into @Default_configurations_options_table2016 values ('optimize for ad hoc workloads',0)
insert into @Default_configurations_options_table2016 values ('PH timeout (s)',60)
insert into @Default_configurations_options_table2016 values ('precompute rank',0)
insert into @Default_configurations_options_table2016 values ('priority boost',0)
insert into @Default_configurations_options_table2016 values ('query governor cost limit',0)
insert into @Default_configurations_options_table2016 values ('query wait (s)',-1)
insert into @Default_configurations_options_table2016 values ('recovery interval (min)',0)
insert into @Default_configurations_options_table2016 values ('remote access',1)
insert into @Default_configurations_options_table2016 values ('remote admin connections',0)
insert into @Default_configurations_options_table2016 values ('remote login timeout (s)',10)
insert into @Default_configurations_options_table2016 values ('remote proc trans',0)
insert into @Default_configurations_options_table2016 values ('remote query timeout (s)',600)
insert into @Default_configurations_options_table2016 values ('Replication XPs',0)
insert into @Default_configurations_options_table2016 values ('scan for startup procs',0)
insert into @Default_configurations_options_table2016 values ('server trigger recursion',1)
insert into @Default_configurations_options_table2016 values ('set working set size',0)
insert into @Default_configurations_options_table2016 values ('show advanced options',0)
insert into @Default_configurations_options_table2016 values ('SMO and DMO XPs',1)
insert into @Default_configurations_options_table2016 values ('transform noise words',0)
insert into @Default_configurations_options_table2016 values ('two digit year cutoff',2049)
insert into @Default_configurations_options_table2016 values ('user connections',0)
insert into @Default_configurations_options_table2016 values ('user options',0)
insert into @Default_configurations_options_table2016 values ('xp_cmdshell',0)


-- Report Findings


PRINT 'In Use Value Differs from Default'
INSERT INTO ##configurations
SELECT Live.name, 
       CAST(Live.value_in_use AS VARCHAR(15)) AS Live_In_Use, 
	   CAST(Defaults.Default_Value AS VARCHAR(15)) AS Default_Value 
FROM sys.configurations Live
  INNER JOIN @Default_configurations_options_table2016 Defaults
   ON Live.name = Defaults.name 
  AND Live.value_in_use <> Defaults.Default_Value

INSERT INTO dbo.##ReviewResults
SELECT Name, Live_in_Use, Default_value, '','','','','','','','','','','','','' ,'', '','','','','','','','','','','','' FROM ##configurations

----- Condition for summary ------

set @Configuration = (

SELECT count(Live.name)
        
FROM sys.configurations Live
  INNER JOIN @Default_configurations_options_table2016 Defaults
   ON Live.name = Defaults.name 
  AND Live.value_in_use <> Defaults.Default_Value)

if @Configuration >= 0
	
	set @Configuration = 1
else
	set @Configuration = 0

END

-----------------------------------------------
------ Space Utilization ----
----------------------------------------------

-- Drive space check --


INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
INSERT INTO dbo.##ReviewResults SELECT 'DRIVE UTILIZATION CHECK', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';


IF OBJECT_ID('tempdb.dbo.##DrvLetter', 'U') IS NOT NULL
  DROP TABLE dbo.##DrvLetter;
  
 IF OBJECT_ID('tempdb.dbo.##DrvInfo', 'U') IS NOT NULL
  DROP TABLE dbo.##DrvInfo;

CREATE TABLE dbo.##DrvLetter (
    Drive VARCHAR(500),
    )
CREATE TABLE dbo.##DrvInfo (
    Drive VARCHAR(500) null,
    [MB free] DECIMAL(20,2),
    [MB TotalSize] DECIMAL(20,2),
    [Volume Name] VARCHAR(64),
	[% Free Space] DECIMAL(20,2)
    )

INSERT INTO ##DrvLetter
EXEC xp_cmdshell 'wmic volume where drivetype="3" get caption, freespace, capacity, label'

DELETE
FROM ##DrvLetter
WHERE Drive IS NULL OR len(Drive) < 4 OR Drive LIKE '%Capacity%'
	OR Drive LIKE  '%\\%\Volume%'


DECLARE @STRLine VARCHAR(8000)
DECLARE @Drive varchar(500)
DECLARE @TotalSize REAL
DECLARE @Freesize REAL
DECLARE @VolumeName VARCHAR(64)

WHILE EXISTS(SELECT 1 FROM ##DrvLetter)
BEGIN
SET ROWCOUNT 1
SELECT @STRLine = Drive FROM ##DrvLetter

SET @TotalSize= CAST(LEFT(@STRLine,CHARINDEX(' ',@STRLine)) AS REAL)/1024/1024
SET @STRLine = REPLACE(@STRLine, LEFT(@STRLine,CHARINDEX(' ',@STRLine)),'')
SET @Drive = LEFT(LTRIM(@STRLine),CHARINDEX(' ',LTRIM(@STRLine)))
SET @STRLine = RTRIM(LTRIM(REPLACE(LTRIM(@STRLine), LEFT(LTRIM(@STRLine),CHARINDEX(' ',LTRIM(@STRLine))),'')))
SET @Freesize = LEFT(LTRIM(@STRLine),CHARINDEX(' ',LTRIM(@STRLine)))
SET @STRLine = RTRIM(LTRIM(REPLACE(LTRIM(@STRLine), LEFT(LTRIM(@STRLine),CHARINDEX(' ',LTRIM(@STRLine))),'')))
SET @VolumeName = @STRLine

INSERT INTO ##DrvInfo
SELECT @Drive, @Freesize/1024/1024 , @TotalSize, @VolumeName , (((@Freesize/1024/1024)*100 )/@TotalSize)

DELETE FROM ##DrvLetter
END

SET ROWCOUNT 0

SET @SQL ='wmic /FailFast:ON logicaldisk where (drivetype ="3" and volumename!="RECOVERY" AND volumename!="System Reserved") get deviceid,volumename  /Format:csv'
if object_id('tempdb.dbo.##output1') is not null drop table ##output1
CREATE TABLE dbo.##output1 (Col1 VARCHAR(2048))
INSERT INTO dbo.##output1

EXEC master..xp_cmdshell @SQL
DELETE ##output1 where ltrim(Col1) is null or len(Col1) = 1 or Col1 like 'Node,DeviceID,VolumeName%'

if object_id('tempdb..##logicaldisk') is not null drop table ##logicaldisk
CREATE TABLE ##logicaldisk (DeviceID varchar(128),VolumeName varchar(256))

DECLARE @NodeName varchar(128)
SET @NodeName = (SELECT TOP 1 LEFT(Col1, CHARINDEX(',',Col1)) FROM ##output1)

UPDATE ##output1 SET Col1 = REPLACE(Col1, @NodeName, '')

INSERT INTO ##logicaldisk
SELECT LEFT(Col1, CHARINDEX(',',Col1)-2),  SUBSTRING(Col1, CHARINDEX(',',Col1)+1, LEN(Col1))
FROM ##output1

UPDATE dr
SET dr.[Volume Name] = ld.VolumeName
	FROM ##DrvInfo dr RIGHT OUTER JOIN ##logicaldisk ld ON left(dr.Drive,1) = ld.DeviceID
WHERE LEN([Volume Name]) = 1	
	
INSERT INTO dbo.##ReviewResults SELECT 'Drive', 'Volume Name','MB Total','MB Free','% Free space','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT CASE
		WHEN LEN(Drive) = 3 THEN LEFT(Drive,1)
		ELSE Drive
END AS drive,
[Volume Name], [MB TotalSize],
[MB free],  [% Free Space],'','','','','','','','','','','','', '','','','','','','','','','','',''
FROM dbo.##DrvInfo
ORDER BY 1


DECLARE @drvinfo_freepspacepercent DECIMAL(20,2)
SET @sum_drives = 0

DECLARE drivesummary_cursor CURSOR FOR
SELECT [% Free Space]
FROM dbo.##DrvInfo

OPEN drivesummary_cursor

FETCH NEXT FROM drivesummary_cursor
INTO @drvinfo_freepspacepercent

WHILE @@FETCH_STATUS = 0
BEGIN

IF @drvinfo_freepspacepercent <= 10 SET @sum_drives = 1

FETCH NEXT FROM drivesummary_cursor
	INTO @drvinfo_freepspacepercent
END

CLOSE drivesummary_cursor
DEALLOCATE drivesummary_cursor

----------------------------------------------------------------------------------
----- Database Space Utilization --------------------------
--------------------------------------------------------------------------------

INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
INSERT INTO dbo.##ReviewResults SELECT 'Database Space Utilization', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';


SET NOCOUNT ON;

DECLARE @TargetDatabase sysname, @Level varchar(10), @UpdateUsage bit, @Unit char(2)

SELECT @TargetDatabase = NULL, @Level  = 'database', @UpdateUsage = 0, @Unit = 'MB'; -- !! Just modify this line !!


IF OBJECT_ID('tempdb.dbo.##Tbl_CombinedInfo', 'U') IS NOT NULL
  DROP TABLE dbo.##Tbl_CombinedInfo;
  
IF OBJECT_ID('tempdb.dbo.##Tbl_DbFileStats', 'U') IS NOT NULL
  DROP TABLE dbo.##Tbl_DbFileStats;
  
IF OBJECT_ID('tempdb.dbo.##Tbl_ValidDbs', 'U') IS NOT NULL
  DROP TABLE dbo.##Tbl_ValidDbs;
  
IF OBJECT_ID('tempdb.dbo.##Tbl_Logs', 'U') IS NOT NULL
  DROP TABLE dbo.##Tbl_Logs;
  
CREATE TABLE dbo.##Tbl_CombinedInfo (
  DatabaseName sysname NULL, 
  [type] VARCHAR(10) NULL, 
  LogicalName sysname NULL,
  T dec(12, 2) NULL,
  U dec(12, 2) NULL,
  [U(%)] dec(5, 2) NULL,
  F dec(12, 2) NULL,
  [F(%)] dec(5, 2) NULL,
  PhysicalName sysname NULL );

CREATE TABLE dbo.##Tbl_DbFileStats (
  Id int identity, 
  DatabaseName sysname NULL, 
  FileId int NULL, 
  FileGroup int NULL, 
  TotalExtents bigint NULL, 
  UsedExtents bigint NULL, 
  Name sysname NULL, 
  FileName varchar(255) NULL );
  
CREATE TABLE dbo.##Tbl_ValidDbs (
  Id int identity, 
  Dbname sysname NULL );
  
CREATE TABLE dbo.##Tbl_Logs (
  DatabaseName sysname NULL, 
  LogSize dec(12, 2) NULL, 
  LogSpaceUsedPercent dec (5, 2) NULL,
  Status int NULL );

DECLARE @Ver varchar(15), 
        @DatabaseName sysname, 
        @Ident_last int, 
        @String varchar(2000),
        @BaseString varchar(2000);
        
SELECT @DatabaseName = '', 
       @Ident_last = 0, 
       @String = '', 
       @Ver = CASE WHEN @@VERSION LIKE '%9.0%' THEN 'SQL 2005' 
                   WHEN @@VERSION LIKE '%8.0%' THEN 'SQL 2000' 
                   WHEN @@VERSION LIKE '%10.0%' THEN 'SQL 2008' 
                   WHEN @@VERSION LIKE '%10.50%' THEN 'SQL 2008 R2'
		   WHEN @@VERSION LIKE '%11.0%' THEN 'SQL 2012'
		   WHEN @@VERSION LIKE '%12.0%' THEN 'SQL 2014'
		   WHEN @@VERSION LIKE '%13.0%' THEN 'SQL 2016'
              END;
              
SELECT @BaseString = 
' SELECT DB_NAME(), ' + 
CASE WHEN @Ver = 'SQL 2000' THEN 'CASE WHEN status & 0x40 = 0x40 THEN ''Log''  ELSE ''Data'' END' 
  ELSE ' CASE type WHEN 0 THEN ''Data'' WHEN 1 THEN ''Log'' WHEN 4 THEN ''Full-text'' ELSE ''reserved'' END' END + 
', name, ' + 
CASE WHEN @Ver = 'SQL 2000' THEN 'filename' ELSE 'physical_name' END + 
', size*8.0/1024.0 FROM ' + 
CASE WHEN @Ver = 'SQL 2000' THEN 'sysfiles' ELSE 'sys.database_files' END + 
' WHERE '
+ CASE WHEN @Ver = 'SQL 2000' THEN ' HAS_DBACCESS(DB_NAME()) = 1' ELSE 'state_desc = ''ONLINE''' END + '';

SELECT @String = 'INSERT INTO dbo.##Tbl_ValidDbs SELECT name FROM ' + 
                 CASE WHEN @Ver = 'SQL 2000' THEN 'master.dbo.sysdatabases' 
                      WHEN @Ver IN ('SQL 2005', 'SQL 2008', 'SQL 2008 R2','SQL 2012','SQL 2014','SQL 2016') THEN 'master.sys.databases' 
                 END + ' WHERE DATABASEPROPERTYEX (name,''Status'') = ''ONLINE''  ORDER BY name ASC';
EXEC (@String);

INSERT INTO dbo.##Tbl_Logs EXEC ('DBCC SQLPERF (LOGSPACE) WITH NO_INFOMSGS');

--  For data part
IF @TargetDatabase IS NOT NULL
  BEGIN
    SELECT @DatabaseName = @TargetDatabase;
    IF @UpdateUsage <> 0 AND DATABASEPROPERTYEX (@DatabaseName,'Status') = 'ONLINE' 
          AND DATABASEPROPERTYEX (@DatabaseName, 'Updateability') <> 'READ_ONLY'
      BEGIN
        SELECT @String = 'USE [' + @DatabaseName + '] DBCC UPDATEUSAGE (0)';
        PRINT '*** ' + @String + ' *** ';
        EXEC (@String);
        PRINT '';
      END
      
    SELECT @String = 'INSERT INTO dbo.##Tbl_CombinedInfo (DatabaseName, type, LogicalName, PhysicalName, T) ' + @BaseString; 

    INSERT INTO dbo.##Tbl_DbFileStats (FileId, FileGroup, TotalExtents, UsedExtents, Name, FileName)
          EXEC ('USE [' + @DatabaseName + '] DBCC SHOWFILESTATS WITH NO_INFOMSGS');
    EXEC ('USE [' + @DatabaseName + '] ' + @String);
        
    UPDATE dbo.##Tbl_DbFileStats SET DatabaseName = @DatabaseName; 
  END
ELSE
  BEGIN
    WHILE 1 = 1
      BEGIN
        SELECT TOP 1 @DatabaseName = Dbname FROM dbo.##Tbl_ValidDbs WHERE Dbname > @DatabaseName ORDER BY Dbname ASC;
        IF @@ROWCOUNT = 0
          BREAK;
        IF @UpdateUsage <> 0 AND DATABASEPROPERTYEX (@DatabaseName, 'Status') = 'ONLINE' 
              AND DATABASEPROPERTYEX (@DatabaseName, 'Updateability') <> 'READ_ONLY'
          BEGIN
            SELECT @String = 'DBCC UPDATEUSAGE (''' + @DatabaseName + ''') ';
            PRINT '*** ' + @String + '*** ';
            EXEC (@String);
            PRINT '';
          END
    
        SELECT @Ident_last = ISNULL(MAX(Id), 0) FROM dbo.##Tbl_DbFileStats;

        SELECT @String = 'INSERT INTO dbo.##Tbl_CombinedInfo (DatabaseName, type, LogicalName, PhysicalName, T) ' + @BaseString; 

        EXEC ('USE [' + @DatabaseName + '] ' + @String);
      
        INSERT INTO dbo.##Tbl_DbFileStats (FileId, FileGroup, TotalExtents, UsedExtents, Name, FileName)
          EXEC ('USE [' + @DatabaseName + '] DBCC SHOWFILESTATS WITH NO_INFOMSGS');

        UPDATE dbo.##Tbl_DbFileStats SET DatabaseName = @DatabaseName WHERE Id BETWEEN @Ident_last + 1 AND @@IDENTITY;
      END
  END

--  set used size for data files, do not change total obtained from sys.database_files as it has for log files
UPDATE dbo.##Tbl_CombinedInfo 
SET U = s.UsedExtents*8*8/1024.0 
FROM dbo.##Tbl_CombinedInfo t JOIN dbo.##Tbl_DbFileStats s 
ON t.LogicalName = s.Name AND s.DatabaseName = t.DatabaseName;

--  set used size and % values for log files:
UPDATE dbo.##Tbl_CombinedInfo 
SET [U(%)] = LogSpaceUsedPercent, 
    U = T * LogSpaceUsedPercent/100.0
FROM dbo.##Tbl_CombinedInfo t JOIN dbo.##Tbl_Logs l 
ON l.DatabaseName = t.DatabaseName 
WHERE t.type = 'Log';

UPDATE dbo.##Tbl_CombinedInfo SET F = T - U, [U(%)] = U*100.0/T;

UPDATE dbo.##Tbl_CombinedInfo SET [F(%)] = F*100.0/T;

IF UPPER(ISNULL(@Level, 'DATABASE')) = 'FILE'
  BEGIN
    IF @Unit = 'KB'
      UPDATE dbo.##Tbl_CombinedInfo
      SET T = T * 1024, U = U * 1024, F = F * 1024;
      
    IF @Unit = 'GB'
      UPDATE dbo.##Tbl_CombinedInfo
      SET T = T / 1024, U = U / 1024, F = F / 1024;
      
    SELECT DatabaseName AS 'Database',
      type AS 'Type',
      LogicalName,
      T AS 'Total',
      U AS 'Used',
      [U(%)] AS 'Used (%)',
      F AS 'Free',
      [F(%)] AS 'Free (%)',
      PhysicalName
      FROM dbo.##Tbl_CombinedInfo 
      WHERE DatabaseName LIKE ISNULL(@TargetDatabase, '%') 
      ORDER BY DatabaseName ASC, type ASC;

    SELECT CASE WHEN @Unit = 'GB' THEN 'GB' WHEN @Unit = 'KB' THEN 'KB' ELSE 'MB' END AS 'SUM',
        SUM (T) AS 'TOTAL', SUM (U) AS 'USED', SUM (F) AS 'FREE' FROM dbo.##Tbl_CombinedInfo;
  END

IF UPPER(ISNULL(@Level, 'DATABASE')) = 'DATABASE'
  BEGIN
    DECLARE @Tbl_Final TABLE (
      DatabaseName sysname NULL,
      TOTAL dec(12, 2),
      [=] char(1),
      used dec(12, 2),
      [used (%)] dec (5, 2),
      [+] char(1),
      free dec(12, 2),
      [free (%)] dec (5, 2),
      [==] char(2),
      Data dec(12, 2),
      Data_Used dec(12, 2),
      [Data_Used (%)] dec (5, 2),
      Data_Free dec(12, 2),
      [Data_Free (%)] dec (5, 2),
      [++] char(2),
      Log dec(12, 2),
      Log_Used dec(12, 2),
      [Log_Used (%)] dec (5, 2),
      Log_Free dec(12, 2),
      [Log_Free (%)] dec (5, 2) );

    INSERT INTO @Tbl_Final
      SELECT x.DatabaseName, 
           x.Data + y.Log AS 'TOTAL', 
           '=' AS '=', 
           x.Data_Used + y.Log_Used AS 'U',
           (x.Data_Used + y.Log_Used)*100.0 / (x.Data + y.Log)  AS 'U(%)',
           '+' AS '+',
           x.Data_Free + y.Log_Free AS 'F',
           (x.Data_Free + y.Log_Free)*100.0 / (x.Data + y.Log)  AS 'F(%)',
           '==' AS '==',
           x.Data, 
           x.Data_Used, 
           x.Data_Used*100/x.Data AS 'D_U(%)',
           x.Data_Free, 
           x.Data_Free*100/x.Data AS 'D_F(%)',
           '++' AS '++', 
           y.Log, 
           y.Log_Used, 
           y.Log_Used*100/y.Log AS 'L_U(%)',
           y.Log_Free, 
           y.Log_Free*100/y.Log AS 'L_F(%)'
      FROM 
      ( SELECT d.DatabaseName, 
               SUM(d.T) AS 'Data', 
               SUM(d.U) AS 'Data_Used', 
               SUM(d.F) AS 'Data_Free' 
          FROM dbo.##Tbl_CombinedInfo d WHERE d.type = 'Data' GROUP BY d.DatabaseName ) AS x
      JOIN 
      ( SELECT l.DatabaseName, 
               SUM(l.T) AS 'Log', 
               SUM(l.U) AS 'Log_Used', 
               SUM(l.F) AS 'Log_Free' 
          FROM dbo.##Tbl_CombinedInfo l WHERE l.type = 'Log' GROUP BY l.DatabaseName ) AS y
      ON x.DatabaseName = y.DatabaseName;
    
    IF @Unit = 'KB'
      UPDATE @Tbl_Final SET TOTAL = TOTAL * 1024,
      used = used * 1024,
      free = free * 1024,
      Data = Data * 1024,
      Data_Used = Data_Used * 1024,
      Data_Free = Data_Free * 1024,
      Log = Log * 1024,
      Log_Used = Log_Used * 1024,
      Log_Free = Log_Free * 1024;
      
     IF @Unit = 'GB'
      UPDATE @Tbl_Final SET TOTAL = TOTAL / 1024,
      used = used / 1024,
      free = free / 1024,
      Data = Data / 1024,
      Data_Used = Data_Used / 1024,
      Data_Free = Data_Free / 1024,
      Log = Log / 1024,
      Log_Used = Log_Used / 1024,
      Log_Free = Log_Free / 1024;
      
      DECLARE @GrantTotal dec(12, 2);
      SELECT @GrantTotal = SUM(TOTAL) FROM @Tbl_Final;

      INSERT INTO dbo.##ReviewResults SELECT 'WEIGHT (%)','DATABASE', 'USED  (%)', 'FREE  (%)','TOTAL','DATA  (used,  %)', 'LOG  (used,  %)','','','','','','','','','','','','','','','','','','','','','',''

	  INSERT INTO dbo.##ReviewResults 
	  SELECT 
      CONVERT(dec(12, 2), TOTAL*100.0/@GrantTotal) AS 'WEIGHT (%)', 
      DatabaseName AS 'DATABASE',
      CONVERT(VARCHAR(12), used) + '  (' + CONVERT(VARCHAR(12), [used (%)]) + ' %)' AS 'USED  (%)',
      
      CONVERT(VARCHAR(12), free) + '  (' + CONVERT(VARCHAR(12), [free (%)]) + ' %)' AS 'FREE  (%)',
     
      TOTAL, 
  
      CONVERT(VARCHAR(12), Data) + '  (' + CONVERT(VARCHAR(12), Data_Used) + ',  ' + 
      CONVERT(VARCHAR(12), [Data_Used (%)]) + '%)' AS 'DATA  (used,  %)',
    
      CONVERT(VARCHAR(12), Log) + '  (' + CONVERT(VARCHAR(12), Log_Used) + ',  ' + 
      CONVERT(VARCHAR(12), [Log_Used (%)]) + '%)' AS 'LOG  (used,  %)', 
	  '','','','','','','','','','', '','','','','','','','','','','',''
        FROM @Tbl_Final 
        WHERE DatabaseName LIKE ISNULL(@TargetDatabase, '%')
        ORDER BY DatabaseName ASC;
        
    IF @TargetDatabase IS NULL
	  INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
	  INSERT INTO dbo.##ReviewResults SELECT 'SQL Server Space Utilization', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
	  INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';
	  INSERT INTO dbo.##ReviewResults SELECT 'Unit','Used Space', 'Free Space','Total Space','Data File Space','Log File Space','','','','','','','','','','','','', '','','','','','','','','','','';
	  INSERT INTO dbo.##ReviewResults  
      SELECT CASE WHEN @Unit = 'GB' THEN 'GB' WHEN @Unit = 'KB' THEN 'KB' ELSE 'MB' END AS 'SUM', 
      SUM (used) AS 'USED', 
      SUM (free) AS 'FREE', 
      SUM (TOTAL) AS 'TOTAL', 
      SUM (Data) AS 'DATA', 
      SUM (Log) AS 'LOG',
	  '','','','','','','','','','','', '','','','','','','','','','','',''
      FROM @Tbl_Final;
  END
  




---------------------------------------------------------------------------------------
-- Backup check --
-----------------------------------------------------------------------------------


INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT 'BACKUP HISTORY:', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT 'Database Name', 'Status' ,'Recovery Mode','Compatibility Mode','Database Owner','State','Last Full Backup','Full Backup in Last 7 days', 'Last Differential Backup','Diff Backup in Last 7 days','Last Log Backup','Log Backup in Last 7 days','','','','','', '','','','','','','','','','','','';

declare @cmd sysname, 
        @db_name varchar(300),
        @i int,
        @db_mode varchar(300),
        @log_bkup_count int,
		@last_full_backup datetime,
        @full_bkup_count int,
        @diff_bkup_count int,
        @last_diff_backup datetime,
        @last_Tlog_backup datetime;

if OBJECT_ID('##backupfilelist','u') is not null
    DROP TABLE ##backupfilelist
    CREATE TABLE  ##backupfilelist
    (
	backup_db_name varchar(300), 
	datetimestart datetime,
	datetimeend datetime,
	backuptype varchar (10),
	filefolder varchar(256),
	)

if OBJECT_ID('##databaselist','u') is not null
    DROP TABLE ##databaselist
	CREATE TABLE ##databaselist
	(		
      db_count int identity(1,1)
    ,  databaseid        int
    , databasename      varchar(300)
    , recovery_model_desc varchar(128)	
	);
	
if OBJECT_ID('##backupstatuslist','u') is not null
    DROP TABLE ##backupstatuslist
	CREATE TABLE ##backupstatuslist
	(		
      database_name varchar(300),
      recovery_mode varchar(128),
      full_backup_count int,
      last_full_backup datetime,
      diff_bkup_count int,
      last_diff_backup datetime,
      Tlog_backup_counts int,
      last_Tlog_backup datetime,
   	);


IF OBJECT_ID('tempdb.dbo.##TempDbBackupsInfo', 'U') IS NOT NULL
  DROP TABLE dbo.##TempDbBackupsInfo;

IF OBJECT_ID('tempdb.dbo.##BackupsWarnings', 'U') IS NOT NULL
  DROP TABLE dbo.##BackupsWarnings;

CREATE TABLE dbo.##TempDbBackupsInfo (
	databasename varchar(max) NOT NULL,
	databasestate varchar(max) NOT NULL,
	recoverymodel varchar(max) NOT NULL,
	compatibilitymodel varchar(max) NOT NULL,
	databaseowner varchar(max) NULL,
	lastfullbackup varchar(max) NULL,
	lastdiffbackup varchar(max) NULL,
	lastlogbackup varchar(max) NULL

)

CREATE TABLE dbo.##BackupsWarnings (
	databasename varchar(max) NOT NULL,
	warning varchar(max) NOT NULL
	)

INSERT INTO dbo.##TempDbBackupsInfo
SELECT 
fbackup.DatabaseName, f.state_desc, f.recovery_model_desc, f.compatibility_level, SUSER_SNAME(f.owner_sid) AS [databaseonweruser], fbackup.LastFullBackup, dbackup.LastDifBackup, lbackup.LastLogBackup
FROM
(SELECT 
d.name AS 'DatabaseName', MAX(b.backup_finish_date) AS 'LastFullBackup'
FROM
master.sys.sysdatabases d
LEFT OUTER JOIN msdb..backupset b
ON b.database_name = d.name
AND b.type = 'D'
GROUP BY d.name
) fbackup
JOIN
(SELECT 
d.name AS 'DatabaseName', MAX(b.backup_finish_date) AS 'LastDifBackup'
FROM
master.sys.sysdatabases d
LEFT OUTER JOIN msdb..backupset b
ON b.database_name = d.name
AND b.type = 'I'
GROUP BY d.name
) dbackup
ON
fbackup.DatabaseName = dbackup.DatabaseName
JOIN
(SELECT 
d.name AS 'DatabaseName', MAX(b.backup_finish_date) AS 'LastLogBackup'
FROM
master.sys.sysdatabases d
LEFT OUTER JOIN msdb..backupset b
ON b.database_name = d.name
AND b.type = 'L'
GROUP BY d.name
) lbackup
ON lbackup.DatabaseName = dbackup.DatabaseName
LEFT OUTER JOIN
master.sys.databases f
ON
lbackup.DatabaseName = f.name
WHERE fbackup.DatabaseName != 'tempdb'

DECLARE @bak_databasename varchar(max)
DECLARE @bak_databasestate varchar(max)
DECLARE @bak_recoverymodel varchar(max)
DECLARE @bak_lastfullbackup datetime
DECLARE @bak_lastdiffbackup datetime
DECLARE @bak_lastlogbackup datetime

DECLARE backupswarning_cursor CURSOR FOR
SELECT databasename, databasestate, recoverymodel, lastfullbackup, lastdiffbackup, lastlogbackup
FROM dbo.##TempDbBackupsInfo

OPEN backupswarning_cursor

FETCH NEXT FROM backupswarning_cursor
INTO @bak_databasename, @bak_databasestate, @bak_recoverymodel, @bak_lastfullbackup, @bak_lastdiffbackup, @bak_lastlogbackup

WHILE @@FETCH_STATUS = 0
BEGIN
	IF @bak_databasestate = 'ONLINE'
		BEGIN
			IF @bak_lastfullbackup > DATEADD(dd,-7,GETDATE())
			BEGIN
				IF @bak_lastdiffbackup > DATEADD(dd,-2,GETDATE())
					BEGIN
						IF @bak_recoverymodel = 'SIMPLE'
							BEGIN
								INSERT INTO ##BackupsWarnings SELECT @bak_databasename, 'OK'
							END
						ELSE
							IF @bak_databasename != 'model'
							BEGIN
								BEGIN
									IF @bak_lastlogbackup > DATEADD(dd,-1,GETDATE())
										BEGIN
											INSERT INTO ##BackupsWarnings SELECT @bak_databasename, 'OK'
										END
									ELSE
										BEGIN
											INSERT INTO ##BackupsWarnings SELECT @bak_databasename, 'Warning: Log backups'
										END
								END
							END
								ELSE
									BEGIN
										INSERT INTO ##BackupsWarnings SELECT @bak_databasename, 'OK'
									END
									
					END
				ELSE
					BEGIN
						IF @bak_lastfullbackup > DATEADD(dd,-2,GETDATE())
							BEGIN
								IF @bak_recoverymodel = 'SIMPLE' OR @bak_databasename = 'model'
									BEGIN
									INSERT INTO ##BackupsWarnings SELECT @bak_databasename, 'OK'
									END
								ELSE
									BEGIN
										IF @bak_lastlogbackup > DATEADD(dd,-1,GETDATE())
											BEGIN
											INSERT INTO ##BackupsWarnings SELECT @bak_databasename, 'OK'
											END
										ELSE
											BEGIN
												INSERT INTO ##BackupsWarnings SELECT @bak_databasename, 'Warning: Log backups'
											END
									END
							END
						ELSE
							BEGIN
							INSERT INTO ##BackupsWarnings SELECT @bak_databasename, 'Warning: Daily backups'
							END
					END
				END
			
		ELSE
			BEGIN
			INSERT INTO ##BackupsWarnings SELECT @bak_databasename, 'Warning: Full backups'
			END
		END
	ELSE
		BEGIN
		INSERT INTO ##BackupsWarnings SELECT @bak_databasename, 'Skipped: not online'
		END
	
	FETCH NEXT FROM backupswarning_cursor
	INTO @bak_databasename, @bak_databasestate, @bak_recoverymodel, @bak_lastfullbackup, @bak_lastdiffbackup, @bak_lastlogbackup
END

CLOSE backupswarning_cursor
DEALLOCATE backupswarning_cursor


------------------------------------------------------------------------------------------------------------------
DECLARE @backupinfo_status varchar(max)
SET @sum_backup = 0

DECLARE backupsummary_cursor CURSOR FOR
SELECT warning
FROM dbo.##BackupsWarnings

OPEN backupsummary_cursor

FETCH NEXT FROM backupsummary_cursor
INTO @backupinfo_status

WHILE @@FETCH_STATUS = 0
BEGIN

IF @backupinfo_status LIKE 'Warning%' SET @sum_backup = 1

FETCH NEXT FROM backupsummary_cursor
	INTO @backupinfo_status
END

CLOSE backupsummary_cursor
DEALLOCATE backupsummary_cursor


------------------------------------------------------------------------------------------------------------------


insert into ##backupfilelist
           (backup_db_name,datetimestart,datetimeend,backuptype,filefolder) 
           select msdb.dbo.backupset.database_name,  
				msdb.dbo.backupset.backup_start_date,  
				msdb.dbo.backupset.backup_finish_date, 
				case msdb..backupset.type  
					when 'd' then 'database'  
					when 'l' then 'log'  
					when 'i' then 'diff'
				end as backup_type,  
				msdb.dbo.backupmediafamily.physical_device_name 
			from   msdb.dbo.backupmediafamily  
				inner join msdb.dbo.backupset on msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id  
				where  (convert(datetime, msdb.dbo.backupset.backup_start_date, 102) >= getdate() - 7)  
			order by  
				msdb.dbo.backupset.database_name, 
				 msdb.dbo.backupset.backup_finish_date
           
insert into ##databaselist
    select database_id
        , name
        , recovery_model_desc
    from sys.databases
    where [state] = 0 
        and is_in_standby = 0
        and name <> 'tempdb'
------------------------------------------------------------------------------------------------------------------

set @i = (select count(*) from ##databaselist)

 while ( @i <> 0 )    
 begin
		set @db_name = (select databasename from ##databaselist where db_count = @i)
		set @db_mode = (select recovery_model_desc from ##databaselist where db_count = @i)
		set @i = @i - 1;
		set @full_bkup_count = (select count(*) from ##backupfilelist where backup_db_name = @db_name and backuptype = 'database');
		set @last_full_backup = (SELECT MAX(backup_finish_date) FROM msdb..backupset WHERE type = 'D' AND database_name = @db_name);
		set @log_bkup_count = (select count(*) from ##backupfilelist where backup_db_name = @db_name and backuptype = 'log');
		set @last_Tlog_backup = (SELECT MAX(backup_finish_date) FROM msdb..backupset WHERE type = 'L' AND database_name = @db_name);
		set @diff_bkup_count = (select count(*) from ##backupfilelist where backup_db_name = @db_name and backuptype = 'diff');
		set @last_diff_backup = (SELECT MAX(backup_finish_date) FROM msdb..backupset WHERE type = 'I' AND database_name = @db_name);
		
	insert into ##backupstatuslist values (@db_name,@db_mode,@full_bkup_count,@last_full_backup,@diff_bkup_count,@last_diff_backup,@log_bkup_count,@last_Tlog_backup);  
 end


--- Backup Final result display --


INSERT INTO dbo.##ReviewResults
select ##TempDbBackupsInfo.databasename,##TempDbBackupsInfo.databasestate, ##TempDbBackupsInfo.recoverymodel,##TempDbBackupsInfo.compatibilitymodel,##TempDbBackupsInfo.databaseowner,##BackupsWarnings.warning,##TempDbBackupsInfo.lastfullbackup, ##backupstatuslist.full_backup_count,
 ##TempDbBackupsInfo.lastdiffbackup, ##backupstatuslist.diff_bkup_count, ##TempDbBackupsInfo.lastlogbackup,##backupstatuslist.Tlog_backup_counts,'','','','' ,'','','','','','','','','','','','',''from dbo.##TempDbBackupsInfo
JOIN ##backupstatuslist ON  ##TempDbBackupsInfo.databasename = ##backupstatuslist.database_name
JOIN ##BackupsWarnings ON ##TempDbBackupsInfo.databasename = ##BackupsWarnings.databasename 


DROP TABLE dbo.##TempDbBackupsInfo;
DROP TABLE dbo.##BackupsWarnings;


INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';




------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Jobs check --
----------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO dbo.##ReviewResults SELECT 'SQL SERVER AGENT JOBS:', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT 'Job Name', 'Job Owner','Enabled','Monitored','Last run outcome','Success/Failure in last 14 days','Schedule','','','','','','','','','','', '','','','','','','','','','','','';

IF OBJECT_ID('tempdb.dbo.#jobschedule', 'U') IS NOT NULL
DROP TABLE #jobschedule

SELECT
	  jobs.job_id ,
jobs.name,
CASE scheduleslist.enabled
        WHEN 1 THEN 'Enabled'
        WHEN 0 THEN 'Disabled'
END AS [IsEnabled],
CASE 
        WHEN [freq_type] = 64 THEN 'Start automatically when SQL Server Agent starts'
        WHEN [freq_type] = 128 THEN 'Start whenever the CPUs become idle'
        WHEN [freq_type] IN (4,8,16,32) THEN 'Recurring'
        WHEN [freq_type] = 1 THEN 'One Time'
END [ScheduleType],
CASE [freq_type]
        WHEN 1 THEN 'One Time'
        WHEN 4 THEN 'Daily'WHEN 8 THEN 'Weekly'
        WHEN 16 THEN 'Monthly'
        WHEN 32 THEN 'Monthly - Relative to Frequency Interval'
        WHEN 64 THEN 'Start automatically when SQL Server Agent starts'
        WHEN 128 THEN 'Start whenever the CPUs become idle'
END [Occurrence],
CASE [freq_type]
        WHEN 4 THEN 'Occurs every ' + CAST([freq_interval] AS VARCHAR(3)) + ' day(s)'
        WHEN 8 THEN 'Occurs every ' + CAST([freq_recurrence_factor] AS VARCHAR(3)) 
                    + ' week(s) on '
                    + CASE WHEN [freq_interval] & 1 = 1 THEN 'Sunday' ELSE '' END
                    + CASE WHEN [freq_interval] & 2 = 2 THEN ', Monday' ELSE '' END
                    + CASE WHEN [freq_interval] & 4 = 4 THEN ', Tuesday' ELSE '' END
                    + CASE WHEN [freq_interval] & 8 = 8 THEN ', Wednesday' ELSE '' END
                    + CASE WHEN [freq_interval] & 16 = 16 THEN ', Thursday' ELSE '' END
                    + CASE WHEN [freq_interval] & 32 = 32 THEN ', Friday' ELSE '' END
                    + CASE WHEN [freq_interval] & 64 = 64 THEN ', Saturday' ELSE '' END
        WHEN 16 THEN 'Occurs on Day ' + CAST([freq_interval] AS VARCHAR(3)) 
                     + ' of every '
                     + CAST([freq_recurrence_factor] AS VARCHAR(3)) + ' month(s)'
        WHEN 32 THEN 'Occurs on '
                     + CASE [freq_relative_interval]
                        WHEN 1 THEN 'First'
                        WHEN 2 THEN 'Second'
                        WHEN 4 THEN 'Third'
                        WHEN 8 THEN 'Fourth'
                        WHEN 16 THEN 'Last'
                       END
                     + ' ' 
                     + CASE [freq_interval]
                        WHEN 1 THEN 'Sunday'
                        WHEN 2 THEN 'Monday'
                        WHEN 3 THEN 'Tuesday'
                        WHEN 4 THEN 'Wednesday'
                        WHEN 5 THEN 'Thursday'
                        WHEN 6 THEN 'Friday'
                        WHEN 7 THEN 'Saturday'
                        WHEN 8 THEN 'Day'
                        WHEN 9 THEN 'Weekday'
                        WHEN 10 THEN 'Weekend day'
                       END
                     + ' of every ' + CAST([freq_recurrence_factor] AS VARCHAR(3)) 
                     + ' month(s)'
END AS [Recurrence],
CASE [freq_subday_type]
        WHEN 1 THEN 'Occurs once at ' 
                    + STUFF(
                 STUFF(RIGHT('000000' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
        WHEN 2 THEN 'Occurs every ' 
                    + CAST([freq_subday_interval] AS VARCHAR(3)) + ' Second(s) between ' 
                    + STUFF(
                   STUFF(RIGHT('000000' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
                    + ' & ' 
                    + STUFF(
                    STUFF(RIGHT('000000' + CAST([active_end_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
        WHEN 4 THEN 'Occurs every ' 
                    + CAST([freq_subday_interval] AS VARCHAR(3)) + ' Minute(s) between ' 
                    + STUFF(
                   STUFF(RIGHT('000000' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
                    + ' & ' 
                    + STUFF(
                    STUFF(RIGHT('000000' + CAST([active_end_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
        WHEN 8 THEN 'Occurs every ' 
                    + CAST([freq_subday_interval] AS VARCHAR(3)) + ' Hour(s) between ' 
                    + STUFF(
                    STUFF(RIGHT('000000' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
                    + ' & ' 
                    + STUFF(
                    STUFF(RIGHT('000000' + CAST([active_end_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
END [Frequency] 
into #jobschedule
FROM [msdb].[dbo].[sysschedules] scheduleslist 
JOIN [msdb].[dbo].[sysjobschedules] jobschedulelist ON scheduleslist.schedule_id = jobschedulelist.schedule_id
JOIN [msdb].[dbo].[sysjobs] jobs ON jobschedulelist.job_id = jobs.job_id 
order by jobs.name

If OBJECT_ID ('tempdb.dbo.#jobinfo', 'U') IS NOT NULL
DROP TABLE #jobinfo
If OBJECT_ID ('tempdb.dbo.#jobstatus', 'U') IS NOT NULL
DROP TABLE #jobstatus

select sj.job_id,sj.name , last_outcome_message,
case sjs.last_run_outcome
		when 0 then 'Failed'
		When 1 then 'Succeed'
		when 3 then 'Cancel'
End as 'Last Run Outcome',
case last_run_date  
		when 0 then '---'
		else substring(convert(varchar(8), last_run_date), 1, 4) + '-' + 
			substring(convert(varchar(8), last_run_date), 5, 2) + '-' + 
			substring(convert(varchar(8), last_run_date), 7, 2) 
end + ' ' + 
case last_run_time  
			when 0 then '---' 
			else case
				when datalength(convert(varchar(6),last_run_time)) = 5 then '0' + 
                     substring(convert(varchar(6), last_run_time), 1, 1) + ':' + 
                     substring(convert(varchar(6), last_run_time), 2, 2) 
                Else
                     substring(convert(varchar(6), last_run_time), 1, 2) + ':' + 
                     substring(convert(varchar(6), last_run_time), 3, 2) 
				end 
		end + '  ' as 'Last Run Time',    
last_run_duration as 'Last Run Duration(seconds)',

case sj.enabled
			when 0 then 'No'
			when 1 then 'Yes'
end as 'Enabled ?', 
case sj.notify_level_eventlog
	when 0 then 'No: Not Setup'
	when 1 then 'No: notification on Success'
	when 2 then 'Yes: notification on Failure'
	when 3 then 'No: notification on Completion'
end as 'Notification in Eventlog', 
sj.description, sj.date_created, sj.date_modified , SUSER_SNAME(sj.[owner_sid]) as [Job Owner]
into #jobinfo
from msdb.dbo.sysjobservers as sjs 
join msdb.dbo.sysjobs as sj on (sjs.job_id = sj.job_id)
order by sj.[name]



SELECT sjh.job_id
    , SUM(CASE WHEN sjh.run_status = 1 AND step_id = 0 THEN 1 ELSE 0 END) AS success
    , SUM(CASE WHEN sjh.run_status = 3 AND step_id = 0 THEN 1 ELSE 0 END) AS cancel
    , SUM(CASE WHEN sjh.run_status = 0 AND step_id = 0 THEN 1 ELSE 0 END) AS fail
    , SUM(CASE WHEN sjh.run_status = 2 THEN 1 ELSE 0 END) AS retry into #jobstatus
FROM msdb.dbo.sysjobhistory AS sjh
where sjh.run_date >= convert(char(10),getdate()-14,112)
GROUP BY sjh.job_id;


INSERT INTO dbo.##ReviewResults 
select ji.name,ji.[Job Owner], ji.[Enabled ?],ji.[Notification in Eventlog],  
   
   ji.[Last Run Outcome] + ' / '+ CONVERT(varchar, ISNULL(ji.[Last Run Time],''), 120) +' / ' + CONVERT(varchar(10), ISNULL(ji.[Last Run Duration(seconds)],'') ) + ' seconds'
   as [Last Run Outcome],

   CONVERT(varchar(10),ISNULL(jss.success,''))+' success / ' + CONVERT(varchar(10),ISNULL(jss.fail,'')) + ' fail' 
   as [Success/Failure (in last 14 days)],
  
   ISNULL(js.IsEnabled,'')+' / ' + ISNULL(js.ScheduleType,'')+' / '+ISNULL(js.Occurrence,'')+' / '+ISNULL(js.Recurrence,'')+' / '+ISNULL(js.Frequency,'')
   as [Schedule],'','','','','','','','','','', '','','','','','','','','','','',''

from #jobinfo as ji 
left join #jobschedule as js on (js.job_id = ji.job_id)
left join #jobstatus as jss on (jss.job_id=ji.job_id)
order by ji.[Enabled ?] desc,ji.name


-------------------------------------------
DECLARE @jobinfo_name varchar(max)
DECLARE @jobinfo_eventlog varchar(max)
DECLARE @jobinfo_success bigint
DECLARE @jobinfo_fail bigint

SET @sum_jobs = 0

DECLARE jobsummary_cursor CURSOR FOR
select ji.name, ji.[Notification in Eventlog], jss.success, jss.fail
from #jobinfo as ji 
left join #jobstatus as jss on (jss.job_id=ji.job_id)

OPEN jobsummary_cursor

FETCH NEXT FROM jobsummary_cursor
INTO @jobinfo_name, @jobinfo_eventlog, @jobinfo_success, @jobinfo_fail

WHILE @@FETCH_STATUS = 0
BEGIN

IF (@jobinfo_eventlog LIKE 'No%' AND (@jobinfo_fail + @jobinfo_success) > 0 AND @jobinfo_name != 'syspolicy_purge_history' AND @jobinfo_name != 'Database Mirroring Monitor Job') OR @jobinfo_fail > @jobinfo_success SET @sum_jobs = 1

FETCH NEXT FROM jobsummary_cursor
	INTO @jobinfo_name, @jobinfo_eventlog, @jobinfo_success, @jobinfo_fail
END

CLOSE jobsummary_cursor
DEALLOCATE jobsummary_cursor

-----------------------------------------------
-- Error log --
-----------------------------------------------


INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT 'SQL SERVER ERROR LOG LAST 48h:', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##ReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

SET @sum_errorlog = 0

use tempdb
DECLARE @HOURS INT
SET @HOURS = 48


if object_id('tempdb.dbo.#ErrorLog', 'U') IS NOT NULL
drop table #ErrorLog
CREATE TABLE #ErrorLog
(LogDate DateTime, ProcessInfo Varchar(50),
[text] Varchar(4000))

INSERT INTO #ErrorLog
EXEC sp_readerrorlog

DELETE FROM #ErrorLog
WHERE LogDate < CAST(DATEADD(HH,-@HOURS,
GETDATE()) AS VARCHAR(23))

IF EXISTS (Select top 1 * from #ErrorLog WHERE text like '%error%' and text not like '%no error%' and text not like '% 0 error%' and text not like '%without error%' and text not like 'Login failed%' and ProcessInfo != 'Logon' or text like '%fail%' and text not like '%no error%' and text not like '% 0 error%' and text not like '%without error%' and text not like 'Login failed%' and ProcessInfo != 'Logon')
BEGIN
      INSERT INTO dbo.##ReviewResults SELECT 'Date', 'Process Info','Text','','','','','','','','','','','','','','','','','','','','','','','','','','';
      SET @sum_errorlog = 1
      INSERT INTO dbo.##ReviewResults
      SELECT *,'','','','','','','','','','','','','','', '','','','','','','','','','','','' FROM #ErrorLog WHERE text like '%error%' and text not like '%no error%' and text not like '% 0 error%' and text not like '%without error%' and text not like 'Login failed%' and ProcessInfo != 'Logon' or text like '%fail%' and text not like '%no error%' and text not like '% 0 error%' and text not like '%without error%' and text not like 'Login failed%' and ProcessInfo != 'Logon'
END
ELSE
BEGIN
      INSERT INTO dbo.##ReviewResults SELECT 'No errors found', '','','','','','','','','','','','','','','','','','','','','','','','','','','','';
END

DROP TABLE #ErrorLog



-----------------------------------------------
-- Formatting --
-----------------------------------------------

INSERT INTO dbo.##FinalReviewResults SELECT 'SUMMARY:','','','','','','','','','','','','','','','','','','','','','','','','','','','','';

INSERT INTO dbo.##FinalReviewResults SELECT '', '','','','','','','','','','','','','','','','','','','','','','','','','','','','';

INSERT INTO dbo.##FinalReviewResults SELECT 'Server Name and Instance:','Version','Memory','AWE','HA and DR','SQL Server Configuration Option','Space Utilization','Database configuration','Database Consistency','Backups','Jobs','Error Log','','','','','','','','','','','','','','','','','';

INSERT INTO dbo.##FinalReviewResults SELECT CONVERT(varchar,@@SERVERNAME), CASE @notupgradable WHEN 1 THEN 'OK' ELSE 'WARNING' END, CASE @maxram WHEN 2147483647 THEN 'WARNING' ELSE 'OK' END, CASE @aweenabled WHEN 1 THEN 'WARNING' ELSE 'OK' END,CASE @HAConfig_State WHEN 1 THEN 'WARNING' ELSE 'OK' END,
										CASE @configuration WHEN 1 THEN 'WARNING' ELSE 'Check configuration Value as set accordingly' END,CASE @sum_drives WHEN 1 THEN 'WARNING' ELSE 'OK' END,CASE @db_status1 WHEN 1 THEN 'WARNING' ELSE 'OK' END,CASE @DBCC_State WHEN 1 THEN 'WARNING' ELSE 'OK' END,
										CASE @sum_backup WHEN 1 THEN 'WARNING' ELSE 'OK' END,CASE @sum_jobs WHEN 1 THEN 'WARNING' ELSE 'OK' END,CASE @sum_errorlog WHEN 1 THEN 'WARNING' ELSE 'OK' END,
										 '','','','','','','','','','','','','','','','','';

INSERT INTO dbo.##FinalReviewResults SELECT '', '','','','','','','','','','','','','','','','', '','','','','','','','','','','','';

INSERT INTO dbo.##FinalReviewResults SELECT * FROM dbo.##ReviewResults

-----------------------------------------------
-- Show results --
-----------------------------------------------

SELECT * FROM dbo.##FinalReviewResults

-----------------------------------------------
-- Dropping tables and rolling settings back --
-----------------------------------------------

--DROP TABLE dbo.##ReviewResults
--DROP TABLE dbo.##FinalReviewResults

--DROP TABLE dbo.##DrvLetter

--DROP TABLE dbo.##DrvInfo

--drop table #jobschedule
--drop table #jobinfo
--drop table #jobstatus



if @chkCMDShell = 0 and @ShAdvOpt = 0
begin
	
	EXEC sp_configure 'xp_cmdshell', 0
	RECONFIGURE;
		
	EXEC sp_configure 'show advanced options', 0
	RECONFIGURE;
		
	Print 'xp_cmdshell and Show advanced options are Disabled agin'
end
else if @chkCMDShell = 0 and @ShAdvOpt = 1
    Begin
	EXEC sp_configure 'xp_cmdshell', 0
	RECONFIGURE;
	Print 'xp_cmdshell is Disabled again'
	end
else
begin
 Print 'xp_cmdshell was already enabled'
end
