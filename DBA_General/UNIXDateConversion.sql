
SELECT TOP 1000 

dateadd(ss, [startTime], '19700101') AS StartTime
,dateadd(ss, [endTime], '19700101') AS EndTime


  
,*
  FROM [PPMS].[dbo].[tbl_ticket]
  ORDER BY dateadd(ss, [startTime], '19700101') DESC
  