SELECT  *
FROM    ( SELECT    [ticketId] ,
                    [StartDateTime] ,
                    [EndDateTime] ,
                    [TicketNumber] ,
                    [Location] ,
                    [Volume] ,
                    [Product] ,
                    [Cycle] ,
                    [SubCycle] ,
                    [Origin] ,
                    [Shipper] ,
                    [DestinationCode] ,
                    [OriginCode] ,
                    [OriginCompany] ,
                    [DeliverCompany] ,
                    ROW_NUMBER() OVER ( PARTITION BY TicketNumber ORDER BY ticketId ASC ) AS 'Rank'
          FROM      [PPMS].[dbo].[vwInvoiceTickets]
        ) a
WHERE   a.Rank = 1
        AND DATEPART(YEAR, EndDateTime) = DATEPART(YEAR, GETDATE())
		AND TicketNumber = 'WT-311'
        AND a.TicketNumber NOT IN (
        SELECT  TicketNumber
        FROM    PPMS.dbo.vwInvoiceTickets
        WHERE   DATEPART(YEAR, EndDateTime) = DATEPART(YEAR, dateadd(m,-4,GETDATE())) AND originCode = DestinationCode
        GROUP BY TicketNumber
        HAVING  ( COUNT(*) = 2
                  AND SUM(Volume) = 0 
                ) );
			
  --SELECT * FROM dbo.vwInvoiceTickets WHERE OriginCode = DestinationCode
  
  --TicketNumber = 'AF-10187'
  --TICKET NUMBER = AF-10187, YEAR = 2009
  
  --TicketNumber = 'CL-13154' 

  --SELECT vw.ticketId ,
  --       vw.StartDateTime ,
  --       vw.EndDateTime ,
  --       vw.TicketNumber ,
  --       vw.Location ,
  --       vw.Volume ,
  --       vw.Product ,
  --       vw.Cycle ,
  --       vw.SubCycle ,
  --       vw.Origin ,
  --       vw.Shipper ,
  --       vw.DestinationCode ,
  --       vw.OriginCode ,
  --       vw.OriginCompany ,
  --       vw.DeliverCompany FROM ppms.dbo.vwInvoiceTickets vw where vw.TicketNumber = 'AD-144'



		-- SELECT vw.ticketNumber, SUM(vw.volume) FROM ppms.dbo.vwInvoiceTickets vw GROUP BY ticketNumber 