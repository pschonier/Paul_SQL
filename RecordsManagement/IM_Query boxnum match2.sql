SELECT DISTINCT
        m.[SKP Box Nbr] AS IM_BoxNum ,
        m.[Carton Status] AS IM_CartonStatus ,
        ( SELECT TOP 1
                    vw.BoxStatus
          FROM      dbo.BoxesAndFoldersTotalView vw
          WHERE     vw.IMBoxNumber = v.IMboxNumber
        ) AS EXPL_BoxStatus ,
        ( SELECT TOP 1
                    vw.BoxLocation
          FROM      dbo.BoxesAndFoldersTotalView vw
          WHERE     vw.IMBoxNumber = v.IMboxNumber
        ) AS EXPL_BoxLocation ,
        d.DepartmentName AS EXPL_DeptName ,
        m.[Department Name] AS IM_DeptName ,
        REPLACE(REPLACE(REPLACE(REPLACE(CAST(v.[Description] AS NVARCHAR(MAX)),
                                        CHAR(13) + CHAR(10), ' ... '),
                                CHAR(10) + CHAR(13), ' ... '), CHAR(13), ' '),
                CHAR(10), ' ... ') AS [EXPL_Description] ,
        m.[Major Description] AS IM_MajorDescription ,
        m.[Minor Description] AS IM_MinorDescription
--, v.BoxLocation AS EXPL_BoxLocation, v.BoxStatus AS EXPL_BoxStatus, v.IMBoxNumber AS EXPL_IMBoxNumber

			--, v.DepartmentName, v.ExplBoxNumber, v.ExplFileNumber, v.BoxStatusDate, v.BoxLocationDate, v.RetentionID
FROM    dbo.boxes v
        JOIN tempdb.dbo.IronMountain m ON CAST(CAST([skp box nbr] AS BIGINT) AS NVARCHAR) = v.ImBoxNumber
        LEFT OUTER JOIN dbo.departments d ON d.departmentID = v.departmentID;


SELECT  ISNUMERIC([customer box nbr]) ,
        *
FROM    BoxesAndFoldersTotalView v
        LEFT OUTER JOIN tempdb.dbo.IronMountain m ON CAST(CAST([skp box nbr] AS BIGINT) AS NVARCHAR) = v.ImBoxNumber
WHERE   ( v.ExplBoxNumber IS NOT NULL
          AND v.ExplBoxNumber != ''
        )
        AND ( v.ImBoxNumber IS NULL
              OR v.ImBoxNumber = ''
            )
        AND v.ExplBoxNumber != 'UNBOXED';
--SELECT * FROM tempdb.dbo.IronMountain

--status in iron mountain
--boxstatus or boxLocation 

SELECT  *
FROM    BoxesAndFoldersTotalView v;