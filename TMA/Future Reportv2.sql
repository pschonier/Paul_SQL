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
	  JobDescript VARCHAR(255),
      WorkDescript VARCHAR(250) ,
      UserTypeCode VARCHAR(250) ,
      IntervalNum INT ,
      JobLibCode VARCHAR(50) ,
      GroupFlag VARCHAR(5),
	  GroupDescript varchar(300)
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
				  JobDescript,
                  WorkDescript ,
                  UserTypeCode ,
                  IntervalNum ,
                  JobLibCode ,
                  GroupFlag,
				  GroupDescript
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
						w.fj_description AS JobDescript,
                        jl.fo_description AS WorkDescript ,
                        w.ftr_code AS UserTypeCode ,
                        @CountInt AS IntervalNum ,
                        jl.fo_code ,
                        w.isGroup,
						g.grp_description

                FROM    [WebTMA].[dbo].[v_pmscheduleListReportWizard] w
                        JOIN dbo.f_pm_schedules s ON s.pm_pk = w.pm_pk
						JOIN dbo.f_building b ON b.fb_pk = s.pm_item_fk
                        JOIN dbo.f_repairCenter rc ON rc.rc_pk = w.pm_rc_fk
                        left OUTER JOIN dbo.f_jobLibrary jl ON jl.fo_pk = s.pm_fo_fk AND s.pm_item_fk = CASE s.pm_itemType_fk WHEN
						 0 THEN e.fm_pk WHEN 9 THEN b.fb_pk WHEN 7 THEN a.fu_pk END
						LEFT OUTER JOIN dbo.f_groupitem gi ON gi.pgl_item_fk = CASE gi.pgl_itemType_fk WHEN
						 0 THEN e.fm_pk WHEN 9 THEN b.fb_pk WHEN 7 THEN a.fu_pk END
						LEFT OUTER JOIN dbo.f_group g ON g.grp_pk = gi.pgl_grp_fk
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
		JobDescript,
        WorkDescript ,
        UserTypeCode AS LaborType ,
        IntervalNum ,
        JobLibCode ,
        GroupFlag,
		GroupDescript
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
		JobDescript,
        WorkDescript ,
        UserTypeCode ,
        IntervalNum ,
        GroupFlag,
		GroupDescript
		;


-- primary report show fo_code - fo_description. COde is link to take user to subreport with task sheet and task check list
-- if part of a group then nix the equipment info then group. 
-- 2nd job code report with just 1st period



 --SELECT * FROM dbo.f_jobLibrary -- add fo_description

 -- --SELECT * FROM dbo.f_building
 -- --SELECT * FROM dbo.f_repairCenter
 -- SELECT * FROM [WebTMA].[dbo].[v_pmscheduleListReportWizard]
 -- SELECT * FROM dbo.f_genInspectionForm

 -- --SELECT * FROM dbo.f_pm_schedules
 -- --SELECT * FROM webtma.dbo.f_webtmaInterval
 -- SELECT * FROM dbo.f_group -- add description
 -- SELECT * FROM dbo.f_groupitem
  --look for EPLDOTBV for Bonham


  --JobCode report to include those unassigned. no inactive
