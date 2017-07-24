


SELECT  DATENAME(MONTH,
                 CONCAT(si.SettlementYear, '-', si.SettlementMonth, '-', '1')) AS [Month] ,
        *
FROM    Explorer.dbo.SettlementInvoices si
WHERE   si.SettlementYear = 2016
        AND si.ProductCode = '1B'
ORDER BY SettlementYear DESC ,
        SettlementMonth DESC;



SELECT  DATENAME(MONTH, t.EndDate) AS [Month] ,
       isnull( CASE WHEN AdjustedRate > 0 THEN AdjustedRate
             ELSE TariffRate
        END, 0) AS RateFin ,
        ISNULL(t.Volume * CASE WHEN AdjustedRate > 0 THEN AdjustedRate
                        ELSE TariffRate
                   END , 0) AS AmtFin ,
        *
FROM    explorer.dbo.Transactions t
        LEFT OUTER JOIN Accounting.dbo.InvoiceDetails d ON d.TicketID = t.ticket_id
        JOIN explorer.dbo.TransactionTypes ty ON ty.TransactionType = t.TransactionType
WHERE   t.Product = '1B'
        AND DATEPART(YEAR,t.EndDate) = 2016
        AND t.TransactionType = 3
