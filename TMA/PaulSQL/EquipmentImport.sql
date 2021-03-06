BEGIN TRANSACTION
  
  WITH CTEEquip AS
          ( SELECT   e.fc_pk ,
                        CASE WHEN e2.fc_code IS NULL THEN NULL
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
  

  
  INSERT into webtma_test.dbo.f_equipment 
  (fm_clnt_fk, fm_fc_fk, fm_fu_fk, fm_fb_fk, fm_mfg_fk, fm_fd_fk, fm_tagNumber, fm_description, fm_modelNumber, fm_serialNumber, fm_purchaseDate, fm_PONumber, fm_mod_fk) -- , fm_secondaryId
  SELECT 1000, ISNULL(e.fc_pk, 520105)
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
  --WHERE eq.[Tag #] NOT IN (SELECT fm_tagNumber FROM dbo.f_equipment)
ROLLBACK TRANSACTION
SELECT * FROM f_equipment WHERE fm_tagNumber IN (SELECT [TagNum] FROM tempDB.dbo.Multilin)
SELECT * FROM tempdb.dbo.multilin
  --insert into f_udf (udf_item_fk, udf_itemType_fk, udf_30Char1, udf_30Char2, udf_30Char3, udf_30Char4, udf_60Char1, udf_60Char2, udf_255Char1, udf_255Char2, udf_255Char3, udf_255Char4, udf_255Char5, udf_date1, udf_boolean1)
  --select e.fm_pk,73, eq.[UDF CHAR 30-1 (GPM)], eq.[UDF CHAR 30-2 (HEAD)], eq.[UDF CHAR 30-3 (STAGES)], eq.[UDF CHAR 30-4 (SPEED)], eq.[UDF CHAR 60-1 (Mounting Flange to Sump Tank)],
  --eq.[UDF CHAR 60-2 (Discharge Flange)],eq.[UDF CHAR 1000-1 (Mount Flange to Bottom of Pump)], eq.[UDF 1000-2], eq.[UDF 1000-3], eq.[UDF CHAR 1000-4],eq.[UDF CHAR 1000-5],
  --eq.[UDF DATE], isnull(eq.[UDF BOOLEAN], '')  from tempDB.dbo.EquipImport eq
  --join f_equipment e on e.fm_tagNumber = eq.TAGNum
  DELETE fROM f_equipment WHERE fm_tagNumber IN (SELECT [TagNum] FROM tempDB.dbo.Multilin)
SELECT * FROM dbo.f_equipment
SELECT * FROM dbo.f_area
SELECT * FROM dbo.f_building
  SELECT * FROM  tempDB.dbo.ExpansionEquipAdd

-- Slot number and Location(building) must both match for area 
  --Thursday at Noon. BON-mln-211


  SELECT * FROM dbo.f_repairCenter