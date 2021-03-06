SELECT sc.name +'.'+ ta.name TableName
,SUM(pa.rows) RowCnt
FROM sys.tables ta
INNER JOIN sys.partitions pa
ON pa.OBJECT_ID = ta.OBJECT_ID
INNER JOIN sys.schemas sc
ON ta.schema_id = sc.schema_id
WHERE ta.is_ms_shipped = 0 and sc.name +'.'+ ta.name = 'dbo.f_workorder' -- use schema+table ex: dbo.users
group by sc.name, ta.name
