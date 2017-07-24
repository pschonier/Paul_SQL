



--BEGIN TRANSACTION

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
    UPDATE  dbo.f_equipment
    SET     
	fm_modelNumber = u.[Model #] ,
            fm_make = u.Make ,
            fm_serialNumber = u.[Serial #] ,
            --fm_purchaseDate = u.[Date Purchased],
            fm_PONumber = u.[Purchase Order #] ,
            fm_fc_fk = ISNULL(( SELECT  fc_pk
                                FROM    CTEEquip e
                                WHERE   e.eType = u.[Type Desc]
                                        AND e.eSubType = u.[Subtype Desc]
                              ), 520105) ,
            fm_syt_fk = ( SELECT    syt_pk
                          FROM      CTESys c
                          WHERE     c.SizeClass = u.[Size - Class]
                                    AND c.ConnType = u.[Connection Type]
                        ) ,
            fm_ven_fk = ( SELECT    ven_pk
                          FROM      f_vendor v
                          WHERE     v.ven_name = u.Manufacturer
                        ) ,
            fm_mfg_fk = ( SELECT    ven_pk
                          FROM      f_vendor v
                          WHERE     v.ven_name = u.Manufacturer
                                    AND v.ven_isManufacturer = 1
                        ) ,
            fm_description = ( SELECT   e.eDescription
                               FROM     CTEEquip e
                               WHERE    fm_fc_fk = e.fc_pk
                             )
			--fm_fu_fk = (SELECT fu_pk FROM f_area a WHERE a.roomNumber = e.[Slot #]) -- comment out for most updates
    FROM    dbo.f_equipment e
            JOIN General.dbo.VinEquip u ON u.[Tag #] = e.fm_tagNumber;

UPDATE  dbo.f_equipment
SET     fm_mod_fk = ( SELECT    mod_pk
                      FROM      dbo.f_vendorMakeModel
                      WHERE     mod_MakeName = e.fm_make
                                AND e.fm_modelNumber = mod_ModelNumber
                    )
FROM    dbo.f_equipment e;


UPDATE  dbo.f_equipment
SET     fm_fc_fk = fc_pk
FROM    dbo.f_equipment e
        JOIN f_equipmentType t ON e.fm_description = t.fc_description
WHERE   e.fm_fc_fk = 520105;


--SELECT * FROM f_equipment e WHERE e.fm_fc_fk = 520105

WITH CTEEquip AS (
SELECT   e.fc_pk ,
                        CASE WHEN e2.fc_code IS NULL THEN ''
                             ELSE e.fc_code
                        END AS eSubType ,
                        ISNULL(e2.fc_code, e.fc_code) AS eType ,
                        ISNULL(CASE WHEN e2.fc_code IS NULL THEN NULL
                                    ELSE e.fc_code
                               END + ' ' + ISNULL(e2.fc_code, e.fc_code),
                               e.fc_code) AS eDescription
               FROM     dbo.f_equipmentType e
                        LEFT OUTER JOIN dbo.f_equipmentType e2 ON e2.fc_pk = e.fc_parent_fk)



UPDATE dbo.f_equipment SET fm_description = c.eDescription
FROM f_equipment eq
JOIN CTEEquip c ON c.fc_pk = eq.fm_fc_fk 

UPDATE f_equipment SET fm_purchaseDate = NULL WHERE DATEPART(YEAR, fm_purchaseDate) = 1900


--ROLLBACK TRANSACTION



--SELECT * INTO general.dbo.f_equipmentback FROM dbo.f_equipment

