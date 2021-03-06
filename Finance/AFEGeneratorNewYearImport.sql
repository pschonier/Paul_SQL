  /*This script set was written using data with no description hence the "UpdateMe" placeholder. - Paul*/
  
  
  BEGIN TRAN -- bring in new budget items
  INSERT INTO accounting.dbo.BudgetProjects
          ( CategoryID ,
            ProjectCode ,
            ProjectName ,
            CopyDescriptionToNewAFE ,
            ProjectDescription
          )
SELECT TypeCode, LEFT([Project Name], CHARINDEX('-',[Project Name],1) -1), [Project Name], 1,'UpdateMe'   FROM [tempdb].[dbo].[2017Import]
ROLLBACK TRAN

BEGIN TRAN -- add costs to new budget items
INSERT INTO [Accounting].[dbo].[BudgetProjectCosts]
          ( [ProjectID] ,
            [BudgetYear] ,
            [AllocatedBudget] ,
            [ProjectedBudget] ,
            [ApprovedBudget]
          )
SELECT projectid, 2017, 0, i.[2017], i.[2017] FROM accounting.dbo.BudgetProjects bp
JOIN [tempdb].[dbo].[2017Import] i ON i.[Project Name] = bp.ProjectName WHERE bp.ProjectDescription = 'UpdateMe'
ROLLBACK TRAN
  
  
  BEGIN tran
  INSERT INTO [Accounting].[dbo].[BudgetProjectJustifications]
          ( [ProjectCostID] ,
            [IsSubmitted] ,
            [ProjectManager] ,
            [ProjectName] ,
            [Description] ,
            [Justification] ,
            [CreatedOn]
          )
SELECT bpc.ProjectCostID, 0, i.ADName, bp.ProjectName, 'UpdateMe', 'Good Idea', GETDATE()  FROM accounting.dbo.BudgetProjectCosts bpc
JOIN Accounting.dbo.BudgetProjects bp ON bp.ProjectID = bpc.ProjectID
JOIN tempdb.dbo.[2017Import] i ON i.[Project Name] = bp.ProjectName
WHERE bp.ProjectDescription = 'UpdateMe'
ROLLBACK TRAN