/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 
      AVG([Price]) AS AvgLowPrice
      
	  ,s.Symbol
	  ,s.Description
  FROM [ProductPricing].[dbo].[SpotPrices] p 
  JOIN dbo.Symbol s ON s.SymbolId = p.SymbolId 
  
  WHERE s.SymbolId IN (48,84) AND p.PriceAggregate = 'l' AND p.PriceDate BETWEEN '2016-10-1' AND '2016-10-31'
  GROUP BY 	  s.Symbol
	  ,s.Description