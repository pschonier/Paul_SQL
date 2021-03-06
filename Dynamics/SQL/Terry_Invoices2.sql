/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [RowID]
      ,[ticket_id]
      ,[InvoiceNumber]
      ,[InvoiceDate]
      ,[PeriodOfService]
      ,[InvoiceType]
      ,[StartDate]
      ,[Shipper]
      ,[Product]
      ,[Cycle]
      ,[SubCycle]
      ,[Origin]
      ,[Location]
      ,[ConnectionPoint]
      ,[TicketNumber]
      ,[Volume]
      ,[TariffRate]
      ,[LineAmount]
      ,[BillTo]
      ,[ContractCode]
      ,[TariffNumber]
      ,[WholeTicket]
      ,[Division]
      ,[BidRate]
      ,[TariffType]
      ,[Route]
      ,[AutoGenerated]
      ,[ExceptionRow]
  FROM [Explorer].[dbo].[Invoices]
where datepart(yy,startdate) = datepart(yy,dateadd(m,-1,getdate()))
and datepart(m,startdate) = datepart(m,dateadd(m,-1,getdate()))
