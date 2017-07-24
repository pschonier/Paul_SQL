


IF ( SELECT COUNT(1)
     FROM   f_equipment ep
     WHERE  ep.fm_tagNumber IN ( SELECT [TAGNUM]
                                 FROM   tempdb.dbo.GRFEquipmentImport )
   ) = 0
    BEGIN


        WITH    CTESys
                  AS ( SELECT   e.syt_pk ,
                                CASE WHEN e2.syt_code IS NULL THEN ''
                                     ELSE e.syt_code
                                END AS ConnType ,
                                ISNULL(e2.syt_code, e.syt_code) AS SizeClass
                       FROM     dbo.f_systemType e
                                LEFT OUTER JOIN dbo.f_systemType e2 ON e2.syt_pk = e.syt_parent_fk
                     ),
                CTEEquip
                  AS ( SELECT   e.fc_pk ,
                                CASE WHEN e2.fc_code IS NULL THEN ''
                                     ELSE e.fc_code
                                END AS eSubType ,
                                ISNULL(e2.fc_code, e.fc_code) AS eType ,
                                ISNULL(CASE WHEN e2.fc_code IS NULL THEN NULL
                                            ELSE e.fc_code
                                       END + ' ' + ISNULL(e2.fc_code,
                                                          e.fc_code),
                                       e.fc_code) AS eDescription
                       FROM     dbo.f_equipmentType e
                                LEFT OUTER JOIN dbo.f_equipmentType e2 ON e2.fc_pk = e.fc_parent_fk
                     )
            INSERT  INTO dbo.f_equipment
                    ( fm_fd_fk ,
                      fm_fb_fk ,
                      fm_fu_fk ,
                      fm_clnt_fk ,
                      fm_tagNumber ,
                      fm_description ,
                      fm_fc_fk 
      
                    )
                    SELECT  ( SELECT    fd_pk
                              FROM      dbo.f_facility f
                              WHERE     f.fd_name = u.[AreaName]
                            ) ,
                            ( SELECT    fb_pk
                              FROM      dbo.f_building fb
                              WHERE     fb.fb_name = u.[LOCATIONNAME]
                            ) ,
                            ( SELECT    fu_pk
                              FROM      f_area ar
                              WHERE     ar.fu_roomNumber = u.[Slot #]
                                        AND u.[Location Name] = ( SELECT
                                                              fb_name
                                                              FROM
                                                              f_building b
                                                              WHERE
                                                              fb_pk = ar.fu_fb_fk
                                                              )
                            ) ,
                            1000 ,
                            u.TagNum ,
                            ISNULL(u.[DESCRIPTION],
                                   RTRIM(ISNULL(u.[Subtypedesc], '')) + ' '
                                   + u.[Type desc]) ,
                            ISNULL(( SELECT fc_pk
                                     FROM   CTEEquip e
                                     WHERE  e.eType = u.[Type Desc]
                                            AND e.eSubType = ISNULL(u.[SubtypeDesc],
                                                              '')
                                   ), 520105) 

			--fm_fu_fk = (SELECT fu_pk FROM f_area a WHERE a.roomNumber = e.[Slot #]) -- comment out unless slot is missing from record
                    FROM    [tempdb].[dbo].GRFEquipmentImport u; 

    END;
ELSE
    ( SELECT    fm_tagNumber ,
                'Duplicate Tag' AS Duplicate
      FROM      f_equipment
      WHERE     fm_tagNumber IN ( SELECT    [TAGNUM]
                                  FROM      tempdb.dbo.GRFEquipmentImport )
    );


WITH    CTERC
          AS ( SELECT   rc_pk ,
                        fm_pk ,
                        eq.[Description]
               FROM     tempdb.dbo.GRFEquipmentImport eq
                        JOIN f_repairCenter rc ON rc.rc_code = ( SELECT
                                                              fd_code
                                                              FROM
                                                              f_facility
                                                              WHERE
                                                              fd_name = eq.AreaName
                                                              )
                        JOIN f_equipment e ON e.fm_tagNumber = eq.Tagnum
             )
    INSERT  INTO f_equipmentRepairCenterLink
            ( fmrc_rc_fk ,
              fmrc_fm_fk ,
              fmrc_clnt_fk ,
              fmrc_active ,
              fmrc_modifiedDate ,
              fmrc_modifier_fk ,
              fmrc_createdDate ,
              fmrc_creator_fk ,
              fmrc_preferred
            )
            SELECT  rc_pk ,
                    fm_pk ,
                    1000 ,
                    1 ,
                    NULL ,
                    NULL ,
                    GETDATE() ,
                    555487 ,
                    1
            FROM    CTERC;


--SELECT * FROM f_equipment e where e.fm_fc_fk = 520105
--SELECT * FROM dbo.f_equipmentType e where e.fc_pk = 520105

--SELECT * FROM f_equipment

--SELECT * FROM dbo.f_equipmentRepairCenterLink rc
--JOIN f_equipment e ON e.fm_pk = rc.fmrc_fm_fk WHERE fmrc_fm_fk = 1506422 --The duplicate key value is (6336, 1508576)
