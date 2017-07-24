--UPDATE [Land].[dbo].[LandRecords]
--SET [ExplorerSubTract] = PARSENAME(ExplorerTract1,1)
--WHERE ExplorerTract1 - FLOOR(ExplorerTract1) > 0



 select PARSENAME(ExplorerTract1,1), ExplorerTract1
  FROM [Land].[dbo].[LandRecords]
WHERE ExplorerTract1 - FLOOR(ExplorerTract1) > 0

  
 select cast(ExplorerTract1 - FLOOR(ExplorerTract1) AS int), ExplorerTract1, CAST(ExplorerTract1 AS INT)%1
  FROM [Land].[dbo].[LandRecords]