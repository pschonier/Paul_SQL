

--select * from [WebTMA].[dbo].[v_pmscheduleListReportExplorer]
--SELECT * FROM dbo.f_group
--SELECT * FROM dbo.f_groupitem
--SELECT * FROM dbo.f_genInspectionForm
--SELECT * FROM dbo.f_jobLibrary
--select * from dbo.f_pm_Schedules
--SELECT * FROM dbo.f_webtmaItemTypes
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
             THEN DATEADD(MONTH, @CountInt * pe.pm_interval, pe.pm_nextDate)
             WHEN pe.interval_name = 'Year'
             THEN DATEADD(YEAR, @CountInt * pe.pm_interval, pe.pm_nextDate)
        END AS NextDate ,
        pe.fj_code AS JobCode ,
        pe.fj_description AS JobDescript ,
		pe.fo_description AS WorkDescript,
		pe.ftr_code AS UserTypeCode,
		@CountInt AS IntervalNum,
        pe.fo_code ,
		pe.isGroup,
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
             THEN DATEADD(MONTH, @CountInt * pe.pm_interval, pe.pm_nextDate)
             WHEN pe.interval_name = 'Year'
             THEN DATEADD(YEAR, @CountInt * pe.pm_interval, pe.pm_nextDate)
        END AS NextDate ,
        pe.fj_code AS JobCode ,
        pe.fj_description AS JobDescript ,
        pe.fo_description AS WorkDescript,
		pe.ftr_code AS UserTypeCode,
		@CountInt AS IntervalNum,
        pe.fo_code ,
		pe.isGroup,
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
             THEN DATEADD(MONTH, @CountInt * pe.pm_interval, pe.pm_nextDate)
             WHEN pe.interval_name = 'Year'
             THEN DATEADD(YEAR, @CountInt * pe.pm_interval, pe.pm_nextDate)
        END AS NextDate ,
        pe.fj_code AS JobCode ,
        pe.fj_description AS JobDescript ,
        pe.fo_description AS WorkDescript,
		pe.ftr_code AS UserTypeCode,
		@CountInt AS IntervalNum,
        pe.fo_code ,
		pe.isGroup,
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
SELECT  DISTINCT f.fd_name ,
        b.fb_name ,
        b.fb_y_coordinate AS Latitude ,
        b.fb_x_coordinate AS Longitude ,
        '-' AS fu_description ,
        '-' AS fm_description ,
        t.itemType_name ItemType ,
        pe.interval_name ,
        pe.pm_interval AS Interval ,
        pe.pm_lastDate AS LastDate ,
        CASE WHEN pe.interval_name = 'Month'
             THEN DATEADD(MONTH, @CountInt * pe.pm_interval, pe.pm_nextDate)
             WHEN pe.interval_name = 'Year'
             THEN DATEADD(YEAR, @CountInt * pe.pm_interval, pe.pm_nextDate)
        END AS NextDate ,
        pe.fj_code AS JobCode ,
        pe.fj_description AS JobDescript ,
        a.fo_description AS WorkDescript ,
        pe.ftr_code AS UserTypeCode ,
        @CountInt AS IntervalNum ,
        a.fo_code ,
        pe.isGroup ,
        g.grp_description
FROM    [WebTMA].[dbo].[v_pmscheduleListReportExplorer] pe
        LEFT OUTER JOIN dbo.f_jobLibrary jl ON jl.fo_pk = pe.pm_fo_fk
        LEFT OUTER JOIN [WebTMA].[dbo].[f_webtmaItemTypes] t ON t.itemType_pk = pe.pm_itemType_fk
        JOIN dbo.f_pm_schedules p ON p.pm_pk = pe.pm_pk -- Group Building Query
        JOIN f_building b ON b.fb_pk = pe.pm_item_fk
        JOIN dbo.f_facility f ON f.fd_pk = b.fb_fd_fk
        LEFT OUTER JOIN dbo.f_groupitem gi ON gi.pgl_item_fk = CASE gi.pgl_itemType_fk
                                                              WHEN 9
                                                              THEN b.fb_pk
                                                              END
        LEFT OUTER JOIN dbo.f_group g ON g.grp_pk = gi.pgl_grp_fk
        JOIN ( SELECT   j.fo_description ,
                        ps.fo_code ,
                        ps.pm_pk
               FROM     [WebTMA].[dbo].[v_pmscheduleListReportExplorer] ps
                        JOIN dbo.f_pm_schedules pd ON pd.pm_pk = ps.pm_pk
                        JOIN dbo.f_jobLibrary j ON j.fo_pk = ps.pm_fo_fk
                        JOIN dbo.f_building b ON b.fb_pk = ps.pm_item_fk
               WHERE    isGroup = 'true'
             ) a ON a.pm_pk = pe.pm_pk
WHERE   isGroup = 'True';

--union in group, and link on the building ,  then go find the facility with a subquery
--SELECT SUBSTRING(grp_tagnumber, CHARINDEX('-',grp_tagNumber,1)+1, LEN(RTRIM(grp_tagNumber))),* FROM dbo.f_group
--SELECT * FROM dbo.f_area
--SELECT * FROM dbo.f_building WHERE fb_code LIKE '%JOP%'
--SELECT * FROM dbo.f_genInspectionForm WHERE GIF_NAME 
--SELECT * FROM dbo.f_pm_schedules s JOIN dbo.f_jobLibrary j ON j.fo_pk = s.pm_fo_fk WHERE fo_code = 'EPLDOTBV'
--SELECT * from [WebTMA].[dbo].[v_pmscheduleListReportExplorer] WHERE isGroup = 'True'
--SELECT * FROM dbo.f_groupitem
--SELECT * from [WebTMA].[dbo].[v_pmscheduleListReportExplorer] pe WHERE pe.rc_name = 'Greenville Area' AND pe.fo_code = 'EPLPS00'
SELECT * FROM dbo.f_group
SELECT * FROM dbo.f_genInspectionForm

--SELECT jl.fo_description, jl.fo_code, pm.fo_code,* from [WebTMA].[dbo].[v_pmscheduleListReportExplorer] pm
--JOIN dbo.f_pm_schedules ps ON ps.pm_pk = pm.pm_pk
--JOIN dbo.f_jobLibrary jl ON jl.fo_pk = pm.pm_fo_fk
--JOIN dbo.f_building b ON b.fb_pk = pm.pm_item_fk
--WHERE isgroup='true' AND b.fb_name = 'Bonham'





SELECT * from [WebTMA].[dbo].[v_pmscheduleListReportExplorer] pm JOIN f_group g ON g.grp_pk = pm.pm_item_fk
