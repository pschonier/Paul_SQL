BEGIN TRANSACTION
UPDATE [Accounting].[dbo].[BudgetProjectJustifications] SET ProjectManager = 'rstimson' WHERE ProjectName LIKE '%C168%'
ROLLBACK TRANSACTION