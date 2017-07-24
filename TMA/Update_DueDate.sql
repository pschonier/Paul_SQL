
USE WebTMA;
WITH CTEDate AS (SELECT  wo_pk ,
        CASE WHEN DATEPART(MONTH,
                           DATEADD(DAY, 15,
                                   DATEADD(MONTH, 7.5, a.wo_completionDate))) IN (
                  7, 8, 9 )
             THEN CAST(DATEPART(YEAR, DATEADD(MONTH, 7.5, a.wo_completionDate)) AS VARCHAR)
                  + '/' + '06/30'
             WHEN DATEPART(MONTH,
                           DATEADD(DAY, 15,
                                   DATEADD(MONTH, 7.5, a.wo_completionDate))) IN (
                  1, 2, 3 )
             THEN CAST(DATEPART(YEAR, a.wo_completionDate) AS VARCHAR)
                  + '/' + '12/31'
             ELSE DATEADD(DAY, 15, DATEADD(MONTH, 7.5, a.wo_completionDate))
        END AS OutOfComplianceDate ,
        CASE WHEN DATEPART(MONTH,
                           DATEADD(DAY, 15,
                                   DATEADD(MONTH, 7.5, a.wo_completionDate))) IN (
                  7, 8, 9 ) THEN 'Date changed - OOC in July, Aug, Sept'
             WHEN DATEPART(MONTH,
                           DATEADD(DAY, 15,
                                   DATEADD(MONTH, 7.5, a.wo_completionDate))) IN (
                  1, 2, 3 ) THEN 'Date changed - OOC in 1st quarter'
             ELSE '-'
        END AS OutOfComplianceMessage
FROM    ( SELECT    fb.fb_buildingNumber ,
                    fw.wo_pk ,
                    fw.wo_number ,
					fw.wo_itemType_fk,
                    wo_requestDate ,
                    ( SELECT    MAX(fw2.wo_completionDate)
                      FROM      f_workorder fw2
                      WHERE     fw2.wo_tag_fk = g.grp_pk
                    ) AS wo_completionDate ,
                    f_workorderTask.woTask_fo_fk ,
                    g.grp_tagNumber ,
                    f_repairCenter.rc_name ,
                    ISNULL(ISNULL(fb.fb_name, fbfm.fb_name), '-') AS Location ,
                    g.grp_description
          FROM      f_repairCenter
                    INNER JOIN f_workorder fw ON f_repairCenter.rc_pk = fw.wo_rc_fk
                    RIGHT OUTER JOIN f_group g ON fw.wo_tag_fk = g.grp_pk
                    LEFT OUTER JOIN f_workorderTask ON fw.wo_pk = f_workorderTask.woTask_wo_fk
					LEFT OUTER JOIN dbo.f_jobLibrary jl ON jl.fo_pk = f_workordertask.woTask_fo_fk
					INNER JOIN dbo.f_jobType jt ON jt.fj_pk = jl.fo_fj_fk
                    LEFT OUTER JOIN f_workorderTaskComment wc ON wc.wot_wotask_fk = f_workorderTask.woTask_pk
                    LEFT OUTER JOIN f_genInspectionForm gif ON g.grp_gif_fk = gif.GIF_PK
                    LEFT OUTER JOIN  f_genInspectionSection gis ON gif.GIF_PK = gis.GIS_GIF_FK
                    LEFT OUTER  JOIN f_genInspectionItem gii ON gis.GIS_PK = gii.GII_GIS_FK
                    LEFT OUTER JOIN f_GenInspectionResult GIR1 ON GIR1.GIN_WOTask_FK = f_workorderTask.woTask_pk
                    LEFT OUTER JOIN f_personnel p ON p.wk_pk = GIR1.GIN_InspectedBy_fk
                    LEFT OUTER JOIN f_equipment fm ON gii.GII_item_fk = fm.fm_pk
                                                 
                    LEFT OUTER JOIN f_building fbfm ON fm.fm_fb_fk = fbfm.fb_pk
                    LEFT OUTER JOIN f_building fb ON gii.GII_item_fk = fb.fb_pk
                                                    
          WHERE     ( jt.fj_code = 'DOT Semi-Annual' )
                    --AND ( fw.wo_itemType_fk = 3 )
                    AND fb.fb_name IS NOT NULL
                    --AND g.grp_active = 1
                    AND fw.wo_pk IN ( SELECT    MAX(wo_pk)
                                      FROM      f_workorder
                                      GROUP BY  wo_tag_fk )
	 AND fw.wo_completionDate IS NULL) AS a)
	
UPDATE dbo.f_workordertask SET woTask_DueDate = CTEDate.OutOfComplianceDate
FROM dbo.f_workorderTask
JOIN CTEDate ON CTEDate.wo_pk = f_workorderTask.woTask_wo_fk



