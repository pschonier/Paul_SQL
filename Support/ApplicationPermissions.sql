
  SELECT RoleMemberId, sr.RoleID  
  ,ApplicationName,
  sa.ApplicationId,
  RoleName,
  Environment,
  UserId,
  IsAdmin
  FROM [AppAdmin].[dbo].SysRoles sr 
  LEFT OUTER JOIN SysRoleMembers srm ON sr.RoleId = srm.RoleId
  LEFT OUTER JOIN SysApplications sa ON sa.ApplicationId = sr.ApplicationId
WHERE srm.UserId = 'jagee'
  ORDER BY ApplicationName 

  SELECT * FROM dbo.SysRoleMembers WHERE UserId = 'jagee'

  SELECT * FROM dbo.SysApplications ORDER BY ApplicationName


SELECT TOP 1000 [RoleId]
      ,[ApplicationId]
      ,[RoleName]
      ,[IsAdmin]
  FROM [AppAdmin].[dbo].[SysRoles] WHERE ApplicationId = 50



    INSERT INTO [AppAdmin].[dbo].[SysRoleMembers] 
  (    [Environment]
      ,[UserId]
      ,[RoleId])

VALUES ('Prod', 'lsloan.contractor', 12) 