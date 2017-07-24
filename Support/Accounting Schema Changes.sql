/*
Deployment script for Accounting

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO


GO
USE Accounting



GO
PRINT N'Altering [dbo].[BudgetType]...';


GO
ALTER TABLE [dbo].[BudgetType]
    ADD [Name] VARCHAR (50) NULL;


GO
PRINT N'Refreshing [dbo].[vwActualToBudgetMapping]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwActualToBudgetMapping]';


GO
PRINT N'Altering [dbo].[AuthorityRequestView]...';


GO

CREATE view [dbo].[AuthorityRequestView] as
with expenditures as (select AuthorityRequestID, sum(Cost) as Cost from dbo.AuthorityRequestExpenditures group by AuthorityRequestID)
SELECT
	AuthorityRequests.AuthorityRequestID,    
	CreateDate, 
	RequestTitle, 
	AuthorityRequests.CreateUser,
	AuthorityRequestFinals.ApprovedDate,
	AuthorityRequests.SupplementNumber,
	case 
		when SupplementAFE is null 
		then AuthorityRequestFinals.AFENumber 
		else  SupplementAFE end as AFENumber,
	case 
		when DateSubmitted is null 
		then 'Saved' 
		when isnull(RejectionReason,'') <> ''
		then 'Rejected'
		when AuthorityRequestFinals.AFENumber is null
		then 'Pending Approval'
		else 'Approved'
		end as Status,
		BudgetType.Name + '/' + CategoryDescription + '/' + BudgetProjects.ProjectName +'/' + REPLACE(CONVERT(VARCHAR,CONVERT(MONEY,isnull(Cost,0)),1), '.00','') as BudgetProject
FROM       
	dbo.AuthorityRequests     
	INNER JOIN dbo.BudgetProjectCosts ON dbo.AuthorityRequests.BudgetProjectCostID = dbo.BudgetProjectCosts.ProjectCostID 
	INNER JOIN dbo.BudgetProjects ON dbo.BudgetProjectCosts.ProjectID = dbo.BudgetProjects.ProjectID 
	INNER JOIN dbo.BudgetCategories ON dbo.BudgetProjects.CategoryID = dbo.BudgetCategories.CategoryID 
	INNER JOIN dbo.BudgetType ON dbo.BudgetCategories.BudgetTypeID = dbo.BudgetType.BudgetTypeID
	LEFT JOIN dbo.AuthorityRequestFinals ON dbo.AuthorityRequests.AuthorityRequestID = dbo.AuthorityRequestFinals.AuthorityRequestID 
	LEFT JOIN Expenditures ON Expenditures.AuthorityRequestID = dbo.AuthorityRequests.AuthorityRequestID
GO
PRINT N'Altering [dbo].[BudgetProjectCostView]...';


GO


CREATE view [dbo].[BudgetProjectCostView] as

with AllLocations as (
	select ProjectCostId, LocationName 
	from BudgetProjectLocations bpl
	join BudgetProjectAccounts bpa on bpl.locationid = bpa.locationid
	join budgetProjectCostAllocations bpca on bpca.accountid = bpa.accountid
	group by projectCostId, LocationName 
), singleLocations as (
	select ProjectCostId, max(locationname) as Location
	from AllLocations 
	group by ProjectCostID
	having count(1) = 1
), multipleLocations as (
	select ProjectCostId, 'Various' as Location 
	from AllLocations 
	group by ProjectCostID
	having count(1) > 1
), locations as (
	select ProjectCostId, Location 
	from singleLocations
	union
	select ProjectCostId, Location 
	from multipleLocations
), AllAccounts as (
	Select ProjectCostId, GLAccountType
	from BudgetProjectAccounts bpa 
	join budgetProjectCostAllocations bpca on bpca.accountid = bpa.accountid
	group by projectCostId, GLAccountType
), singleAccounts as (
	select ProjectCostId, max(GLAccountType) as GLAccountType
	from AllAccounts
	group by ProjectCostID
	having count(1) = 1
), multipleAccounts as (
	select ProjectCostId, 'Various' as GLAccountType
	from AllAccounts
	group by ProjectCostID
	having count(1) > 1
), Accounts as (
	select ProjectCostId, GLAccountType 
	from singleAccounts
	union
	select ProjectCostId, GLAccountType
	from multipleAccounts
), TransfersIn as (
	select ToProjectCostId as ID, Amount 
	from budgetTransfers where approvedDate is not null
), TransfersOut as (
	select FromProjectCostId As ID, Amount 
	from budgetTransfers where approvedDate is not null
), Transfers as (
	select ProjectCostID, sum(isnull(tin.Amount,0)) - sum(isnull(tout.Amount,0)) as TransferAmount
	from BudgetProjectCosts
	left join TransfersIn tin on ProjectCostID = tin.ID
	left join TransfersOut tout on ProjectCostID = tout.ID
	group by ProjectCostID
), ApprovedAfes as (
	SELECT 
		dbo.BudgetProjectCosts.ProjectCostID, 
		sum( isnull(dbo.AuthorityRequestExpenditures.Cost,0)) as AfeTotal
	FROM dbo.BudgetProjectCosts
	JOIN dbo.AuthorityRequests  ON dbo.AuthorityRequests.BudgetProjectCostID = dbo.BudgetProjectCosts.ProjectCostID
	JOIN dbo.AuthorityRequestFinals ON dbo.AuthorityRequests.AuthorityRequestID = dbo.AuthorityRequestFinals.AuthorityRequestID AND NOT (dbo.AuthorityRequestFinals.ApprovedDate IS NULL)
	JOIN dbo.AuthorityRequestExpenditures ON dbo.AuthorityRequestFinals.AuthorityRequestID = dbo.AuthorityRequestExpenditures.AuthorityRequestID  AND NOT (dbo.AuthorityRequestFinals.ApprovedDate IS NULL)
	group by dbo.BudgetProjectCosts.ProjectCostID
), RemainingBalances as (
	SELECT 
		dbo.BudgetProjectCosts.ProjectCostID, 
		sum( isnull(AfeTotal,0)) as AfeTotal,
		sum(TransferAmount) as TransferAmount,
		sum(dbo.BudgetProjectCosts.ApprovedBudget) as WorkingBudget,
		sum(dbo.BudgetProjectCosts.ApprovedBudget)  - sum( isnull(AfeTotal,0)) as RemainingBalance
	FROM dbo.BudgetProjectCosts
	join Transfers t on t.ProjectCostID = budgetprojectCosts.ProjectCostID
	left join approvedafes aa on aa.projectcostid = t.ProjectCostID
	
	group by dbo.BudgetProjectCosts.ProjectCostID
)

select 
	bpc.ProjectCostID,
	bc.CategoryID,
	bc.BudgetTypeID,
	BudgetYear, 
	AllocatedBudget, 
	ProjectedBudget, 
	ApprovedBudget - transferamount as ApprovedBudget, 
	TransferAmount,
	WorkingBudget,
	AFETotal,
	isnull(RemainingBalance, 0) as RemainingBalance,
	bp.ProjectName, 
	bp.ProjectID,
	bt.Name as BudgetType, 
	bc.categoryDescription as Category, 
	ProjectManager, 
	ProjectManager as ProjectManagerID, 
	GLAccountType,
	Location, 
	CreatedOn,
	IsSubmitted,
	Status = case
				when isnull(approvedbudget,0) > 0 then 'Approved'
				when createdon is null then 'Open'
				when IsSubmitted = 0 then 'Pending'
				else 'Submitted'
			 end
from budgetProjectCosts bpc
join BudgetProjects bp on bp.projectid = bpc.projectid
join BudgetCategories bc on bc.CategoryID = bp.CategoryID
join BudgetType bt on bt.BudgetTypeID = bc.budgettypeid
left join BudgetProjectJustifications bpj on bpc.ProjectCostID = bpj.projectcostid
left join locations on bpc.ProjectCostID = locations.ProjectCostID
left join accounts on bpc.ProjectCostID = accounts.ProjectCostID
left join RemainingBalances rb on bpc.ProjectCostID = rb.ProjectCostID
GO
PRINT N'Creating [dbo].[SupplementableRequests]...';



/****** Object:  View [dbo].[SupplementableRequests]    Script Date: 11/25/2015 2:10:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[SupplementableRequests] as
with PendingRequests as
(
		select ar.SupplementAFE 
		from AuthorityRequests ar left join AuthorityRequestFinals arf on ar.AuthorityRequestID = arf.AuthorityRequestID
		where arf.AuthorityRequestID is null
),
Highest as
(
		select AFENumber, max(SupplementNumber) as supplementable from AuthorityRequestFinals
		group by AFENumber
),
MyApprovedRequests as 
(
		select 
			arf.AuthorityRequestID, 
			ProjectManagerID as UserId, 
			str(arf.AFENumber) + ' - ' +  RequestTitle as RequestTitle, 
			arf.AFENumber 
		from BudgetProjectCostView bpcv
		join AuthorityRequests ar on bpcv.ProjectCostID = ar.BudgetProjectCostID
		join AuthorityRequestFinals arf on arf.AuthorityRequestID = ar.AuthorityRequestID
		join Highest on Highest.AFENumber = arf.AFENumber and Highest.supplementable = arf.SupplementNumber
		left join PendingRequests pr on pr.SupplementAFE = arf.AFENumber
		where pr.SupplementAFE is null
)
select * from MyApprovedRequests

GO



GO
PRINT N'Creating [dbo].[AfeHistoryView]...';


GO
CREATE view dbo.AfeHistoryView as
with afeLocationtypes as (
	select ar.authorityRequestid, arlt.name
	from authorityrequests ar
	join authorityrequestlocationtypes arlt on ar.locationTypeId = arlt.locationTypeId
	join authorityrequestFinals arf on ar.authorityRequestid = arf.authorityRequestid
)
, afeSpecificLocations as (
	select authorityRequestID, costcentercode as description from authorityrequestlocations arl
	join costcenters cc on cc.costcenterid = arl.costcenterid
)
, AFELocations as (
Select distinct ST2.authorityRequestid, 
    substring(
        (
            Select ',' + convert(varchar(100),ST1.Description)  AS [text()]
            From afeSpecificLocations ST1
            Where ST1.authorityRequestid = ST2.authorityRequestid
            ORDER BY ST1.Description
            For XML PATH ('')
        ), 2, 1000) Locations
From afeSpecificLocations ST2)
, TransfersIn as (
	select ToProjectCostId as ProjectCostID, Amount, ApprovedDate, -100000-transferid as ID
	from budgetTransfers where approvedDate is not null
), TransfersOut as (
	select FromProjectCostId As ProjectCostID, -Amount as amount, ApprovedDate, -transferid As ID
	from budgetTransfers where approvedDate is not null
), ApprovedAfes as (
	SELECT 
		ar.AuthorityRequestID as ID,
		dbo.BudgetProjectCosts.ProjectCostID, 
		ar.Description,
		arf.ApprovedDate,
		arf.AFENumber,
		arf.SupplementNumber,
		sum( isnull(dbo.AuthorityRequestExpenditures.Cost,0)) as Amount,
		case when al.Locations is null then alt.name else al.Locations end as Location
	FROM dbo.BudgetProjectCosts
	JOIN dbo.AuthorityRequests ar  ON ar.BudgetProjectCostID = dbo.BudgetProjectCosts.ProjectCostID
	join AfeLocationTypes alt on alt.authorityRequestid = ar.authorityRequestid
	JOIN dbo.AuthorityRequestFinals arf ON ar.AuthorityRequestID = arf.AuthorityRequestID AND NOT (arf.ApprovedDate IS NULL)
	JOIN dbo.AuthorityRequestExpenditures ON arf.AuthorityRequestID = dbo.AuthorityRequestExpenditures.AuthorityRequestID  AND NOT (arf.ApprovedDate IS NULL)
	left join afespecificLocations asl on asl.authorityRequestid = ar.authorityRequestid
	left join afelocations al on al.authorityRequestid = ar.authorityRequestid
	group by ar.AuthorityRequestID, dbo.BudgetProjectCosts.ProjectCostID, ar.description, arf.ApprovedDate, arf.afenumber, arf.supplementNumber, al.Locations, alt.name
), Final as (
select * from approvedafes
union select id, projectcostid, 'Transfer', approvedDate, null, null, amount,null from transfersin
union select id, projectcostid, 'Transfer', approvedDate, null, null, amount,null from transfersout
union select 
	-2000000 - projectcostid, 
	projectcostid, 
	'Initial', 
	dateadd(year, budgetprojectcosts.budgetyear-datepart(year, getdate()),  dateadd(month, -datepart(month, getdate()), dateadd(day, - datepart(day, getdate()),getdate()))) ,
	null, 
	null, 
	approvedbudget, 
	null 
	from budgetprojectcosts where projectcostid in (select projectcostid from ApprovedAfes)
)
select isnull(ID,0) as ID, ProjectCostID, Description, ApprovedDate, AFENumber, SupplementNumber, Amount, Location from final
GO
PRINT N'Creating [dbo].[ClearBudgetTable]...';


GO
CREATE PROCEDURE [dbo].[ClearBudgetTable]
AS
BEGIN
/*
 Expl Return Type: List<ExplString>

	select 'union select ''' + name + ':' + ''' + ltrim(str(count(1))) from ' + name from sysobjects where type = 'u' and name like '%budget%' order by 1
	select 'delete ' + name from sysobjects where type = 'u' and name like 'budget%' order by 1


*/

	SET NOCOUNT ON;

delete authorityrequests
delete authorityrequestlocationTypes
delete authoritytypes
delete BudgetProjectAccounts
delete BudgetProjectCostAllocations
delete BudgetProjectJustifications
delete BudgetProjectCosts
delete BudgetProjectJustificationFiles
delete BudgetProjectLocations
delete BudgetProjects
delete BudgetTransfers
delete BudgetCategories

DBCC CHECKIDENT ('AuthorityRequests', RESEED, 0);
DBCC CHECKIDENT ('AuthorityRequestLocationTypes', RESEED, 0);
DBCC CHECKIDENT ('AuthorityTypes', RESEED, 0);
DBCC CHECKIDENT ('BudgetProjectAccounts', RESEED, 0);
DBCC CHECKIDENT ('BudgetProjectCostAllocations', RESEED, 0);
DBCC CHECKIDENT ('BudgetProjectCosts', RESEED, 0);
DBCC CHECKIDENT ('BudgetProjectJustificationFiles', RESEED, 0);
DBCC CHECKIDENT ('BudgetProjectLocations', RESEED, 0);
DBCC CHECKIDENT ('BudgetProjects', RESEED, 0);
DBCC CHECKIDENT ('BudgetTransfers', RESEED, 0);
DBCC CHECKIDENT ('BudgetCategories', RESEED, 0);


select 'BudgetCategories:' + ltrim(str(count(1))) as TheString from BudgetCategories
union select 'BudgetProjectAccounts:' + ltrim(str(count(1))) from BudgetProjectAccounts
union select 'BudgetProjectCostAllocations:' + ltrim(str(count(1))) from BudgetProjectCostAllocations
union select 'BudgetProjectCosts:' + ltrim(str(count(1))) from BudgetProjectCosts
union select 'BudgetProjectJustificationFiles:' + ltrim(str(count(1))) from BudgetProjectJustificationFiles
union select 'BudgetProjectJustifications:' + ltrim(str(count(1))) from BudgetProjectJustifications
union select 'BudgetProjectLocations:' + ltrim(str(count(1))) from BudgetProjectLocations
union select 'BudgetProjects:' + ltrim(str(count(1))) from BudgetProjects
union select 'BudgetTransfers:' + ltrim(str(count(1))) from BudgetTransfers
union select 'AuthorityRequestLocationTypes:' + ltrim(str(count(1))) from AuthorityRequestLocationTypes
union select 'AuthorityTypes:' + ltrim(str(count(1))) from AuthorityTypes


	END
GO
PRINT N'Update complete.';


GO
