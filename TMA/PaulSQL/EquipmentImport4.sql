







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
                               END + ' ' + ISNULL(e2.fc_code, e.fc_code),
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
              fm_modelNumber ,
              fm_description ,
              fm_make ,
              fm_serialNumber ,
              fm_PONumber ,
              fm_purchaseDate ,
              fm_fc_fk ,
              fm_ven_fk ,
              fm_mfg_fk, 
			  fm_syt_fk
            )
            SELECT  ( SELECT    fd_pk
                      FROM      dbo.f_facility f
                      WHERE     f.fd_name = u.[AreaName]
                    ) ,
                    ( SELECT    fb_pk
                      FROM      dbo.f_building fb
                      WHERE     fb.fb_name = u.[LOCATIONNAME]
                    ) ,
                    ( SELECT TOP 1
                                fu_pk
                      FROM      dbo.f_area fa
                      WHERE     fa.fu_roomNumber = u.[SlotNum]
                                AND fa.fu_fb_fk  = ( SELECT
                                                              fb_pk
                                                         FROM f_building bl
                                                         WHERE
                                                              bl.fb_name = u.[LOCATIONNAME]
                                                       )
                    ) ,
                    1000 ,
                    u.TagNum ,
                    u.[ModelNum] ,
                    ISNULL(u.[DESCRIPTION],'') ,
                    u.Make ,
                    u.[SerialNum] ,
                    u.[PONum] ,
                    u.[DatePurchased] ,
                    ISNULL(( SELECT fc_pk
                             FROM   CTEEquip e
                             WHERE  e.eType = u.[Type Desc]
                                    AND e.eSubType = ISNULL(u.[SubtypeDesc],
                                                            '')
                           ), 520105) ,
                    ( SELECT    ven_pk
                      FROM      f_vendor v
                      WHERE     v.ven_name = u.Manufacturer
                    ) ,
                    ( SELECT    ven_pk
                      FROM      f_vendor v
                      WHERE     v.ven_name = u.Manufacturer
                                AND v.ven_isManufacturer = 1
                    ), 
					( SELECT    syt_pk
                          FROM      CTESys c
                          WHERE     c.SizeClass = u.[System]
                          AND c.ConnType = ISNULL(u.[subsystem], '')
                    )
			--fm_fu_fk = (SELECT fu_pk FROM f_area a WHERE a.roomNumber = e.[Slot #]) -- comment out unless slot is missing from record
            FROM    tempdb.dbo.ManPeoEquip u; 

UPDATE  dbo.f_equipment
SET     fm_mod_fk = ( SELECT    mod_pk
                      FROM      dbo.f_vendorMakeModel
                      WHERE     mod_MakeName = e.fm_make
                                AND e.fm_modelNumber = mod_ModelNumber
                    ) ,
        fm_description = ( SELECT   e.eDescription
                           FROM     ( SELECT    e.fc_pk ,
                                                CASE WHEN e2.fc_code IS NULL
                                                     THEN ''
                                                     ELSE e.fc_code
                                                END AS eSubType ,
                                                ISNULL(e2.fc_code, e.fc_code) AS eType ,
                                                ISNULL(CASE WHEN e2.fc_code IS NULL
                                                            THEN NULL
                                                            ELSE e.fc_code
                                                       END + ' '
                                                       + ISNULL(e2.fc_code,
                                                              e.fc_code),
                                                       e.fc_code) AS eDescription
                                      FROM      dbo.f_equipmentType e
                                                LEFT OUTER JOIN dbo.f_equipmentType e2 ON e2.fc_pk = e.fc_parent_fk
                                    ) e
                           WHERE    fm_fc_fk = e.fc_pk
                         )
FROM    dbo.f_equipment e;


UPDATE  dbo.f_equipment
SET     fm_fc_fk = fc_pk
FROM    dbo.f_equipment e
        JOIN f_equipmentType t ON e.fm_description = t.fc_description
WHERE   e.fm_fc_fk = 520105;




WITH    CTERC
          AS ( SELECT   rc_pk ,
                        fm_pk ,
                        eq.[Description]
               FROM     tempdb.dbo.ManPeoEquip eq
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

--********************ROLLBACK******************
		
			--BEGIN TRANSACTION
            --DELETE FROM dbo.f_equipmentRepairCenterLink WHERE fmrc_fm_fk IN (SELECT fm_pk FROM dbo.f_equipment e WHERE e.fm_tagNumber IN (SELECT tagNum FROM [tempdb].[dbo].ManPeoEquip))
			--ROLLBACK TRANSACTION
	
			
			--BEGIN TRANSACTION
			--DELETE FROM [WebTMA].[dbo].[f_equipment] WHERE fm_tagNumber IN (SELECT tagNum FROM [tempdb].[dbo].ManPeoEquip)
			--ROLLBACK TRANSACTION


			--9183921765
			--andrew 6572613871
			--SELECT * FROM [tempdb].[dbo].Equip0825
			----SELECT * FROM f_area where fu_unitID like '%TT%'
			----SELECT * FROM f_building
			--select * from f_equipment
			--SELECT * FROM [tempdb].[dbo].Equip0825
			--SELECT * FROM f_equipment WHERE fm_tagNumber IN (SELECT TagNum FROM [tempdb].[dbo].Equip0825)

--			TT-701
--TT-702
--TT-703



--SELECT * FROM f_area WHERE fu_unitID = 'HRT-V30' ORDER BY fu_pk DESC


SELECT * FROM f_area WHERE fu_roomNumber = 'Inverter'