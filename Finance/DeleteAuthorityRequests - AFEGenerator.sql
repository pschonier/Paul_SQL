SELECT ProjectID FROM BudgetProjects WHERE ProjectName LIKE '%%' --Find project ID of request you want deleted

DELETE
  FROM [Accounting].[dbo].[AuthorityRequestApprovals] WHERE AuthorityRequestID = 297 -- Delete Request Approvals

Delete
  FROM [Accounting].[dbo].[AuthorityRequests] WHERE AuthorityRequestID = 297 -- Delete Requests




