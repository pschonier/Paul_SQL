/*
   Tuesday, March 21, 20179:29:15 AM
   User: 
   Server: dbdev-pcc
   Database: K2_App
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Project
	DROP CONSTRAINT FK_Project_ProjectStatus
GO
ALTER TABLE dbo.ProjectStatus SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Project
	DROP CONSTRAINT FK_Project_ProjectCategory
GO
ALTER TABLE dbo.ProjectCategory SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Project
	DROP CONSTRAINT FK_Project_AccountType
GO
ALTER TABLE dbo.AccountType SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Account SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Project
	DROP CONSTRAINT FK_Project_Area
GO
ALTER TABLE dbo.Area SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Project
	(
	id int NOT NULL IDENTITY (1, 1),
	ProjectNumber varchar(50) NOT NULL,
	BudgetYear int NOT NULL,
	ProjectManager varchar(50) NOT NULL,
	ProjectType int NOT NULL,
	ProjectCategory int NOT NULL,
	BudgetYearInitial money NOT NULL,
	BudgetYearProposed money NOT NULL,
	BudgetApproved money NOT NULL,
	BudgetYearPlusOne money NOT NULL,
	BudgetYearPlusTwo money NOT NULL,
	BudgetYearPlusThree money NOT NULL,
	BudgetYearPlusFour money NOT NULL,
	BudgetYearPlusFive money NOT NULL,
	Area int NOT NULL,
	ProjectJustification varchar(MAX) NOT NULL,
	ProjectDocumentationLink varchar(255) NOT NULL,
	ProjectStatus int NOT NULL,
	ProjectStatusDate datetime NOT NULL,
	ProjectSubmissionDate datetime NOT NULL,
	ProjectSubmitter varchar(80) NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Project SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Project ON
GO
IF EXISTS(SELECT * FROM dbo.Project)
	 EXEC('INSERT INTO dbo.Tmp_Project (id, ProjectNumber, BudgetYear, ProjectManager, ProjectType, ProjectCategory, BudgetYearInitial, BudgetYearProposed, BudgetApproved, BudgetYearPlusOne, BudgetYearPlusTwo, BudgetYearPlusThree, BudgetYearPlusFour, BudgetYearPlusFive, Area, ProjectJustification, ProjectDocumentationLink, ProjectStatus, ProjectStatusDate, ProjectSubmissionDate, ProjectSubmitter)
		SELECT id, ProjectNumber, BudgetYear, ProjectManager, ProjectType, ProjectCategory, BudgetYearInitial, BudgetYearProposed, BudgetApproved, BudgetYearPlusOne, BudgetYearPlusTwo, BudgetYearPlusThree, BudgetYearPlusFour, BudgetYearPlusFive, Area, ProjectJustification, ProjectDocumentationLink, ProjectStatus, ProjectStatusDate, ProjectSubmissionDate, ProjectSubmitter FROM dbo.Project WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Project OFF
GO
DROP TABLE dbo.Project
GO
EXECUTE sp_rename N'dbo.Tmp_Project', N'Project', 'OBJECT' 
GO
ALTER TABLE dbo.Project ADD CONSTRAINT
	PK_Project PRIMARY KEY CLUSTERED 
	(
	id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Project ADD CONSTRAINT
	FK_Project_AccountType FOREIGN KEY
	(
	ProjectType
	) REFERENCES dbo.AccountType
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Project ADD CONSTRAINT
	FK_Project_ProjectCategory FOREIGN KEY
	(
	ProjectCategory
	) REFERENCES dbo.ProjectCategory
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Project ADD CONSTRAINT
	FK_Project_Area FOREIGN KEY
	(
	Area
	) REFERENCES dbo.Area
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Project ADD CONSTRAINT
	FK_Project_ProjectStatus FOREIGN KEY
	(
	ProjectStatus
	) REFERENCES dbo.ProjectStatus
	(
	StatusID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Budget
	(
	id int NOT NULL IDENTITY (1, 1),
	ProjectID int NOT NULL,
	AreaID int NOT NULL,
	AccountNum nvarchar(100) NOT NULL,
	January money NOT NULL,
	February money NOT NULL,
	March money NOT NULL,
	April money NOT NULL,
	May money NOT NULL,
	June money NOT NULL,
	July money NOT NULL,
	August money NOT NULL,
	September money NOT NULL,
	October money NOT NULL,
	November money NOT NULL,
	December money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Budget SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_Budget ADD CONSTRAINT
	DF_Budget_January DEFAULT 0 FOR January
GO
ALTER TABLE dbo.Tmp_Budget ADD CONSTRAINT
	DF_Budget_February DEFAULT 0 FOR February
GO
ALTER TABLE dbo.Tmp_Budget ADD CONSTRAINT
	DF_Budget_March DEFAULT 0 FOR March
GO
ALTER TABLE dbo.Tmp_Budget ADD CONSTRAINT
	DF_Budget_April DEFAULT 0 FOR April
GO
ALTER TABLE dbo.Tmp_Budget ADD CONSTRAINT
	DF_Budget_May DEFAULT 0 FOR May
GO
ALTER TABLE dbo.Tmp_Budget ADD CONSTRAINT
	DF_Budget_June DEFAULT 0 FOR June
GO
ALTER TABLE dbo.Tmp_Budget ADD CONSTRAINT
	DF_Budget_July DEFAULT 0 FOR July
GO
ALTER TABLE dbo.Tmp_Budget ADD CONSTRAINT
	DF_Budget_August DEFAULT 0 FOR August
GO
ALTER TABLE dbo.Tmp_Budget ADD CONSTRAINT
	DF_Budget_September DEFAULT 0 FOR September
GO
ALTER TABLE dbo.Tmp_Budget ADD CONSTRAINT
	DF_Budget_October DEFAULT 0 FOR October
GO
ALTER TABLE dbo.Tmp_Budget ADD CONSTRAINT
	DF_Budget_November DEFAULT 0 FOR November
GO
ALTER TABLE dbo.Tmp_Budget ADD CONSTRAINT
	DF_Budget_December DEFAULT 0 FOR December
GO
SET IDENTITY_INSERT dbo.Tmp_Budget ON
GO
IF EXISTS(SELECT * FROM dbo.Budget)
	 EXEC('INSERT INTO dbo.Tmp_Budget (id)
		SELECT CONVERT(int, id) FROM dbo.Budget WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Budget OFF
GO
DROP TABLE dbo.Budget
GO
EXECUTE sp_rename N'dbo.Tmp_Budget', N'Budget', 'OBJECT' 
GO
ALTER TABLE dbo.Budget ADD CONSTRAINT
	PK_Budget PRIMARY KEY CLUSTERED 
	(
	id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Budget ADD CONSTRAINT
	FK_Budget_Project FOREIGN KEY
	(
	ProjectID
	) REFERENCES dbo.Project
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Budget ADD CONSTRAINT
	FK_Budget_Area FOREIGN KEY
	(
	AreaID
	) REFERENCES dbo.Area
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Budget ADD CONSTRAINT
	FK_Budget_Account FOREIGN KEY
	(
	AccountNum
	) REFERENCES dbo.Account
	(
	AccountNumber
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
