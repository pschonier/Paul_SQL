
USE [PPMS]
GO
CREATE NONCLUSTERED INDEX [<CustodyShipperLocation>]
ON [dbo].[tbl_ticket] ([custody],[receiptDelivery],[location],[shipper],[verify])
INCLUDE ([ticketId],[ticketPrefix],[ticketNumber],[startTime],[startOffset],[endTime],[endOffset],[netVol],[batchId],[product],[cycle],[origin],[connectionCode],[connectionCompany])
GO


CREATE NONCLUSTERED INDEX [<batchIDConnCode>]
ON [dbo].[tbl_ticket] ([batchId],[connectionCode])
INCLUDE ([connectionCompany])
GO




CREATE NONCLUSTERED INDEX [idx_ID] ON [dbo].[tbl_ticket]
(
	[ticketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

