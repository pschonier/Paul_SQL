DECLARE @FutureIns TABLE
    (
      Area VARCHAR(255) ,
      Location VARCHAR(255) ,
      Latitude FLOAT ,
      longitude FLOAT ,
      Slot VARCHAR(120) ,
      Equip VARCHAR(185) ,
      Descript VARCHAR(185) ,
      ItemType VARCHAR(255) ,
      IntervalName VARCHAR(255) ,
      INTERVAL INT ,
      LastDate DATETIME ,
      NextDate DATETIME ,
      JobCode VARCHAR(250) ,
      WorkDescript VARCHAR(250) ,
      UserTypeCode VARCHAR(250) ,
      IntervalNum INT ,
      JobLibCode VARCHAR(50) ,
      GroupFlag VARCHAR(5)
    );
DECLARE @CountInt INT = 0;
SET @CountInt = 1;
WHILE @CountInt < 13
    BEGIN
        INSERT  INTO @FutureIns
                ( Area ,
                  Location ,
                  Latitude ,
                  longitude ,
                  Slot ,
                  Equip ,
                  Descript ,
                  ItemType ,
                  IntervalName ,
                  INTERVAL ,
                  LastDate ,
                  NextDate ,
                  JobCode ,
                  WorkDescript ,
                  UserTypeCode ,
                  IntervalNum ,
                  JobLibCode ,
                  GroupFlag
                )
                SELECT  REPLACE(rc.rc_name, ' Area', '') AS Area ,
                        ISNULL(ISNULL(ISNULL(b.fb_name, b1.fb_name),
                                      b2.fb_name), '') AS Location ,
                        ISNULL(ISNULL(ISNULL(b.fb_y_coordinate,
                                             b1.fb_y_coordinate),
                                      b2.fb_y_coordinate), '') AS Latitude ,
                        ISNULL(ISNULL(ISNULL(b.fb_x_coordinate,
                                             b1.fb_x_coordinate),
                                      b2.fb_x_coordinate), '') AS Longitude ,
                        ISNULL(ISNULL(a.fu_description, a1.fu_description), '') AS Slot ,
                        ISNULL(e.fm_description, '') AS Equip ,
                        e.fm_description AS Descript ,
                        t.itemType_name ItemType ,
                        w.interval_name ,
                        s.pm_interval AS Interval ,
                        s.pm_lastDate AS LastDate ,
                        CASE WHEN w.interval_name = 'Month'
                             THEN DATEADD(MONTH, @CountInt * s.pm_interval,
                                          s.pm_nextDate)
                             WHEN w.interval_name = 'Year'
                             THEN DATEADD(YEAR, @CountInt * s.pm_interval,
                                          s.pm_nextDate)
                        END AS NextDate ,
                        w.fj_code AS JobCode ,
                        w.wc_description AS WorkDescript ,
                        w.ftr_code AS UserTypeCode ,
                        @CountInt AS IntervalNum ,
                        jl.fo_code ,
                        w.isGroup
                FROM    [WebTMA].[dbo].[v_pmscheduleListReportExplorer] w
                        JOIN dbo.f_pm_schedules s ON s.pm_pk = w.pm_pk
                        JOIN [WebTMA].[dbo].[f_webtmaItemTypes] t ON t.itemType_pk = w.pm_itemType_fk
                        LEFT OUTER JOIN WebTMA.dbo.f_equipment e ON e.fm_pk = w.pm_item_fk
                                                              AND t.itemType_name = 'Equipment'
                        LEFT OUTER JOIN WebTMA.dbo.f_area a ON a.fu_pk = w.pm_item_fk
                                                              AND t.itemType_name = 'Area'
                        LEFT OUTER JOIN WebTMA.dbo.f_building b ON b.fb_pk = w.pm_item_fk
                                                              AND t.itemType_name = 'Building'
                        LEFT OUTER JOIN WebTMA.dbo.f_area a1 ON a1.fu_pk = e.fm_fu_fk
                        LEFT OUTER JOIN WebTMA.dbo.f_building b1 ON b1.fb_pk = a1.fu_fb_fk
                        LEFT OUTER JOIN WebTMA.dbo.f_building b2 ON b2.fb_pk = a.fu_fb_fk
                        JOIN dbo.f_repairCenter rc ON rc.rc_pk = w.pm_rc_fk
                        LEFT OUTER JOIN dbo.f_jobLibrary jl ON jl.fo_pk = s.pm_fo_fk
                WHERE   w.pm_active = 1; 
        SET @CountInt = @CountInt + 1;
    END;

SELECT  Area ,
        Location ,
        Latitude ,
        longitude ,
        Slot ,
        CASE WHEN GroupFlag = 'True' THEN ''
             ELSE Equip
        END AS Equip ,
        ISNULL(Descript, '') AS Descript ,
        CASE ItemType
          WHEN 'Building' THEN 'Location'
          WHEN 'Area' THEN 'Slot'
		  WHEN 'Equipment' THEN 'Equipment'
        END AS ItemType ,
        IntervalName ,
        INTERVAL ,
        ISNULL(LastDate, '') AS LastDate ,
        NextDate ,
        JobCode ,
        WorkDescript ,
        UserTypeCode AS LaborType ,
        IntervalNum ,
        JobLibCode ,
        GroupFlag
FROM    @FutureIns
WHERE (GroupFlag = 'TRUE' AND ItemType = 'Building') OR GroupFlag = 'FALSE' -- Location(building) is always part of a group if inspections have been assigned. 
GROUP BY Area ,
        Location ,
        Latitude ,
        longitude ,
        Slot ,
        CASE WHEN GroupFlag = 'True' THEN ''
             ELSE Equip
        END ,
        ISNULL(Descript, '') ,
        CASE ItemType
          WHEN 'Building' THEN 'Location'
          WHEN 'Area' THEN 'Slot'
		  WHEN 'Equipment' THEN 'Equipment'
        END ,
        JobLibCode ,
        IntervalName ,
        INTERVAL ,
        ISNULL(LastDate, '') ,
        NextDate ,
        JobCode ,
        WorkDescript ,
        UserTypeCode ,
        IntervalNum ,
        GroupFlag;


-- primary report show fo_code - fo_description. COde is link to take user to subreport with task sheet and task check list
-- if part of a group then nix the equipment info then group. 
-- 2nd job code report with just 1st period



  --SELECT * FROM dbo.f_jobLibrary

  --SELECT * FROM dbo.f_building
  --SELECT * FROM dbo.f_repairCenter
  --SELECT * FROM [WebTMA].[dbo].[v_pmscheduleListReportWizard]

  --SELECT * FROM dbo.f_pm_schedules
  --SELECT * FROM webtma.dbo.f_webtmaInterval