SELECT * 
FROM master.sys.database_permissions [dp] 
JOIN master.sys.system_objects [so] ON dp.major_id = so.object_id
JOIN master.sys.sysusers [usr] ON 
     usr.uid = dp.grantee_principal_id 
	 --AND usr.name = 'abc_user'
WHERE permission_name = 'EXECUTE' AND so.name = 'sp_OACreate'



use master 
go

grant exec on sp_OACreate to UserLogin
GO
