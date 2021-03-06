/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [HydrostaticTestID]
      ,[ProjectManager]
      ,(SELECT t.[AssetTypeName] FROM dbo.ht_assetType t WHERE t.[AssetTypeId] = hs.[AssetTypeID]) AS AssetType
      ,(SELECT t.TestTypeName FROM dbo.HT_TestType t WHERE t.[TestTypeId] = hs.testtypeID) AS TestType
      ,(SELECT MediumName FROM HT_TestMedium t WHERE t.[MediumId] = hs.testmediumID) AS TestMedium
	  ,REPLACE(REPLACE(REPLACE(REPLACE(cast([Description] as nvarchar(max)), CHAR(13) + CHAR(10), ' ... '), 
			CHAR(10) + CHAR(13), ' ... '), CHAR(13), ' '), CHAR(10), ' ... ') AS 'Description'
      ,[TestDate]
      ,[TestYear]
      ,[AFE]
      ,[PipeOD]
      ,[Duration]
      ,[QualifiedMOP]
      ,[StationBeginning]
      ,[StationEnding]
      ,[MPBeginning]
      ,[MPEnding]
      ,[ContractorName]
      ,[ContractNumber]
      ,[PressureChart]
      ,[Pressure]
      ,[BoxNumber]
      ,[Notes]
      ,[ExplorerFileNumber]
      ,[LocationList]
      ,[AssetList]
  FROM [PipelineAssets].[dbo].[HydrostaticTests] hs