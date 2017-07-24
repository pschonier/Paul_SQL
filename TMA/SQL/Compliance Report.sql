DECLARE @area VARCHAR(50)
SET @area = 'Glenpool Area'
SELECT  a.wo_pk ,
        a.fb_buildingNumber ,
        a.wo_number ,
        a.wo_requestDate ,
        a.wo_completionDate ,
        a.woTask_fo_fk ,
        a.grp_tagNumber ,
        a.rc_name ,
        a.Location ,
        a.grp_description ,
        a.OutOfComplianceDate ,
        a.OutOfComplianceMessage
FROM    ( SELECT    fb.fb_buildingNumber ,
                    fw.wo_pk ,
                    fw.wo_number ,
                    wo_requestDate ,
                    fw.wo_completionDate AS wo_completionDate ,
                    f_workorderTask.woTask_fo_fk ,
                    g.grp_tagNumber ,
                    f_repairCenter.rc_name ,
                    ISNULL(ISNULL(fb.fb_name, fbfm.fb_name), '-') AS Location ,
                    g.grp_description ,
                    CASE WHEN DATEPART(MONTH,
                                       DATEADD(DAY, 15,
                                               DATEADD(MONTH, 7.5,
                                                       fw.wo_completionDate))) IN (
                              7, 8, 9 )
                         THEN CAST(DATEPART(YEAR, fw.wo_completionDate) AS VARCHAR)
                              + '/' + '06/30'
                         WHEN DATEPART(MONTH,
                                       DATEADD(DAY, 15,
                                               DATEADD(MONTH, 7.5,
                                                       fw.wo_completionDate))) IN (
                              1, 2, 3 )
                         THEN CAST(DATEPART(YEAR,
                                            DATEADD(YEAR, -1,
                                                    fw.wo_completionDate)) AS VARCHAR)
                              + '/' + '12/31'
                         ELSE DATEADD(DAY, 15,
                                      DATEADD(MONTH, 7.5, fw.wo_completionDate))
                    END AS OutOfComplianceDate ,
                    CASE WHEN DATEPART(MONTH,
                                       DATEADD(DAY, 15,
                                               DATEADD(MONTH, 7.5,
                                                       fw.wo_completionDate))) IN (
                              7, 8, 9 )
                         THEN 'Date changed - OOC in July, Aug, Sept'
                         WHEN DATEPART(MONTH,
                                       DATEADD(DAY, 15,
                                               DATEADD(MONTH, 7.5,
                                                       fw.wo_completionDate))) IN (
                              1, 2, 3 )
                         THEN 'Date changed - OOC in 1st quarter'
                         ELSE '-'
                    END AS OutOfComplianceMessage
          FROM      f_repairCenter
                    INNER JOIN f_workorder fw ON f_repairCenter.rc_pk = fw.wo_rc_fk
                    LEFT OUTER JOIN f_group g ON fw.wo_tag_fk = g.grp_pk
                    LEFT OUTER JOIN f_workorderTask ON fw.wo_pk = f_workorderTask.woTask_wo_fk
                    LEFT OUTER JOIN f_workorderTaskComment wc ON wc.wot_wotask_fk = f_workorderTask.woTask_pk
                    INNER JOIN f_genInspectionForm gif ON g.grp_gif_fk = gif.GIF_PK
                    INNER JOIN f_genInspectionSection gis ON gif.GIF_PK = gis.GIS_GIF_FK
                    INNER JOIN f_genInspectionItem gii ON gis.GIS_PK = gii.GII_GIS_FK
                    LEFT OUTER JOIN f_GenInspectionResult GIR1 ON GIR1.GIN_WOTask_FK = f_workorderTask.woTask_pk
                    LEFT OUTER JOIN f_personnel p ON p.wk_pk = GIR1.GIN_InspectedBy_fk
                    LEFT OUTER JOIN f_equipment fm ON gii.GII_item_fk = fm.fm_pk
                                                      AND gii.GII_ItemType_fk = 0
                    LEFT OUTER JOIN f_building fbfm ON fm.fm_fb_fk = fbfm.fb_pk
                    LEFT OUTER JOIN f_building fb ON gii.GII_item_fk = fb.fb_pk
                                                     AND gii.GII_ItemType_fk = 9
          WHERE     ( f_workorderTask.woTask_fo_fk = 547505 )
                    AND ( fw.wo_itemType_fk = 3 )
                    AND fb.fb_name IS NOT NULL
                    AND g.grp_active = 1
                    AND fw.wo_pk IN ( SELECT    MAX(wo_pk)
                                      FROM      f_workorder
                                      GROUP BY  wo_tag_fk )
                    AND ( f_repairCenter.rc_name IN ( @Area ) )
        ) AS a
ORDER BY CASE WHEN DATEPART(MONTH,
                            DATEADD(DAY, 15,
                                    DATEADD(MONTH, 7.5, a.wo_completionDate))) IN (
                   7, 8, 9 )
              THEN CAST(DATEPART(YEAR, a.wo_completionDate) AS VARCHAR) + '/'
                   + '06/30'
              WHEN DATEPART(MONTH, DATEADD(MONTH, 7.5, a.wo_completionDate)) IN (
                   1, 2, 3 )
              THEN CAST(DATEPART(YEAR, DATEADD(YEAR, -1, a.wo_completionDate)) AS VARCHAR)
                   + '/' + '12/31'
              ELSE DATEADD(DAY, 15, DATEADD(MONTH, 7.5, a.wo_completionDate))
         END DESC;




