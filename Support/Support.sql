


insert into [Expl_Support].[dbo].[SupportTrack] 
(     [type]
      ,[application]
      ,[description]
      ,[resolution]
      ,[CustName]
      ,[date_reported]
      ,[date_resolved]
      ,[technician])
Values(
'SQL' -- type
,'Dynamics' -- application name
,'Check batch posting failure' -- problem description
,'Follow instructions at  http://support.microsoft.com/kb/862654. Checklinks on the keys table isn’t terribly consequential. 
  Checklinks on a transaction table is a bigger deal and we would want to take a backup.' --Resolution
,'Tricia Baca' -- Customer name
,'2014-10-31'
,'2014-10-31'
,'Paul Schonier')

