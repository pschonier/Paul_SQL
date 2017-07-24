USE [Accounting]
GO

ALTER TABLE [dbo].[AuthorityRequestExpenditures]  WITH CHECK ADD  CONSTRAINT [CK_COSTNONEGATIVEORIG] CHECK  (([Version]=(0) AND [cost]>(0) OR [Version]<>(0) AND [cost]>(-999999999)))
GO

ALTER TABLE [dbo].[AuthorityRequestExpenditures] CHECK CONSTRAINT [CK_COSTNONEGATIVEORIG]
GO


