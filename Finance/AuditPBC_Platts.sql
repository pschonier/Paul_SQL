SELECT s.symbol, s.Description, sp.PriceDate, sp.Price, DATENAME(MONTH, pricedate) AS [Month], DATENAME(YEAR, pricedate) AS 'Year'
  FROM [ProductPricing].[dbo].[SpotPrices] sp 
  JOIN ProductPricing.dbo.Symbol s ON s.SymbolId = sp.SymbolId
  WHERE sp.PriceAggregate = 'l' AND sp.PriceDate BETWEEN '2015-12-30' AND '2017-1-4'
  ORDER BY symbol,sp.PriceDate



