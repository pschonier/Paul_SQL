alter View dbo.FieldInventory
as
select  distinct fb.fb_pk as LocationID , fa.fu_pk as SlotID, f1.fc_pk as EquipmentTypeID, f2.fc_pk as EquipmentSubTypeID
, fa.fu_description as 'Description', fm_make as Manufacturer, fe.fm_modelNumber as ModelNumber, fe.fm_serialNumber as SerialNumber, fe.fm_purchaseDate as PurchaseDate
, fe.fm_PONumber as PurchaseOrder, fe.fm_createdDate as CreatedDate
, fe.fm_creator_fk as CreatedBy, fe.fm_tagNumber as TagNumber, fe.fm_modifiedDate as ModifiedDate, fe.fm_modifier_fk as ModifiedBy, '' as ExportedDate
, '' as OtherSlotDescription, '' as NewEquipmentType,'' as NewEquipmentSubType
from f_equipment fe
inner join f_equipmenttype f1 on fe.fm_fc_fk = f1.fc_pk
left outer join f_equipmenttype f2 on f1.fc_parent_fk = f2.fc_pk
inner join f_area fa on fa.fu_pk = fe.fm_fu_fk
inner join f_building fb on fb.fb_pk = fa.fu_fb_fk
inner join f_facility ff on fb.fb_fd_fk = ff.fd_pk

go




-----Equipment Query
--select  distinct et.fc_description as EquipType, fc_pk, fc_parent_fk  
--from f_equipmenttype et  where fc_parent_fk is null 
--order by et.fc_description


----Eqip Sub Type query
--select  distinct fet.fc_description as EquipSubtype, fet.fc_pk
--from f_equipmenttype et 
--inner join f_equipmentType fet on fet.fc_parent_fk = et.fc_PK
--where et.fc_pk = 1225

--select * from f_equipment
--select * from f_equipmenttype