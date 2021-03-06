

  INSERT    INTO WebTma_Test.dbo.f_area
            ( fu_fb_fk ,
              fu_wa_fk ,
              fu_roomNumber ,
              fu_description ,
              fu_unitID ,
              fu_active ,
              fu_clnt_fk ,
              fu_createdDate ,
              fu_ModifiedDate ,
              fu_fnc_fk
            )
            SELECT  b.fb_pk ,
                    at.wa_pk ,
                    ex.AreaNum ,
                    ex.AreaDescription ,
                    RTRIM(ex.[BuildingCode ]) + '-' + ex.AreaNum ,
                    LEN(RTRIM(ex.[BuildingCode ]) + '-' + ex.AreaNum) ,
                    1 ,
                    1000 ,
                    GETDATE() ,
                    GETDATE() ,
                    fun.fnc_pk
            FROM    tempdb.dbo.['NewCARSlots] ex
                    JOIN f_building b ON b.fb_code = ex.[BuildingCode ]
                    JOIN f_facility fac ON fac.fd_pk = b.fb_fd_fk
                    JOIN f_areaType at ON at.wa_code = ex.AreaTypeCode
                    JOIN f_areaFunction fun ON fun.fnc_code = ex.SlotFunction;


  SELECT    *
  FROM      tempdb.dbo.['NewCARSlots];


