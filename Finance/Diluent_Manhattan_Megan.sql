SELECT TOP 1000  volume, inv.GrossVolume, shipper, inv.GrossVolume* CASE WHEN inv.AdjustedRate > 0 THEN inv.AdjustedRate ELSE inv.TariffRate END AS revenue, * FROM explorer.dbo.transactions t 
join [Accounting].[dbo].[InvoiceDetails] inv on t.ticket_id = inv.ticketid
LEFT OUTER JOIN products p ON p.Product = t.Product
LEFT OUTER JOIN dbo.TransactionTypes tt ON tt.TransactionType = t.TransactionType
WHERE p.Product = '1B' AND t.Shipper IN ('AMO', 'BZA', 'CEV', 'HUS', 'VTL')
AND t.EndDate > '2016-4-1' AND t.EndDate < '2017-5-1' AND t.ConnectionCode = 'MN1'
ORDER BY t.EndDate DESC


--TheBobbinTater3#


SELECT TOP 1000 t.ConnectionPoint, t.EndDate, Shipper, product, Volume FROM dbo.Transactions t WHERE t.TransactionType = 3 and (BatchID LIKE '%HUS%' OR BatchID LIKE '%VTL%') AND t.EndDate > '2017-4-1' AND t.EndDate < '2017-5-1' 
ORDER BY t.EndDate DESC


SELECT TOP 1000 * FROM dbo.Transactions t WHERE BatchID  LIKE '%VTL%' ORDER BY t.EndDate DESC




