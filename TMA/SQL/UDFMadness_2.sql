with cteUDF as (
SELECT   f_equipment.fm_pk, f_equipment.fm_tagNumber AS [Tag Number]
--, isnull(f_udfLabel.udftype_30Char1, '-')+':'  + isnull(f_udf.udf_30Char1, '-') as GPM
--, isnull(f_udfLabel.udftype_30Char2, '-') +':'  +  isnull(f_udf.udf_30Char2, '-') as 'Head(Feet)'
--, isnull(f_udfLabel.udftype_30Char3, '-')+':'  +  isnull(f_udf.udf_30Char3, '-') as Stages
--, isnull(f_udfLabel.udftype_30Char4, '-')+':'  +  isnull(f_udf.udf_30Char4, '-') as Speed
--, isnull(f_udfLabel.udftype_60Char1, '-')+':'  + isnull(f_udf.udf_60Char1, '-') as 'Mounting Flange to Sump Tank'
--, isnull(f_udfLabel.udftype_60Char2, '-')+':'  +  isnull(f_udf.udf_60Char2, '-') as DischargeFlange
--, isnull(f_udfLabel.udfType_255Char1, '-')+':'  +  isnull(f_udf.udf_255Char1, '-') as 'Mount Flange to Bottom of Pump'
, isnull(f_udf.udf_30Char1, '-') as GPM
, isnull(f_udf.udf_30Char2, '-') as 'Head(Feet)'
, isnull(f_udf.udf_30Char3, '-') as Stages
, isnull(f_udf.udf_30Char4, '-') as Speed
, isnull(f_udf.udf_255Char2, '-') as 'ImpellerLift'
, isnull(f_udf.udf_60Char1, '-') as 'Mounting Flange to Sump Tank'
, isnull(f_udf.udf_60Char2, '-') as DischargeFlange
, isnull(f_udf.udf_255Char1, '-') as 'Mount Flange to Bottom of Pump'
, isnull(f_equipment.fm_PONumber, '-') as PONumber
--, isnull(f_udfLabel.udfType_255Char3, '-')as Label9, isnull(f_udf.udf_255Char3 , '-') as Value9
, f_equipmentType.fc_description, f_udf.*
FROM            f_udf LEFT OUTER JOIN
                         f_udfLabel INNER JOIN
                         f_equipmentType INNER JOIN
                         f_equipment ON f_equipmentType.fc_pk = f_equipment.fm_fc_fk ON f_udfLabel.udfType_item_fk = f_equipmentType.fc_pk ON 
                         f_udf.udf_item_fk = f_equipment.fm_pk
WHERE        (f_udf.udf_itemType_fk = 0) AND (f_udfLabel.udfType_itemType_fk = 13) )
select f.fd_name, b.fb_name, a.fu_description, e.fm_description,fu_unitID as fu_roomnumber, e.fm_tagNumber, isnull(v.ven_name, '-') as Manufacturer, isnull(e.fm_modelNumber, '-') as ModelNumber
,isnull(e.fm_serialNumber, '-') as SerialNumber, udf.* from f_equipment e
join f_area a on a.fu_pk = e.fm_fu_fk
join f_building b on b.fb_pk = a.fu_fb_fk
join f_facility f on f.fd_pk = b.fb_fd_fk
left outer join cteUDF udf on udf.fm_pk = e.fm_pk
left outer join f_vendor v on v.ven_pk = e.fm_mfg_fk and v.ven_isManufacturer = 1
--where fm_description = 'Vertical Can-Sump Pump'


select f.fd_code as AreaCode, f.fd_name as AreaName , b.fb_code as LocationCode, b.fb_buildingNumber as LocationNumber
, b.fb_description as LocationDescription ,a.fu_roomNumber as SlotID, a.fu_description as SlotDescription,  e.fm_tagNumber, e.fm_description, u.* from f_equipment e 
join f_udf u on u.udf_item_fk = e.fm_pk -- Quick query to pull all UDFs
join f_area a on a.fu_pk = e.fm_fu_fk
join f_building b on b.fb_pk = a.fu_fb_fk
join f_facility f on f.fd_pk = b.fb_fd_fk


select * from f_area
select * from f_building
select * from f_facility