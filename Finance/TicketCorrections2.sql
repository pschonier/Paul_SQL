/* *******************************************************
AAL
******************************************************* */
UPDATE InvoiceDetails 
SET TariffRate = 1.6140, LineAmount = 1388.04
WHERE TicketNumber = 'DF-603'
AND YEAR( EndDate ) = 2016

UPDATE InvoiceDetails 
SET TariffRate = 1.6140, LineAmount = 38154.96
WHERE TicketNumber = 'DF-604'
AND YEAR( EndDate ) = 2016

/* *******************************************************
HUS
******************************************************* */
UPDATE InvoiceDetails 
SET TariffRate = 2.4030, LineAmount = 74122.94
WHERE TicketNumber = 'IW-449'
AND YEAR( EndDate ) = 2016

UPDATE InvoiceDetails 
SET TariffRate = 2.4030, LineAmount = 1819.07
WHERE TicketNumber = 'IW-450'
AND YEAR( EndDate ) = 2016

UPDATE InvoiceDetails 
SET TariffRate = 2.4030, LineAmount = 66125.75
WHERE TicketNumber = 'IW-456'
AND YEAR( EndDate ) = 2016

UPDATE InvoiceDetails 
SET TariffRate = 2.4030, LineAmount = 116507.05
WHERE TicketNumber = 'IW-457'
AND YEAR( EndDate ) = 2016

UPDATE InvoiceDetails 
SET TariffRate = 2.4030, LineAmount = 122555.40
WHERE TicketNumber = 'IW-462'
AND YEAR( EndDate ) = 2016

UPDATE InvoiceDetails 
SET TariffRate = 2.4030, LineAmount = 87387.50
WHERE TicketNumber = 'IW-472'
AND YEAR( EndDate ) = 2016

UPDATE InvoiceDetails 
SET TariffRate = 2.4030, LineAmount = 96449.21
WHERE TicketNumber = 'IW-473'
AND YEAR( EndDate ) = 2016

/* *******************************************************
QTC
******************************************************* */

BEGIN TRAN
UPDATE InvoiceDetails 
SET TariffRate = 0.1820, LineAmount = 1820
WHERE TicketNumber = 'SL-71'
AND YEAR( EndDate ) = 2017
ROLLBACK TRAN

BEGIN TRAN
DECLARE @InvoiceID INT = (
						 SELECT		InvoiceID
						 FROM		InvoiceHeaders
						 WHERE		PeriodOfService = '1/16/2017 TO 1/31/2017'
						 AND		Shipper = 'QTC'
						 AND		BillTo = 'QTC'
						 )

DECLARE @TicketID [int]; SET @TicketID = 1329444
DECLARE @TicketNumber [varchar](10); SET @TicketNumber = 'GT-3223'
DECLARE @ProductCode [varchar](3); SET @ProductCode = '4D'
DECLARE @Origin [varchar](3); SET @Origin = 'P01'
DECLARE @Destination [varchar](3); SET @Destination = 'GT9'
DECLARE @StartDate [DateTime]; SET @StartDate =  '2016-11-10 23:12:33.000'
DECLARE @EndDate [DateTime]; SET @EndDate =  '2016-11-10 23:59:59.000'
DECLARE @Cycle [int]; SET @Cycle = 61
DECLARE @SubCycle [int]; SET @SubCycle = 2
DECLARE @GrossVolume [int]; SET @GrossVolume = -4983
DECLARE @ContractCode [int]; SET @ContractCode = 0
DECLARE @TariffNumber [int]; SET @TariffNumber= 143
DECLARE @TariffRate [decimal](6,4); SET @TariffRate = 2.0130
DECLARE @TariffRuleID [int]; SET @TariffRuleID = 1
DECLARE @AdjustedVolume [int]; SET @AdjustedVolume = 0
DECLARE @AdjustedRate [decimal](6,4); SET @AdjustedRate = 0.000
DECLARE @LineAmount [money]; SET @LineAmount = -10030.78
DECLARE @WholeTicket [bit]; SET @WholeTicket = 1
DECLARE @SystemGenerated [bit]; SET @SystemGenerated = 0

--INSERT INTO [dbo].[InvoiceDetails] ([InvoiceID], [TicketID], [TicketNumber], [ProductCode], [Origin], [Destination], [StartDate], [EndDate], [Cycle], [SubCycle], [GrossVolume], [ContractCode], [TariffNumber], [TariffRate], [TariffRuleID], [AdjustedVolume], [AdjustedRate], [LineAmount], [WholeTicket], [SystemGenerated]) 
--VALUES ( @InvoiceID, @TicketID, @TicketNumber, @ProductCode, @Origin, @Destination, @StartDate, @EndDate, @Cycle, @SubCycle, @GrossVolume, @ContractCode, @TariffNumber, @TariffRate, @TariffRuleID, @AdjustedVolume, @AdjustedRate, @LineAmount, @WholeTicket, @SystemGenerated ) 

SET @TicketID = 1329444
SET @TicketNumber = 'GT-3484BC'
SET @ProductCode = '4D'
SET @Origin = 'P01'
SET @Destination = 'GT9'
SET @StartDate =  '2017-1-16 23:59:59.000'
SET @EndDate =  '2017-1-17 00:40:18.000'
SET @Cycle = 68
SET @SubCycle = 1
SET @GrossVolume = 0
SET @ContractCode = 0
SET @TariffNumber= 143
SET @TariffRate = 2.0130
SET @TariffRuleID = 1
SET @AdjustedVolume = 0
SET @AdjustedRate = 0.000
SET @LineAmount = 37216.97
SET @WholeTicket = 1
SET @SystemGenerated = 0
update dbo.InvoiceDetails SET LineAmount = LineAmount * -1 WHERE TicketID = 1329444

INSERT INTO [dbo].[InvoiceDetails] ([InvoiceID], [TicketID], [TicketNumber], [ProductCode], [Origin], [Destination], [StartDate], [EndDate], [Cycle], [SubCycle], [GrossVolume], [ContractCode], [TariffNumber], [TariffRate], [TariffRuleID], [AdjustedVolume], [AdjustedRate], [LineAmount], [WholeTicket], [SystemGenerated]) 
VALUES ( @InvoiceID, @TicketID, @TicketNumber, @ProductCode, @Origin, @Destination, @StartDate, @EndDate, @Cycle, @SubCycle, @GrossVolume, @ContractCode, @TariffNumber, @TariffRate, @TariffRuleID, @AdjustedVolume, @AdjustedRate, @LineAmount, @WholeTicket, @SystemGenerated ) 
ROLLBACK TRAN
SET @InvoiceID = (
				 SELECT		InvoiceID
				 FROM		InvoiceHeaders
				 WHERE		PeriodOfService = '11/1/2016 TO 11/15/2016'
				 AND		Shipper = 'QTC'
				 AND		BillTo = 'WPL'
				 )

UPDATE		InvoiceDetails
SET			TariffRate = 2.0130, LineAmount = 27958.09, InvoiceID = @InvoiceID
WHERE		TicketNumber = 'PR-146'
AND			YEAR( EndDate ) = 2016

UPDATE		InvoiceDetails
SET			TariffRate = 2.0130, LineAmount = 10693.52, InvoiceID = @InvoiceID
WHERE		TicketNumber = 'PR-147'
AND			YEAR( EndDate ) = 2016

SELECT * FROM dbo.InvoiceDetails d
JOIN dbo.InvoiceHeaders i ON i.InvoiceID = d.InvoiceID
WHERE TicketNumber IN ('PR-6','PR-8', 'PR-7') AND PeriodOfService = '1/16/2017 TO 1/31/2017' --GT-3484BC

SELECT * FROM dbo.InvoiceDetails d
JOIN dbo.InvoiceHeaders i ON i.InvoiceID = d.InvoiceID
WHERE d.invoiceID = 41860 AND PeriodOfService = '1/16/2017 TO 1/31/2017'

BEGIN TRAN
UPDATE dbo.InvoiceDetails SET LineAmount = 37497.59 WHERE DetailID = 524394
ROLLBACK TRAN

/* *******************************************************
MAC
******************************************************* */
DECLARE @Shipper [varchar](3); SET @Shipper = 'MAC'
DECLARE @InvoiceDate [date]; SET @InvoiceDate = '2016-12-06'
DECLARE @PeriodOfService [varchar](50); SET @PeriodOfService = '11/16/2016 TO 11/30/2016'
DECLARE @BillTo [varchar](3); SET @BillTo = 'MAC'
DECLARE @CurrentInvoiceId [int]
DECLARE @NewInvoiceId [int]

SET @CurrentInvoiceID = ( 
						SELECT		InvoiceID
						FROM		InvoiceHeaders
						WHERE		Shipper = @Shipper
						AND			PeriodOfService = @PeriodOfService
						AND			BillTo = @BillTo
						)
						
SELECT	InvoiceID
FROM	InvoiceHeaders
WHERE	Shipper = @Shipper
AND		PeriodOfService = @PeriodOfService
AND		BillTo = @BillTo
IF		@@ROWCOUNT = 1
BEGIN
	INSERT INTO [dbo].[InvoiceHeaders] ([InvoiceTypeID], [InvoiceNumber], [Shipper], [InvoiceDate], [PeriodOfService], [BillTo], [TransmittedToGP], [AutoGenerated]) VALUES ( '1', 'Pending', @Shipper, @InvoiceDate, @PeriodOfService, @BillTo, '0', '1' )
	SET @NewInvoiceId = CAST( SCOPE_IDENTITY() AS INT )

	UPDATE		InvoiceDetails
	SET			InvoiceID = @NewInvoiceID
	WHERE		InvoiceID = @CurrentInvoiceID
	AND			ProductCode IN ( 
								SELECT		ProductCode
								FROM		ProductMovement.dbo.Products
								WHERE		HasSpecialRate = 1
								)
END