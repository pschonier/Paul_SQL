INSERT INTO  [IT].[dbo].[TmaEquipmentForImport] (AreaName, LocationName, SlotNumber, TagNumber, EquipmentType, EquipmentSubType,[Description], Manufacturer, Make, ModelNumber, SerialNumber, Imported)
SELECT AreaName, LocationName, SlotNum, TagNum, [TYPE DESC], ISNULL(subtypedesc,''), [DESCRIPTION], Manufacturer, Make, ModelNum, SERIALNUM, 0
FROM tempdb.dbo.multilin
--select * FROM [IT].[dbo].[TmaEquipmentForImport]


