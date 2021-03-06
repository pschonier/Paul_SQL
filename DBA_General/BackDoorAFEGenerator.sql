
declare @title varchar(100)
declare @description varchar(1000)
declare @requestId int
declare @afenumber int
declare @expenditureAmount decimal
declare @expenditureName varchar(100)

select @title = 'Tank 2404 Warranty Work', @description = 'Tank 2404 has a leaking pontoon.  The pontoon was last repaired by HMT and is still under warranty.  The tank will be taken out of service, cleaned and repair work to leaking pontoon performed.'
, @expenditureAmount = 100000, @expenditureName = 'Cleaning, Inspectors, Disposal and Labor'
INSERT [dbo].[AuthorityRequests] (
	[BudgetProjectCostID], 
	[CreateDate], 
	[CreateUser], 
	[EstimatedStartDate], 
	[EstimatedCompletionDate], 

	[AuthorityTypeID], 
	[SupplementAFE], 
	[SupplementNumber], 
	[RequestTitle], 
	[AltTitle], 

	[Description], 
	[AltDescription], 
	[Recommendation], 
	[RejectionReason], 
	[DateSubmitted], 

	[IsSubmitted], 
	[LocationTypeID], 
	[CostCenterID], 
	[RequestBeingSupplementedID])
VALUES (
		1001,											--
		CAST(N'2016-01-25' AS Date), 					--
		N'plasiter', 									--
		CAST(N'2016-01-25' AS Date), 					--
		CAST(N'2016-12-31' AS Date),					--
		
		 1, 											--
		 NULL, 											--
		 0, 											--
		 @title,										--
		 N'', 											--

		 @description, 									--
		 N'', 											--
		 N'', 											--
		 N'', 											--
		 CAST(N'2016-01-25 14:38:01.027' AS DateTime), 	--

		 1, 											--
		 1, 											--
		 NULL, 											--
		 NULL)											--
														--
select @requestId = scope_identity()

insert authorityrequestexpenditures (authorityRequestID, description, cost, version)
	select @requestID, @expenditureName, @expenditureAmount, 0


insert AuthorityRequestApprovals (AuthorityRequestID, UserID, Name, Title, Date)
	select @requestId, 'plasiter', 'Pamela Lasiter', 'Senior Accountant', getdate()

select * from AuthorityRequestFinals

select @afenumber = 700001 + convert(int, max(substring(ltrim(str(afenumber)),2,10))) from AuthorityRequestFinals

insert AuthorityRequestFinals (AFENumber, SupplementNumber, ApprovedDate, AuthorityRequestID, OpenDate, ClosedDate)
	select @afenumber, 0, getdate(), @requestId, getdate(), '12-31-2016'


select top 1 * from authorityrequests order by 1 desc
select top 1 * from authorityrequestexpenditures order by 1 desc
select top 1 * from authorityrequestapprovals order by 1 desc
select top 1 * from authorityrequestfinals order by 1 desc