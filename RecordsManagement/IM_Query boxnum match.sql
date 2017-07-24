SELECT m.[SKP Box Nbr] AS IM_BoxNum, m.[Carton Status] AS IM_CartonStatus, m.[Major Description] AS IM_MajorDescription, m.[Minor Description] AS IM_MinorDescription, v.BoxLocation, v.BoxStatus, v.IMBoxNumber
,REPLACE(REPLACE(REPLACE(REPLACE(cast(v.[Description] as nvarchar(max)), CHAR(13) + CHAR(10), ' ... '), 
			CHAR(10) + CHAR(13), ' ... '), CHAR(13), ' '), CHAR(10), ' ... ') AS [Description], v.DepartmentName, v.ExplBoxNumber, v.ExplFileNumber, v.BoxStatusDate, v.BoxLocationDate, v.RetentionID, m.*
FROM BoxesAndFoldersTotalView v
LEFT OUTER JOIN tempdb.dbo.IronMountain m ON CAST(CAST([skp box nbr]AS BIGINT) AS NVARCHAR) = v.ImBoxNumber


SELECT * FROM BoxesAndFoldersTotalView v
SELECT * FROM tempdb.dbo.IronMountain

