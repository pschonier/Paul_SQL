SELECT TicketID
, InvoiceNumber
, InvoiceDate
, PeriodOfService
, 'Transportation' InvoiceType
, CAST(StartDate AS VARCHAR) startdate
, Shipper
, s.Name as ShipperName
, ProductCode
, p.name ProductName
, Cycle
, SubCycle
, Origin
, o.name as OriginName
, DestinationGroup
, dest.Name as DestName
, TicketNumber
, GrossVolume
, CASE WHEN (AdjustedRate > 0) THEN AdjustedRate ELSE TariffRate END Rate
, LineAmount, BillTo
, id.ContractCode
, TariffNumber
FROM TransportationInvoices.dbo.InvoiceHeaders ih INNER JOIN TransportationInvoices.dbo.InvoiceDetails id ON id.InvoiceID = ih.InvoiceID
INNER JOIN ProductMovement.dbo.Destinations dest ON dest.ConnectionCode = id.Destination
inner join ProductMovement.dbo.Origins o on o.OriginCode = id.origin
inner join accounting.dbo.products p on p.Product = id.ProductCode
inner join ProductMovement.dbo.Shippers s on s.ShipperCode = ih.Shipper
WHERE
PeriodOfService LIKE cast(datepart(m,getdate()) -1 as varchar)+'%'+cast(datepart(yy,dateadd(m,-1,getdate())) as varchar) +'%'


--select top 100 * from TransportationInvoices.dbo.InvoiceHeaders
