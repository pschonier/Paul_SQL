/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [Administration].[dbo].[SpotAward] sa
  LEFT OUTER JOIN Administration.dbo.SpotNomination sn ON sn.SpotNominationID = sa.NominationID 
  WHERE YEAR(awardDate) = 2016 -- AND sa.RecipientName LIKE '%Schonier%'-- sa.DepartmentId 