BEGIN TRAN;
INSERT  INTO [Administration].[dbo].[Games]
        ( [TeamId] ,
          [GameDate] ,
          [GameTime] ,
          [Opponent] ,
          [Special]
        )
        SELECT  1 ,
                [Date]-- CONVERT(DATETIME, LEFT(gamedate,11))
                ,
                CAST([time] AS TIME) --gamedate+DATEADD(HOUR,19,GameDate)--CONVERT(DATETIME, LEFT(gamedate,11)) + CAST(RIGHT(RTRIM(gametime), 8) AS DATETIME)
                ,
                [Opponent] ,
                0--CASE [Special] WHEN ' False' THEN 0 ELSE 1 END 
        FROM    tempdb.dbo.katimport;
ROLLBACK TRAN;

	   --date and time
BEGIN TRAN;
UPDATE  Administration.dbo.Games
SET     GameTime = ( GameDate + GameTime ) - '1900-1-1'
WHERE   YEAR(GameDate) = 2017
        AND TeamId = 1;
ROLLBACK TRAN;

