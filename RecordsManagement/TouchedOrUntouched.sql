SELECT  'Touched' AS [Status] ,
        b.ImBoxNumber ,
        d.DepartmentName ,
        COUNT(1) AS FolderCount
FROM    dbo.Folders f
        JOIN dbo.Boxes b ON b.BoxID = f.BoxID
        LEFT OUTER JOIN dbo.Departments d ON d.DepartmentID = b.DepartmentID
WHERE   LEFT(b.ImBoxNumber, 1) != '1'
        AND f.ExplFileNumber IS NOT NULL
GROUP BY b.ImBoxNumber ,
        d.DepartmentName
HAVING  COUNT(1) > 0
UNION ALL
SELECT  'UnTouched' AS [Status] ,
        b.ImBoxNumber ,
        d.DepartmentName ,
        COUNT(1) AS FolderCount
FROM    dbo.Folders f
        JOIN dbo.Boxes b ON b.BoxID = f.BoxID
        LEFT OUTER JOIN dbo.Departments d ON d.DepartmentID = b.DepartmentID
WHERE   LEFT(b.ImBoxNumber, 1) != '1'
        AND f.FolderID NOT IN (
        SELECT  f.FolderID
        FROM    dbo.Folders f
                JOIN dbo.Boxes b ON b.BoxID = f.BoxID
                LEFT OUTER JOIN dbo.Departments d ON d.DepartmentID = b.DepartmentID
        WHERE   LEFT(b.ImBoxNumber, 1) != '1'
                AND f.ExplFileNumber IS NOT NULL
    )
GROUP BY b.ImBoxNumber ,
        d.DepartmentName
HAVING  COUNT(1) > 0;


SELECT  *
FROM    dbo.Folders f
        JOIN dbo.Boxes b ON b.BoxID = f.BoxID;


