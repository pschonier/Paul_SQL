
DECLARE @FutureIns TABLE
    (
      Area VARCHAR(255) ,
      Location VARCHAR(255) ,
      Latitude FLOAT ,
      longitude FLOAT ,
      Slot VARCHAR(120) ,
      Equip VARCHAR(185) ,
      ItemType VARCHAR(255) ,
      IntervalName VARCHAR(255) ,
      INTERVAL INT ,
      LastDate DATETIME ,
      NextDate DATETIME ,
      JobCode VARCHAR(250) ,
      JobDescript VARCHAR(255) ,
      WorkDescript VARCHAR(250) ,
      UserTypeCode VARCHAR(250) ,
      IntervalNum INT ,
      JobLibCode VARCHAR(50) ,
      GroupFlag VARCHAR(5) ,
      GroupDescript VARCHAR(300)
    );
DECLARE @CountInt INT = 0;
WHILE @CountInt < 12
    BEGIN
        INSERT  INTO @FutureIns
                ( Area ,
                  Location ,
                  Latitude ,
                  longitude ,
                  Slot ,
                  Equip ,
                  ItemType ,
                  IntervalName ,
                  INTERVAL ,
                  LastDate ,
                  NextDate ,
                  JobCode ,
                  JobDescript ,
                  WorkDescript ,
                  UserTypeCode ,
                  IntervalNum ,
                  JobLibCode ,
                  GroupFlag ,
                  GroupDescript
                )
                SELECT  f.fd_name ,
                        b.fb_name ,
                        b.fb_y_coordinate AS Latitude ,
                        b.fb_x_coordinate AS Longitude ,
                        '' AS slot ,
                        '' AS Equip ,
                        t.itemType_name ItemType ,
                        pe.interval_name ,
                        pe.pm_interval AS Interval ,
                        pe.pm_lastDate AS LastDate ,
                        CASE WHEN pe.interval_name = 'Month'
                             THEN DATEADD(MONTH, @CountInt * pe.pm_interval,
                                          pe.pm_nextDate)
                             WHEN pe.interval_name = 'Year'
                             THEN DATEADD(YEAR, @CountInt * pe.pm_interval,
                                          pe.pm_nextDate)
                        END AS NextDate ,
                        pe.fj_code AS JobCode ,
                        pe.fj_description AS JobDescript ,
                        pe.fo_description AS WorkDescript ,
                        pe.ftr_code AS UserTypeCode ,
                        @CountInt AS IntervalNum ,
                        pe.fo_code ,
                        pe.isGroup ,
                        '' AS grp_description
                FROM    [WebTMA].[dbo].[v_pmscheduleListReportExplorer] pe
                        LEFT OUTER JOIN [WebTMA].[dbo].[f_webtmaItemTypes] t ON t.itemType_pk = pe.pm_itemType_fk
                        JOIN dbo.f_pm_schedules p ON p.pm_pk = pe.pm_pk  -- Building Query
                        JOIN f_building b ON b.fb_pk = pe.pm_item_fk
                        JOIN dbo.f_facility f ON f.fd_pk = b.fb_fd_fk
                        LEFT OUTER JOIN dbo.f_jobLibrary jl ON jl.fo_pk = pe.pm_fo_fk
                WHERE   isGroup = 'False'
                UNION
                SELECT  f.fd_name ,
                        b.fb_name ,
                        b.fb_y_coordinate AS Latitude ,
                        b.fb_x_coordinate AS Longitude ,
                        ISNULL(a.fu_description, '') AS Slot ,
                        '' AS Equipment ,
                        t.itemType_name ItemType ,
                        pe.interval_name ,
                        pe.pm_interval AS Interval ,
                        pe.pm_lastDate AS LastDate ,
                        CASE WHEN pe.interval_name = 'Month'
                             THEN DATEADD(MONTH, @CountInt * pe.pm_interval,
                                          pe.pm_nextDate)
                             WHEN pe.interval_name = 'Year'
                             THEN DATEADD(YEAR, @CountInt * pe.pm_interval,
                                          pe.pm_nextDate)
                        END AS NextDate ,
                        pe.fj_code AS JobCode ,
                        pe.fj_description AS JobDescript ,
                        pe.fo_description AS WorkDescript ,
                        pe.ftr_code AS UserTypeCode ,
                        @CountInt AS IntervalNum ,
                        pe.fo_code ,
                        pe.isGroup ,
                        '' AS grp_description
                FROM    [WebTMA].[dbo].[v_pmscheduleListReportExplorer] pe
                        LEFT OUTER JOIN [WebTMA].[dbo].[f_webtmaItemTypes] t ON t.itemType_pk = pe.pm_itemType_fk
                        JOIN dbo.f_pm_schedules p ON p.pm_pk = pe.pm_pk -- Slot Query
                        JOIN f_area a ON a.fu_pk = pe.pm_item_fk
                        JOIN f_building b ON b.fb_pk = a.fu_fb_fk
                        JOIN dbo.f_facility f ON f.fd_pk = b.fb_fd_fk
                        LEFT OUTER JOIN dbo.f_jobLibrary jl ON jl.fo_pk = pe.pm_fo_fk
                WHERE   isGroup = 'False'
                UNION
                SELECT  f.fd_name ,
                        b.fb_name ,
                        b.fb_y_coordinate AS Latitude ,
                        b.fb_x_coordinate AS Longitude ,
                        ISNULL(a.fu_description, '') AS Slot ,
                        ISNULL(e.fm_description, '') AS Equip ,
                        t.itemType_name ItemType ,
                        pe.interval_name ,
                        pe.pm_interval AS Interval ,
                        pe.pm_lastDate AS LastDate ,
                        CASE WHEN pe.interval_name = 'Month'
                             THEN DATEADD(MONTH, @CountInt * pe.pm_interval,
                                          pe.pm_nextDate)
                             WHEN pe.interval_name = 'Year'
                             THEN DATEADD(YEAR, @CountInt * pe.pm_interval,
                                          pe.pm_nextDate)
                        END AS NextDate ,
                        pe.fj_code AS JobCode ,
                        pe.fj_description AS JobDescript ,
                        pe.fo_description AS WorkDescript ,
                        pe.ftr_code AS UserTypeCode ,
                        @CountInt AS IntervalNum ,
                        pe.fo_code ,
                        pe.isGroup ,
                        '' AS grp_description
                FROM    [WebTMA].[dbo].[v_pmscheduleListReportExplorer] pe
                        LEFT OUTER JOIN [WebTMA].[dbo].[f_webtmaItemTypes] t ON t.itemType_pk = pe.pm_itemType_fk
                        JOIN dbo.f_pm_schedules p ON p.pm_pk = pe.pm_pk -- equipment Query
                        JOIN f_equipment e ON e.fm_pk = pe.pm_item_fk
                        JOIN f_area a ON a.fu_pk = e.fm_fu_fk
                        JOIN f_building b ON b.fb_pk = a.fu_fb_fk
                        JOIN dbo.f_facility f ON f.fd_pk = b.fb_fd_fk
                        LEFT OUTER JOIN dbo.f_jobLibrary jl ON jl.fo_pk = pe.pm_fo_fk
                WHERE   isGroup = 'False'
                UNION
                SELECT  f.fd_name ,
                        b.fb_name ,
                        b.fb_y_coordinate AS Latitude ,
                        b.fb_x_coordinate AS Longitude ,
                        '-' AS fu_description ,
                        '-' AS fm_description ,
                        t.itemType_name ItemType ,
                        i.interval_name ,
                        ps.pm_interval AS Interval ,
                        ps.pm_lastDate AS LastDate ,
                        CASE WHEN i.interval_name = 'Month'
                             THEN DATEADD(MONTH, @CountInt * ps.pm_interval,
                                          ps.pm_nextDate)
                             WHEN i.interval_name = 'Year'
                             THEN DATEADD(YEAR, @CountInt * ps.pm_interval,
                                          ps.pm_nextDate)
                        END AS NextDate ,
                        j.fo_code AS JobCode ,
                        j.fo_description AS JobDescript ,
                        j.fo_description AS WorkDescript ,
                        tr.ftr_code ,
                        @CountInt AS IntervalNum ,
                        j.fo_code ,
                        'True' ,
                        g.grp_description
                FROM    dbo.f_pm_schedules ps
                        LEFT OUTER JOIN dbo.f_trade tr ON tr.ftr_pk = ps.pm_ftr_fk
                        JOIN f_group g ON g.grp_pk = ps.pm_item_fk
                        JOIN dbo.f_genInspectionForm gi ON gi.GIF_PK = g.grp_gif_fk
                        JOIN dbo.f_genInspectionSection gis ON gis.GIS_GIF_FK = gi.GIF_PK
                        JOIN dbo.f_genInspectionItem gii ON gii.GII_GIS_FK = gis.GIS_PK
                        JOIN dbo.f_building b ON b.fb_pk = gii.GII_item_fk
                        JOIN dbo.f_jobLibrary j ON j.fo_pk = ps.pm_fo_fk
                        JOIN dbo.f_webtmaItemTypes t ON t.itemType_pk = gii.GII_ItemType_fk
                        JOIN dbo.f_facility f ON f.fd_pk = b.fb_fd_fk
                        JOIN dbo.f_webtmaInterval i ON i.interval_pk = ps.pm_interval_fk
                WHERE   gii.GII_ItemType_fk = 9;
        SET @CountInt = @CountInt + 1;
    END;
        
SELECT  *
FROM    @FutureIns WHERE nextDate between @startDate and @EndDate AND Area = @Area AND Location = @Loc ;


SELECT fd_name FROM f_facility WHERE fd_pk BETWEEN 1001 AND 1007

SELECT b.fb_name FROM f_building b JOIN dbo.f_facility f ON f.fd_pk = b.fb_fd_fk WHERE f.fd_name IN @Area


SELECT a.fu_description FROM f_area a JOIN dbo.f_building b ON b.fb_pk = a.fu_fb_fk WHERE b.fb_name IN (@Location)

SELECT e.fm_description FROM dbo.f_equipment e JOIN f_area a ON a.fu_pk = e.fm_fu_fk