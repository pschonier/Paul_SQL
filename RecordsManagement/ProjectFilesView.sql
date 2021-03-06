WITH x AS (
  SELECT CASE WHEN LEN(ExternalSystemKey) = 0 THEN '||||' ELSE ExternalSystemKey end AS piped
       , CharIndex('|', ISNULL(ExternalSystemKey, '-')) As first_pipe, FolderID
   FROM [Administration].[dbo].[FolderAssociations]
)
, y AS (
  SELECT piped
       , CAST(first_pipe AS BIGINT) AS first_pipe
       , CAST(CHARINDEX('|', piped, first_pipe + 1) AS BIGINT) As second_pipe, x.FolderID
       , SubString(piped, 0, first_pipe) As first_element
  FROM   x

)

, z AS (
  SELECT piped
       , first_pipe, y.FolderID
       , second_pipe, second_pipe - first_pipe AS diff
       , first_element 
       , SubString(piped, first_pipe  + 1, second_pipe - first_pipe - 1) As second_element
	   , SUBSTRING(piped, second_pipe+1,  CHARINDEX('|',piped,y.second_pipe+1) - y.second_pipe-1) AS third_element
	   , CHARINDEX('|',piped, CHARINDEX('|',piped,y.second_pipe+1)+1) AS fourthEnd
  FROM  y
)

SELECT DISTINCT fa.ExternalID AS ProjectNumber 
--,(SELECT description FROM folders f WHERE f.folderid = fa.folderID) AS Description
, z.first_element AS ProjectName
, z.second_element AS AFENumber
, z.third_element AS AssetType
FROM dbo.FolderAssociations fa
JOIN z ON z.FolderID = fa.FolderID 
