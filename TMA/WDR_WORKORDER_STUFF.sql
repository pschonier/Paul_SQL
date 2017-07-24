WITH    cteComment ( wot_pk, wot_comment )
          AS ( SELECT   wtc2.wot_wotask_fk ,
                        STUFF((SELECT   wot_comment
                               FROM     dbo.f_workorderTaskComment wtc1
                                        JOIN dbo.f_workorderTask wt ON wt.woTask_pk = wtc1.wot_wotask_fk
                                        JOIN dbo.f_jobLibrary j ON j.fo_pk = wt.woTask_fo_fk
                               WHERE    wtc1.wot_wotask_fk = wtc2.wot_wotask_fk
                               ORDER BY wot_wotask_fk
                        FOR   XML PATH('') ,
                                  TYPE).value('.', 'varchar(max)'), 1, 0, '') AS AllComments
               FROM     f_workorderTaskComment wtc2
               GROUP BY wot_wotask_fk
             )
    SELECT  DISTINCT
            wo.wo_requestDate ,
            wo.wo_completionDate ,
            CASE WHEN wo.wo_completionDate IS NULL THEN 'OPEN'
                 ELSE 'CLOSED'
            END AS "Status" ,
            wo.wo_number ,
            ISNULL(fu.fu_roomNumber, '_') AS Slot ,
            fd.fd_name AS Area ,
            fb.fb_name AS Location ,
            jt.fj_code ,
            CASE wo_itemType_fk
              WHEN 0 THEN ( SELECT  fm.fm_description
                            FROM    f_equipment fm
                            WHERE   fm.fm_pk = wo.wo_tag_fk
                          )
              ELSE '_'
            END AS EquipDescr ,
            jl.fo_description ,
            REPLACE(REPLACE(REPLACE(REPLACE(CAST(wo.wo_actionRequested AS NVARCHAR(MAX)),
                                            CHAR(13) + CHAR(10), ' ... '),
                                    CHAR(10) + CHAR(13), ' ... '), CHAR(13),
                            ' '), CHAR(10), ' ... ') Request ,
            CAST(( SELECT   cte.wot_comment
                   FROM     cteComment cte
                   WHERE    cte.wot_pk = wot.wotask_pk
                 ) AS NVARCHAR(MAX)) AS GeneralComment1--, cm.wot_comment AS GeneralComment
            ,
            CAST(wo.wo_techComments AS NVARCHAR(MAX)) AS TechComments ,
            userCreatedBy.user_login_ID ,
            wo.wo_requestor ,
            ISNULL(( SELECT TOP 1
                            RTRIM(fp.wk_firstName) + ' ' + fp.wk_lastName
                     FROM   f_personnel fp
                            JOIN f_workorderTaskSchedule wts ON wts.wos_wk_fk = fp.wk_pk
                                                              AND wts.wos_woTask_fk = wot.wotask_pk
                   ), '-') AS AssignedTechnician ,
            ISNULL(wo_completionDate, 0)
		   --, wo.wo_itemType_fk, wo.wo_tag_fk, wo.wo_fu_fk, wo.wo_fd_fk, wo_fb_fk
    FROM    dbo.f_workorder wo
            LEFT OUTER JOIN dbo.f_area fu ON wo.wo_fu_fk = fu.fu_pk
            INNER JOIN dbo.f_building fb ON wo_fb_fk = fb_pk
            INNER JOIN dbo.f_facility fd ON fd.fd_pk = wo.wo_fd_fk
            INNER JOIN f_workorderTask wot ON woTask_wo_fk = wo_pk
            INNER JOIN f_jobLibrary jl ON wot.woTask_fo_fk = jl.fo_pk
            INNER JOIN f_jobType jt ON fo_fj_fk = jt.fj_pk
            INNER JOIN f_users userCreatedBy ON wo_creator_fk = user_pk
            LEFT OUTER JOIN f_workorderTaskComment wc ON wc.wot_wotask_fk = wot.woTask_pk
    WHERE   ( fb.fb_name IN ( 'Amoco', 'Premcor', 'Shell', 'East Saint Louis',
                              'Saint Louis', 'Wood River' ) )
            AND ( jt.fj_code IN ( 'Malfunction' ) )
            AND ( ( wo.wo_completionDate IS NULL
                    OR wo.wo_completionDate = ''
                  )
                  OR ( (wo.wo_completionDate >= DATEADD(DAY, -14, GETDATE())) )
                )
    ORDER BY ISNULL(wo_completionDate, 0);