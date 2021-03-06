DECLARE @PreviousMonthClosingDate DATETIME = '2016-09-30';
DECLARE @CurrentMonthOpeningDate DATETIME = '2016-10-01';

DECLARE @OpeningInventoryTransactionType INT = 1;
DECLARE @ClosingInventoryTransactionType INT = 4;
DECLARE @PKOrig INT = ( SELECT  MAX(ticket_id)
                        FROM    dbo.Transactions
                      ); 


INSERT  INTO dbo.Transactions
        ( ticket_id ,
          TransactionType ,
          StartDate ,
          StartTime ,
          EndDate ,
          EndTime ,
          Shipper ,
          Origin ,
          Product ,
          Cycle ,
          Sequence ,
          BatchSuffix ,
          Location ,
          ConnectionPoint ,
          SupplierConsignee ,
          TicketNumber ,
          Volume ,
          TankID ,
          WeightedGravity ,
          WeightedTemperature ,
          TariffNumber ,
          ContractCode ,
          CustodyFlag ,
          ProcessDateTime ,
          Facility ,
          ConnectionCode ,
          MeterNumber
        )
        SELECT  ( ROW_NUMBER() OVER ( ORDER BY StartDate ) ) + @PKOrig ,
                @OpeningInventoryTransactionType ,
                @CurrentMonthOpeningDate ,
                @CurrentMonthOpeningDate ,
                @CurrentMonthOpeningDate ,
                @CurrentMonthOpeningDate ,
                [Shipper] ,
                [Origin] ,
                [Product] ,
                [Cycle] ,
                [Sequence] ,
                [BatchSuffix] ,
                [Location] ,
                [ConnectionPoint] ,
                [SupplierConsignee] ,
                [TicketNumber] ,
                [Volume] ,
                [TankID] ,
                [WeightedGravity] ,
                [WeightedTemperature] ,
                [TariffNumber] ,
                [ContractCode] ,
                [CustodyFlag] ,
                GETDATE() ,
                [Facility] ,
                [ConnectionCode] ,
                [MeterNumber]
        FROM    [Explorer].[dbo].[Transactions]
        WHERE   StartDate = @PreviousMonthClosingDate
                AND TransactionType = 4;
  


UPDATE  PKList
SET     PKVal = ( SELECT    MAX(ticket_id)
                  FROM      Transactions
                ) + 1
WHERE   PKName = 'ticket_id';
  

  --sp_tis_prepare


