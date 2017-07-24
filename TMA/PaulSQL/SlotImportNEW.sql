
IF ( SELECT COUNT(1)
     FROM   f_area ep
     WHERE  ep.fu_unitID IN (
            SELECT  RTRIM(ex.[Building Code ]) + '-' + CAST(ex.[Area #] AS NVARCHAR)
            FROM    general.[dbo].NewSlot103 ex )
   ) = 0
    BEGIN

        WITH    CTESlotType
                  AS ( SELECT   a.wa_pk ,
                                ISNULL(a2.wa_code, a.wa_code) AS [Type] ,
                                CASE WHEN a2.wa_code IS NULL THEN ''
                                     ELSE a.wa_code
                                END AS [SubType]
                       FROM     dbo.f_areaType a
                                LEFT OUTER JOIN f_areaType a2 ON a2.wa_pk = a.wa_parent_fk
                     )
            INSERT  INTO dbo.f_area
                    ( fu_fb_fk ,
                      fu_wa_fk ,
                      fu_roomNumber ,
                      fu_description ,
                      fu_unitID ,
                      fu_active ,
                      fu_clnt_fk ,
                      fu_createdDate ,
                      fu_modifiedDate ,
                      fu_fnc_fk
                    )
                    SELECT  b.fb_pk ,
                         ISNULL(   ( SELECT    wa_pk
                              FROM      CTESlotType t
                              WHERE     t.Type = ex.[Area Type Code]
                                        AND t.SubType = ISNULL(ex.[Area Sub-type Code],
                                                              '')
                            ), 1012) ,
                            CAST(ex.[Area #] AS NVARCHAR) ,
                            ex.[Area Description] ,
                            RTRIM(ex.[Building Code ]) + '-' + CAST(ex.[Area #] AS NVARCHAR) ,
                            1 ,
                            1000 ,
                            GETDATE() ,
                            GETDATE() ,
                            fun.fnc_pk
                    FROM    general.dbo.NewSlot103 ex
                            JOIN f_building b ON b.fb_code = ex.[Building Code ]
                            JOIN f_facility fac ON fac.fd_pk = b.fb_fd_fk
                            LEFT OUTER JOIN f_areaType at ON at.wa_code = ex.[Area Type Code]
                            LEFT OUTER JOIN f_areaFunction fun ON fun.fnc_code = ex.[Slot Function (Area Function?)];
    END;
ELSE
    ( SELECT    fu_unitID ,
                'Duplicate UnitID' AS Duplicate
      FROM      f_area
      WHERE     fu_unitID IN (
                SELECT  RTRIM(ex.[Building Code ]) + '-' + CAST(ex.[Area #] AS NVARCHAR)
                FROM    General.dbo.NewSlot103 ex )
    );


--SELECT *  FROM dbo.f_area where fu_unitID = 'CED-B104'

--SELECT * FROM tempdb.dbo.NewSlot103 

--SELECT * FROM dbo.f_areaType

--BEGIN tran
--DELETE FROM tempdb.dbo.NewSlot103 WHERE [Area #] = 'PSHH-618' AND [Building Code] = 'GLN'
--ROLLBACK TRAN
--GLN-PSHH-618

--SELECT * FROM tempdb.dbo.NewSlot103 WHERE [Area #] = 'B102'