SELECT TOP 1000 [USERID]
      ,[CMPNYNAM]
      ,[LOGINDAT]
      ,[LOGINTIM]
      ,[SQLSESID]
      ,[Language_ID]
      ,[IsWebClient]
      ,[DEX_ROW_ID]
  FROM [Dynamics].[dbo].[ACTIVITY]


  select top 100 * from tempdb.dbo.DEX_SESSION
  select top 100 * from tempdb.dbo.DEX_LOCK
  select top 100 * from Dynamics.dbo.SY00800
  select top 100 * from Dynamics.dbo.SY00801
  select top 100 * from master..sysprocesses

  delete from DYNAMICS..ACTIVITY  where USERID not in (select loginame from master..sysprocesses)
  delete from tempdb..DEX_SESSION  where session_id not in (select SQLSESID from DYNAMICS..ACTIVITY)
  delete from tempdb..DEX_LOCK  where session_id not in (select SQLSESID from DYNAMICS..ACTIVITY)
  delete from DYNAMICS..SY00800  where USERID ='tbaca'
  DELETE FROM dynamics.dbo.ACTIVITY WHERE USERID = 'tbaca'
  delete from DYNAMICS..SY00801  where USERID ='tbaca'
