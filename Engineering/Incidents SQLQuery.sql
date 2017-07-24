/****** Script for SelectTopNRows command from SSMS  ******/

SELECT [LocationDescription], Count([LocationDescription]) As Number_Incidents
  FROM [Explorer].[dbo].[Incidents]
  group by LocationDescription
  order by LocationDescription
  go