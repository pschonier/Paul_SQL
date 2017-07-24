SELECT Shipper, Product, Origin, meterName AS Meter, Location, netVol, custody, receiptDelivery, connectionCode,  DATEPART(YEAR, DATEADD(SECOND, endTime,'1970-1-1')) AS [Year] 
,  DATEPART(QUARTER, DATEADD(SECOND, endTime,'1970-1-1')) AS [Quarter], * FROM dbo.tbl_ticket WHERE DATEADD(SECOND, endTime,'1970-1-1') > '2014-1-1' 
ORDER BY DATEPART(YEAR, DATEADD(SECOND, endTime,'1970-1-1')), DATEPART(QUARTER, DATEADD(SECOND, endTime,'1970-1-1')) 
