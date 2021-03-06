  /*This script set was written using data with no description hence the "UpdateMe" placeholder. - Paul*/
  
  --SELECT * FROM dbo.BudgetCategories
  BEGIN TRAN -- bring in new budget items
  INSERT INTO accounting.dbo.BudgetProjects
          ( CategoryID ,
            ProjectCode ,
            ProjectName ,
            CopyDescriptionToNewAFE ,
            ProjectDescription
          )
SELECT 3, LEFT([Project Name], CHARINDEX('-',[Project Name],1) -1), LEFT([Project Name],74), 1,'UpdateMe'   FROM [tempdb].[dbo].[WHSEStock] WHERE [Project Name] IS NOT null
ROLLBACK TRAN

BEGIN TRAN -- add costs to new budget items
INSERT INTO [Accounting].[dbo].[BudgetProjectCosts]
          ( [ProjectID] ,
            [BudgetYear] ,
            [AllocatedBudget] ,
            [ProjectedBudget] ,
            [ApprovedBudget]
          )
SELECT projectid, 2017, 0, i.[Amount], i.Amount FROM accounting.dbo.BudgetProjects bp
JOIN [tempdb].[dbo].WHSEStock i ON i.[Project Name] = bp.ProjectName WHERE bp.ProjectDescription = 'UpdateMe'
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
JOIN tempdb.dbo.WHSEStock2 i ON i.[Project Name] = bp.ProjectName
WHERE bp.ProjectDescription = 'UpdateMe'
ROLLBACK TRAN
BEGIN TRAN
UPDATE budgetProjects SET ProjectDescription = p.projectdescription
FROM budgetprojects bp 
JOIN tempdb.dbo.ProjDesc p ON p.[Project Name] = bp.ProjectName
WHERE bp.ProjectDescription = 'UpdateMe'
ROLLBACK TRAN
BEGIN TRAN
UPDATE dbo.BudgetProjectJustifications SET Description = p.projectdescription
FROM budgetprojectjustifications bp 
JOIN tempdb.dbo.ProjDesc p ON p.[Project Name] = bp.ProjectName
WHERE bp.Description = 'UpdateMe'
ROLLBACK TRAN


SELECT * INTO BPJ_Backup FROM dbo.BudgetProjectJustifications