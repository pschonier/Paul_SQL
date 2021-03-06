--/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP 1000 [PP_Number]
--      ,[MEBANKID]
--      ,[Output_Format]
--      ,[BANKID]
--      ,[BANKNAME]
--      ,[BNKBRNCH]
--      ,[PHONE1]
--      ,[PHONE2]
--      ,[HYPELINK]
--      ,[DLFILAPTH]
--      ,[HYPEPATH]
--      ,[MEINCWFT]
--      ,[MEUPLDID]
--      ,[MKLSSTDD]
--      ,[MEUPTIM]
--      ,[ME_Number_of_Checks]
--      ,[ME_Checks_Amount]
--      ,[ME_Number_of_Voids]
--      ,[ME_Voids_Amount]
--      ,[ME_Confirmation_Number]
--      ,[Last_Reconciled_Date]
--      ,[Last_Reconciled_Balance]
--      ,[DEX_ROW_ID]
--  FROM [EPCO].[dbo].[ME123501].[DLFILAPTH]


create procedure dbo.SafePayDateUpdate with execute as OWNER
as 
Begin
	Set NOCOUNT on 
	declare @STRDATE nvarchar(12)
	set @STRDATE = replace(substring(convert(nvarchar, getdate(), 120),6,5),'-','') + substring(convert(nvarchar, getdate(), 120),1,4)+ replace(substring(convert(nvarchar, getdate(), 120),12,8),':','.')+'.date'
	update [EPCO].[dbo].[ME123501]
	set [EPCO].[dbo].[ME123501].[DLFILAPTH] = 'N:\DEPT\FINANCE\Cash\Positive Pay - BOK\Explorer.' + @STRDATE
	from [EPCO].[dbo].[ME123501] me
	where me.PP_Number = 'BANK OK OK'
end          

drop procedure dbo.SafePayDateUpdate


select * from [EPCO].[dbo].[ME123501]

