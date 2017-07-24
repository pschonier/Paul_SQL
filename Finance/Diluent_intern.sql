SELECT  DATENAME(MONTH, t.EndDate) AS [Month] ,
       isnull( CASE WHEN AdjustedRate > 0 THEN AdjustedRate
             ELSE TariffRate
        END, 0) AS RateFin ,
        ISNULL(t.Volume * CASE WHEN AdjustedRate > 0 THEN AdjustedRate
                        ELSE TariffRate
                   END , 0) AS AmtFin ,
        *
FROM    dbo.Transactions t
        LEFT OUTER JOIN Accounting.dbo.InvoiceDetails d ON d.TicketID = t.ticket_id
        JOIN dbo.TransactionTypes ty ON ty.TransactionType = t.TransactionType
WHERE   t.Product = '1B'
        AND DATEPART(YEAR,t.EndDate) = 2016
        AND t.TransactionType = 3

--bv corrective or corrective only