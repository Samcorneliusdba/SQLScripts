select
sysDB.database_id,
sysDB.Name as 'Database Name',
sysdb.create_date as 'Date Created',
case when SUSER_SNAME(sysdb.owner_sid) iS NULL then 'Not Available' else SUSER_SNAME(sysdb.owner_sid) end [DB Owner],
sysDB.state_desc as 'DB Status',
sysDB.recovery_model_desc as 'Recovery Mode',
sysDB.collation_name as 'Collation',
sysDB.user_access_desc as 'User Access',
case when sysDB.compatibility_level=80 then 'SQL 2000'
       when sysDB.compatibility_level=90 then 'SQL 2005'
       when sysDB.compatibility_level=100 then 'SQL 2008\2008R2'
       when sysDB.compatibility_level=110 then 'SQL 2012'
       when sysDB.compatibility_level=120 then 'SQL 2014'
       when sysDB.compatibility_level=130 then 'SQL 2016'
else 'Unsupported' end [Compatibility_Level],
sysDB.page_verify_option_desc as 'Page Verify Option',
case when sysDB.is_read_only =1 then 'Read_Only' else 'Read_Write' end [ReadOnly or Read_Write],
case when sysDB.is_auto_close_on = 1 then 'On' else 'Off' end [Auto Close Status],
case when sysDB.is_auto_shrink_on = 1 then 'On' else 'Off' end [Auto Shrink Status],
case when sysDB.is_auto_create_stats_on = 1 then 'On' else 'Off' end [Auto Create Stats Status],
case when sysDB.is_auto_update_stats_on = 1 then 'On' else 'Off' end [Auto Update Stats Status],
case when sysDB.is_fulltext_enabled = 1 then 'Enabled' else 'Not Enabled' end [Full Text Status],
case when sysDB.is_trustworthy_on = 1 then 'Yes' else 'No' end [Is_Database_Trustworthy],
case when sysDB.is_encrypted = 1 then 'Yes' else 'No' end [Is_Database_Encrypted],-- comment out for 2005 or if gives error
case when sysdb. is_cdc_enabled = 1 then 'Enabled' else 'Not Enabled' end [Is_CDC_Enabled] , -- comment out for 2005 or if gives error
case when sysDB. is_published = 1 then  'Yes' else 'No' end [Is_Database_Published],
case when sysdb. is_subscribed = 1 then 'Yes' else 'No' end [Is_Database_Subscribed],
case when lp.primary_database IS not null then 'Yes' else 'No' end LSConfigured,
case when sd.mirroring_state_desc IS NULL then 'Not Available' else sd.mirroring_state_desc end [Mirror State Desc] ,
case when sd.mirroring_partner_name IS NULL then 'Not Available' else sd.mirroring_partner_name end  [Partner Name],
case when sd.mirroring_role_desc IS NULL then 'Not Available' else sd.mirroring_role_desc end [Mirror Role] , 
case when sd.mirroring_safety_level_desc  IS NULL then 'Not Available' else sd.mirroring_safety_level_desc end [Safety Level],
case when sd.mirroring_witness_name  IS NULL then 'Not Available' else sd.mirroring_witness_name end [Witness]     
from sys.databases sysDB
Inner JOIN sys.database_mirroring sd ON sysDB.database_id = sd.database_id
Left JOIN msdb.dbo.log_shipping_monitor_primary LP on lp.primary_database=sysDB.name


