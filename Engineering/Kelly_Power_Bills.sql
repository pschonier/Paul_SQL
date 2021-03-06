/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 
case when Loc_State is null or loc_state = '' then State else Loc_State end as St,
[Location]
      ,[MilePost]
      ,[SubLoc]
      ,[Meter_num]
      ,pa.[AcctNo]
      ,[Loc_Address]
      ,[Loc_City]
      ,[Loc_State]
      ,[Loc_Zip]
      ,[Loc_Phone]
      ,[Service]
      ,[ServiceTypeID]
      ,[Utility]
      ,[Coding]
      ,[VendorNo]
      ,[Address]
      ,[City]
      ,[State]
      ,[Zip]
      ,[Phone]
      ,pbp.[id]
      ,[OutagePhone]
      ,[Inactive], pbp.*
  FROM [Accounting].[dbo].[PowerAccounts] pa
  right outer join Accounting.dbo.PowerBillPayments pbp on pa.AcctNo = pbp.AcctNo
  where ServiceDate between '2014-11-1' and '2014-12-1'
  order by pa.AcctNo desc