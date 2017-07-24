  SELECT 1000, at.eDescription, at.fc_pk, a.fu_description, a.fu_pk, b.fb_description , b.fb_pk
  , v.ven_pk
  , f.fd_pk,[Tag #], [Description], [Model #], [Serial #], [Date Purchased], [Purchase Order #]--, alt_tag For above Field when available
  from tempDB.dbo.ExpansionEquipAdd eq
  JOIN f_facility f on f.fd_name = eq.[Area Name]
  JOIN (SELECT   e.fc_pk ,
                        CASE WHEN e2.fc_code IS NULL THEN ''
                             ELSE e.fc_code
                        END AS eSubType ,
                        ISNULL(e2.fc_code, e.fc_code) AS eType ,
                        ISNULL(CASE WHEN e2.fc_code IS NULL THEN NULL
                                    ELSE e.fc_code
                               END + ' ' + ISNULL(e2.fc_code, e.fc_code),
                               e.fc_code) AS eDescription
               FROM     dbo.f_equipmentType e
                        LEFT OUTER JOIN dbo.f_equipmentType e2 ON e2.fc_pk = e.fc_parent_fk)  as at on at.eDescription  = eq.[Description]
  JOIN f_building b on b.fb_name = eq.[Location Name] 
  JOIN f_area a on a.fu_roomNumber = eq.[SLOT #] AND a.fu_description = eq.[Description]
  JOIN f_vendor v on v.ven_name = eq.MANUFACTURER and v.ven_isManufacturer = 1
  WHERE eq.[Tag #] NOT IN (SELECT fm_tagNumber FROM dbo.f_equipment) ORDER BY [Tag #]


SELECT * FROM dbo.f_building