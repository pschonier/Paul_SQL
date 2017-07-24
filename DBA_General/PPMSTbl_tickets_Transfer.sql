/****** Script for SelectTopNRows command from SSMS  ******/

BEGIN TRANSACTION
DELETE

  FROM [PPMS].[dbo].[tbl_ticket]
  
  WHERE DATEADD(S, [time], '1970-01-01') < DATEADD(D,-365, GETDATE())
  ROLLBACK TRANSACTION