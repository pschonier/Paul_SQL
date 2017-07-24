SELECT * FROM (SELECT  t.shipper AS ShipperCode ,
        c.short_desc AS ShipperName ,
        TicketID ,
        TicketNumber ,
        ProductCode ,
        Origin ,
        Destination ,
        StartDate ,
        EndDate ,
        Cycle ,
        SubCycle ,
        GrossVolume ,
        ContractCode ,
        TariffNumber ,
        TariffRate ,
        TariffRuleID ,
        AdjustedVolume ,
        AdjustedRate ,
        LineAmount ,
        WholeTicket ,
        SystemGenerated
FROM    [Accounting].[dbo].[InvoiceDetails] i
        JOIN T4SQL.dbo.tickets t ON t.ticket_id = i.TicketID
        JOIN [T4SQL].[dbo].[sis_companies] c ON c.company = t.shipper

WHERE --cycle BETWEEN 61 AND 65 AND 
i.EndDate BETWEEN '2-1-2016' AND '3-1-2016' --OR i.EndDate BETWEEN '2-1-2014' AND '3-1-2014') --
UNION ALL
SELECT  t.shipper AS ShipperCode ,
        c.short_desc AS ShipperName ,
        TicketID ,
        TicketNumber ,
        ProductCode ,
        Origin ,
        Destination ,
        StartDate ,
        EndDate ,
        Cycle ,
        SubCycle ,
        GrossVolume ,
        ContractCode ,
        TariffNumber ,
        TariffRate ,
        TariffRuleID ,
        AdjustedVolume ,
        AdjustedRate ,
        LineAmount ,
        WholeTicket ,
        SystemGenerated
FROM    [Accounting].[dbo].[InvoiceDetails] i
        JOIN T4SQL.dbo.tickets t ON t.ticket_id = i.TicketID
        JOIN [T4SQL].[dbo].[sis_companies] c ON c.company = t.shipper

WHERE --cycle BETWEEN 61 AND 65 AND 
i.EndDate BETWEEN '10-1-2014' AND '11-1-2014' --OR i.EndDate BETWEEN '2-1-2014' AND '3-1-2014') --
UNION ALL 
SELECT  t.shipper AS ShipperCode ,
        c.short_desc AS ShipperName ,
        TicketID ,
        TicketNumber ,
        ProductCode ,
        Origin ,
        Destination ,
        StartDate ,
        EndDate ,
        Cycle ,
        SubCycle ,
        GrossVolume ,
        ContractCode ,
        TariffNumber ,
        TariffRate ,
        TariffRuleID ,
        AdjustedVolume ,
        AdjustedRate ,
        LineAmount ,
        WholeTicket ,
        SystemGenerated
FROM    [Accounting].[dbo].[InvoiceDetailsHistorical] i
        JOIN T4SQL.dbo.tickets t ON t.ticket_id = i.TicketID
        JOIN [T4SQL].[dbo].[sis_companies] c ON c.company = t.shipper
		WHERE  i.EndDate BETWEEN '5-1-2013' AND '6-1-2013' ) a ORDER BY a.EndDate DESC
		--AND 
		--i.Cycle BETWEEN 61 AND 65



		--SELECT * FROM Explorer.dbo.transactions WHERE Cycle IN ( '65', '64','63', '62', '61') AND EndDate BETWEEN '10-1-2014' AND '11-1-2014'