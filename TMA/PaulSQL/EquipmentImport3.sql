 
   WITH CTEEquip as
          ( SELECT   e.fc_pk ,
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

 SELECT 1000, e.fc_pk
  , fu_pk
  , b.fb_pk, v.ven_pk, f.fd_pk,[TagNum], RTRIM([Description]), [MODELNUM], [SerialNum], [DatePurchased], [PONum], 
 (SELECT mod_pk FROM dbo.f_vendorMakeModel mm WHERE mm.mod_MakeName = eq.make AND mm.mod_ModelNumber = eq.[ModelNUM])-- alt_tag For above Field when available
  from tempDB.dbo.multilin eq
  JOIN f_area a ON a.fu_roomNumber = eq.[SlotNum] AND a.fu_fb_fk = (SELECT fb_pk FROM f_building b WHERE b.fb_name = eq.[LocationName])
  join f_facility f on f.fd_name = eq.[AreaName]
  join f_building b on b.fb_name = eq.[LocationName] 
  JOIN f_repairCenter rc ON rc.rc_code = f.fd_code
  left outer join f_vendor v on v.ven_name = eq.MANUFACTURER and v.ven_isManufacturer = 1
  LEFT OUTER JOIN CTEEquip e ON e.[eDescription] = eq.[Description]