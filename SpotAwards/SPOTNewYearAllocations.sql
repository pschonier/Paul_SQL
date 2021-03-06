DECLARE @year INT;
SET @year = 2017;

BEGIN TRAN;
IF ( SELECT COUNT(*)
     FROM   dbo.SpotAllocationYear
     WHERE  Year = @year
   ) = 0
    INSERT  INTO dbo.SpotAllocationYear
            ( DepartmentId ,
              Year
            )
            SELECT  DepartmentId ,
                    @year AS Year
            FROM    dbo.SpotAllocationYear
            WHERE   Year = @year - 1; -- take all existing departments from previous year and create new year record
ELSE
    PRINT 'Year already in Table';
ROLLBACK TRAN;

BEGIN TRAN;
INSERT  INTO dbo.SpotAllocation
        ( LevelId ,
          SpotAllocationYearId ,
          AwardCount ,
          OriginalAwardCount
        ) --Create blank allocations
        SELECT  4 AS levelID ,
                SpotAllocationYearId ,
                0 ,
                0
        FROM    dbo.SpotAllocationYear
        WHERE   Year = @year;
ROLLBACK TRAN;

BEGIN TRAN;
UPDATE  dbo.SpotAllocation
SET     AwardCount = al.Amount ,
        OriginalAwardCount = al.Amount
FROM    dbo.SpotAllocation sa
        LEFT OUTER JOIN dbo.SpotAllocationYear sy ON sy.SpotAllocationYearId = sa.SpotAllocationYearId -- Populate allocations with spreadsheet based on manager name
        LEFT OUTER JOIN dbo.SpotDepartment sd ON sd.DepartmentId = sy.DepartmentId
        LEFT OUTER JOIN tempdb.dbo.SpotAllo al ON al.Manager = sd.ManagerName -- change extract upload name 
WHERE   sy.Year = @year;
ROLLBACK TRAN;

BEGIN TRAN
UPDATE dbo.SpotAllocation SET AwardCount = 0, OriginalAwardCount = 0 WHERE AwardCount IS NULL --set any non matching values to 0
ROLLBACK TRAN

----SELECT * FROM dbo.SpotAllocation
--SELECT * FROM dbo.SpotDepartment
--SELECT * FROM dbo.SpotAllocationYear

