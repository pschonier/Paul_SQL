--select count(*) from  IT..TmaEquipmentForImport where imported = 0
--Find missing Areas (f_facility)
SELECT * FROM IT..TmaEquipmentForImport e LEFT OUTER JOIN WebTMA..f_facility fd on e.AreaName = fd.fd_name WHERE fd.fd_pk is null AND e.Imported = 0

--Find missing locations/sites (f_building)
SELECT * FROM  IT..TmaEquipmentForImport e INNER JOIN WebTMA..f_facility fd on e.AreaName = fd.fd_name LEFT OUTER JOIN webtma..f_building fb ON e.LocationName = fb.fb_name AND fd.fd_pk = fb.fb_fd_fk WHERE fb.fb_pk is null and e.Imported = 0

--Find missing slots (f_area)
SELECT * FROM  IT..TmaEquipmentForImport e INNER JOIN f_building fb ON e.LocationName = fb.fb_name LEFT OUTER JOIN f_area fu on fb.fb_pk = fu.fu_fb_fk and e.SlotNumber = fu.fu_roomNumber WHERE fu.fu_pk is null and e.Imported = 0

--Find missing equipment type
SELECT * FROM  IT..TmaEquipmentForImport e LEFT OUTER JOIN f_EquipmentType fc on e.EquipmentType = fc.fc_code WHERE fc.fc_pk is null and e.Imported = 0

--Find missing equipment sub type
SELECT * FROM  IT..TmaEquipmentForImport e LEFT OUTER JOIN f_EquipmentType fc_sub on e.EquipmentSubType = fc_sub.fc_code WHERE LEN(e.EquipmentSubType) > 0 AND fc_sub.fc_pk is null and e.Imported = 0
SELECT * FROM  IT..TmaEquipmentForImport e INNER JOIN f_EquipmentType fc on e.EquipmentType = fc.fc_code LEFT OUTER JOIN f_EquipmentType fc_sub on e.EquipmentSubType = fc_sub.fc_code AND fc.fc_pk = fc_sub.fc_parent_fk WHERE LEN(e.EquipmentSubType) > 0 AND fc_sub.fc_pk is null and e.Imported = 0

--Find missing manufacturer
SELECT * FROM IT..TmaEquipmentForImport e LEFT OUTER JOIN f_vendor ven ON e.Manufacturer = ven.ven_name WHERE len(e.manufacturer) > 0 AND ven.ven_pk is null

-- Find duplicate tag numbers
SELECT tagnumber, count(tagnumber) from IT..TmaEquipmentForImport e INNER JOIN f_equipment eq on e.tagnumber = eq.fm_tagNumber where e.imported = 0 group by tagnumber having count(tagnumber) > 0


DECLARE @fm_pk int 
DECLARE @fm_clnt_fk int 
DECLARE @fm_fc_fk int 
DECLARE @fm_fu_fk int 
DECLARE @fm_ff_fk int 
DECLARE @fm_fb_fk int 
DECLARE @fm_fd_fk int 
DECLARE @fm_defaultAccount_fk int 
DECLARE @fm_tagNumber nvarchar(60) 
DECLARE @fm_description nvarchar(270) 
DECLARE @fm_acquisitionCost float 
DECLARE @fm_purchaseDate datetime 
DECLARE @fm_warrantyExpires datetime 
DECLARE @fm_serviceContractPhone nvarchar(40) 
DECLARE @fm_serviceContract bit 
DECLARE @fm_serviceContractExpires datetime 
DECLARE @fm_lastCertificationDate datetime 
DECLARE @fm_nextCertificationDate datetime 
DECLARE @fm_ECRICode nvarchar(34) 
DECLARE @fm_modelNumber nvarchar(100) 
DECLARE @fm_serialNumber nvarchar(100) 
DECLARE @FM_PART1_NAME nvarchar(40) 
DECLARE @FM_PART2_NAME nvarchar(40) 
DECLARE @FM_PART3_NAME nvarchar(40) 
DECLARE @FM_PART4_NAME nvarchar(40) 
DECLARE @FM_PART1_SERIAL nvarchar(50) 
DECLARE @FM_PART2_SERIAL nvarchar(50) 
DECLARE @FM_PART3_SERIAL nvarchar(50) 
DECLARE @FM_PART4_SERIAL nvarchar(50) 
DECLARE @FM_PART1_MODEL nvarchar(50) 
DECLARE @FM_PART2_MODEL nvarchar(50) 
DECLARE @FM_PART3_MODEL nvarchar(50) 
DECLARE @FM_PART4_MODEL nvarchar(50) 
DECLARE @FM_PART1_MFGR nvarchar(50) 
DECLARE @FM_PART2_MFGR nvarchar(50) 
DECLARE @FM_PART3_MFGR nvarchar(50) 
DECLARE @FM_PART4_MFGR nvarchar(50) 
DECLARE @FM_FILTER_INFO nvarchar(60) 
DECLARE @FM_BELT_1_QTY int 
DECLARE @fm_secondaryId nvarchar(30) 
DECLARE @fm_lifeExpectancy int 
DECLARE @FM_DISP datetime 
DECLARE @FM_PARTS_VEND nvarchar(70) 
DECLARE @fm_serviceInteruption nvarchar(510) 
DECLARE @fm_safetyPrecautions nvarchar(510) 
DECLARE @FM_ELECTR_1 nvarchar(60) 
DECLARE @FM_ELECTR_2 nvarchar(60) 
DECLARE @FM_ELECTR_3 nvarchar(60) 
DECLARE @FM_STEAM nvarchar(60) 
DECLARE @FM_COLD_WATER nvarchar(60) 
DECLARE @FM_HOT_WATER nvarchar(60) 
DECLARE @FM_SEWER nvarchar(60) 
DECLARE @FM_FRESH_AIR nvarchar(60) 
DECLARE @FM_GAS nvarchar(60) 
DECLARE @FM_COMPR_AIR nvarchar(60) 
DECLARE @FM_VACUUM nvarchar(60) 
DECLARE @FM_SUPPLIES nvarchar(60) 
DECLARE @FM_BELT_1 nvarchar(60) 
DECLARE @FM_BELT_2 nvarchar(60) 
DECLARE @FM_BELT_SIZE_1 nvarchar(40) 
DECLARE @FM_BELT_SIZE_2 nvarchar(40) 
DECLARE @FM_FILTER_SIZ_1 nvarchar(40) 
DECLARE @FM_FILTER_SIZ_2 nvarchar(40) 
DECLARE @FM_FILTER_OTHER nvarchar(160) 
DECLARE @FM_PART_TYPE1 nvarchar(30) 
DECLARE @FM_PART_TYPE2 nvarchar(30) 
DECLARE @FM_PART_TYPE3 nvarchar(30) 
DECLARE @FM_PART_TYPE4 nvarchar(30) 
DECLARE @FM_BELT_QTY2 int 
DECLARE @FM_LUB_EXTRA1 nvarchar(50) 
DECLARE @fm_comments nvarchar(4000) 
DECLARE @fm_startingHours decimal(9) 
DECLARE @fm_currentMeter decimal(9) 
DECLARE @fm_meterDigits int 
DECLARE @fm_meterRolloverCount int 
DECLARE @fm_powerUsage decimal(9) 
DECLARE @fm_riskFactor int 
DECLARE @fm_majorTag nvarchar(60) 
DECLARE @fm_amperageDraw decimal(9) 
DECLARE @fm_amperageRating decimal(9) 
DECLARE @fm_BTUOut decimal(9) 
DECLARE @fm_BTUPerHour decimal(9) 
DECLARE @fm_leased bit 
DECLARE @fm_deliveryCode nvarchar(4) 
DECLARE @fm_inspectedBy nvarchar(50) 
DECLARE @fm_inspectionDate datetime 
DECLARE @FM_LTD_OP_ERS float 
DECLARE @FM_LTD_PAT_RISK float 
DECLARE @FM_LST_OP_ER datetime 
DECLARE @FM_LST_PAT_RISK datetime 
DECLARE @FM_PURGE_DATE datetime 
DECLARE @fm_active bit 
DECLARE @fm_ven_fk int 
DECLARE @fm_so_fk int 
DECLARE @fm_dp_fk int 
DECLARE @fm_owner_dp_fk int 
DECLARE @fm_tg_fk int 
DECLARE @fm_mfg_fk int 
DECLARE @fm_rf_fk int 
DECLARE @fm_buildingFixture bit 
DECLARE @fm_lastCalibrationDate datetime 
DECLARE @fm_sy_fk int 
DECLARE @FM_INC_FK int 
DECLARE @fm_PONumber nvarchar(40) 
DECLARE @fm_drawingName nvarchar(800) 
DECLARE @fm_refrigerantPounds decimal(9) 
DECLARE @fm_refrigerantOunces decimal(9) 
DECLARE @fm_lastInventoryDate datetime 
DECLARE @fm_lastInventoryLocation nvarchar(200) 
DECLARE @fm_wk_fk int 
DECLARE @FM_LTD_OP_RISK float 
DECLARE @FM_LST_OP_RISK datetime 
DECLARE @fm_conditionInventory nvarchar(510) 
DECLARE @fm_deviceNumber nvarchar(70) 
DECLARE @fm_certificationExpires datetime 
DECLARE @fm_FAAPaperworkRequired bit 
DECLARE @fm_de_fk int 
DECLARE @fm_parent_fk int 
DECLARE @FM_PART_VEN_FK int 
DECLARE @fm_ss_fk int 
DECLARE @fm_status nvarchar(200) 
DECLARE @fm_subLocation nvarchar(160) 
DECLARE @fm_modifiedDate datetime 
DECLARE @fm_createdDate datetime 
DECLARE @fm_modifier_fk int 
DECLARE @fm_creator_fk int 
DECLARE @fm_fv_fk int 
DECLARE @fm_bmp bit 
DECLARE @fm_RegisteredDate datetime 
DECLARE @fm_syt_fk int 
DECLARE @fm_ACIReplacecost decimal(9) 
DECLARE @fm_ACITargetpercent decimal(9) 
DECLARE @fm_ACIActualpercent decimal(9) 
DECLARE @fm_curr_fk int 
DECLARE @fm_exch_fk int 
DECLARE @fm_exch_date datetime 
DECLARE @fm_jco_fk int 
DECLARE @fm_object_fk int 
DECLARE @fm_popupMsg nvarchar(510) 
DECLARE @rc_pk int

DECLARE g_cursor CURSOR FOR 
SELECT --fd.fd_name, fb.fb_name, fu.fu_roomNumber, fc.fc_code, fc_sub.fc_code, ISNULL(ven.ven_name, fmunique.fm_mfg_fk),
1000 AS fm_clnt_fk, IsNull(fc_sub.fc_pk, fc.fc_pk) AS fm_fc_fk, fu.fu_pk AS fm_fu_fk, fmunique.fm_ff_fk AS fm_ff_fk, fb.fb_pk AS fm_fb_fk, fd.fd_pk
	, fmunique.fm_defaultAccount_fk as fm_defaultAccount_fk, e.TagNumber as fm_tagNumber, e.Description as fm_description, fmunique.fm_acquisitionCost, fmunique.fm_purchaseDate, fmunique.fm_warrantyExpires, fmunique.fm_serviceContractPhone, fmunique.fm_serviceContract, fmunique.fm_serviceContractExpires, fmunique.fm_lastCertificationDate, fmunique.fm_nextCertificationDate, fmunique.fm_ECRICode
	, CASE LEN(e.ModelNumber) WHEN 0 THEN fmunique.fm_modelNumber ELSE e.ModelNumber END AS fm_modelNumber, CASE LEN(e.SerialNumber) WHEN 0 THEN fmunique.fm_serialNumber ELSE e.SerialNumber END AS fm_serialNumber, fmunique.fm_PART1_NAME, fmunique.fm_PART2_NAME, fmunique.fm_PART3_NAME, fmunique.fm_PART4_NAME, fmunique.fm_PART1_SERIAL, fmunique.fm_PART2_SERIAL, fmunique.fm_PART3_SERIAL, fmunique.fm_PART4_SERIAL, fmunique.fm_PART1_MODEL, fmunique.fm_PART2_MODEL, fmunique.fm_PART3_MODEL, fmunique.fm_PART4_MODEL, fmunique.fm_PART1_MFGR, fmunique.fm_PART2_MFGR, fmunique.fm_PART3_MFGR, fmunique.fm_PART4_MFGR, fmunique.fm_FILTER_INFO, fmunique.fm_BELT_1_QTY, fmunique.fm_secondaryId, fmunique.fm_lifeExpectancy, fmunique.fm_DISP, fmunique.fm_PARTS_VEND, fmunique.fm_serviceInteruption, fmunique.fm_safetyPrecautions, fmunique.fm_ELECTR_1, fmunique.fm_ELECTR_2, fmunique.fm_ELECTR_3, fmunique.fm_STEAM, fmunique.fm_COLD_WATER, fmunique.fm_HOT_WATER, fmunique.fm_SEWER, fmunique.fm_FRESH_AIR, fmunique.fm_GAS, fmunique.fm_COMPR_AIR, fmunique.fm_VACUUM, fmunique.fm_SUPPLIES, fmunique.fm_BELT_1, fmunique.fm_BELT_2, fmunique.fm_BELT_SIZE_1, fmunique.fm_BELT_SIZE_2, fmunique.fm_FILTER_SIZ_1, fmunique.fm_FILTER_SIZ_2, fmunique.fm_FILTER_OTHER, fmunique.fm_PART_TYPE1, fmunique.fm_PART_TYPE2, fmunique.fm_PART_TYPE3, fmunique.fm_PART_TYPE4, fmunique.fm_BELT_QTY2, fmunique.fm_LUB_EXTRA1, fmunique.fm_comments, fmunique.fm_startingHours, fmunique.fm_currentMeter, fmunique.fm_meterDigits, fmunique.fm_meterRolloverCount, fmunique.fm_powerUsage, fmunique.fm_riskFactor, fmunique.fm_majorTag, fmunique.fm_amperageDraw, fmunique.fm_amperageRating, fmunique.fm_BTUOut, fmunique.fm_BTUPerHour, fmunique.fm_leased, fmunique.fm_deliveryCode, fmunique.fm_inspectedBy, fmunique.fm_inspectionDate, fmunique.fm_LTD_OP_ERS, fmunique.fm_LTD_PAT_RISK, fmunique.fm_LST_OP_ER, fmunique.fm_LST_PAT_RISK, fmunique.fm_PURGE_DATE, fmunique.fm_active, fmunique.fm_ven_fk, fmunique.fm_so_fk, fmunique.fm_dp_fk, fmunique.fm_owner_dp_fk, fmunique.fm_tg_fk
	, ISNULL(ven.ven_pk, fmunique.fm_mfg_fk) AS fm_mfg_fk, fmunique.fm_rf_fk, fmunique.fm_buildingFixture, fmunique.fm_lastCalibrationDate, fmunique.fm_sy_fk, fmunique.fm_INC_FK, fmunique.fm_PONumber, fmunique.fm_drawingName, fmunique.fm_refrigerantPounds, fmunique.fm_refrigerantOunces, fmunique.fm_lastInventoryDate, fmunique.fm_lastInventoryLocation, fmunique.fm_wk_fk, fmunique.fm_LTD_OP_RISK, fmunique.fm_LST_OP_RISK, fmunique.fm_conditionInventory, fmunique.fm_deviceNumber, fmunique.fm_certificationExpires, fmunique.fm_FAAPaperworkRequired, fmunique.fm_de_fk, fmunique.fm_parent_fk, fmunique.fm_PART_VEN_FK, fmunique.fm_ss_fk, fmunique.fm_status, fmunique.fm_subLocation
	, NULL AS fm_modifiedDate, getdate() AS fm_createdDate, fmunique.fm_modifier_fk, fmunique.fm_creator_fk, fmunique.fm_fv_fk, fmunique.fm_bmp, fmunique.fm_RegisteredDate, fmunique.fm_syt_fk, fmunique.fm_ACIReplacecost, fmunique.fm_ACITargetpercent, fmunique.fm_ACIActualpercent, fmunique.fm_curr_fk, fmunique.fm_exch_fk, fmunique.fm_exch_date, fmunique.fm_jco_fk, fmunique.fm_object_fk, fmunique.fm_popupMsg
	, rc.rc_pk
FROM IT..TmaEquipmentForImport e
	INNER JOIN f_EquipmentType fc on e.EquipmentType = fc.fc_code
	LEFT OUTER JOIN f_EquipmentType fc_sub on e.EquipmentSubType = fc_sub.fc_code AND fc.fc_pk = fc_sub.fc_parent_fk
	INNER JOIN f_facility fd on e.AreaName = fd.fd_name
	INNER JOIN f_building fb ON e.LocationName = fb.fb_name
	INNER JOIN f_area fu on fb.fb_pk = fu.fu_fb_fk and e.SlotNumber = fu.fu_roomNumber
	INNER JOIN f_equipment fmunique ON 1505052 = fmunique.fm_pk
	INNER JOIN f_repairCenter rc ON fd.fd_code = rc.rc_code
	LEFT OUTER JOIN f_vendor ven ON ven.ven_name = e.Manufacturer -- 1010
WHERE Imported = 0 AND fd.fd_code IN ('01', '02', '03', '04', '05', '06', '07', '09')
order by e.TagNumber

open g_cursor
fetch next from g_cursor into @fm_clnt_fk, @fm_fc_fk, @fm_fu_fk, @fm_ff_fk, @fm_fb_fk, @fm_fd_fk, @fm_defaultAccount_fk, @fm_tagNumber, @fm_description, @fm_acquisitionCost, @fm_purchaseDate, @fm_warrantyExpires, @fm_serviceContractPhone, @fm_serviceContract, @fm_serviceContractExpires, @fm_lastCertificationDate, @fm_nextCertificationDate, @fm_ECRICode, @fm_modelNumber, @fm_serialNumber, @FM_PART1_NAME, @FM_PART2_NAME, @FM_PART3_NAME, @FM_PART4_NAME, @FM_PART1_SERIAL, @FM_PART2_SERIAL, @FM_PART3_SERIAL, @FM_PART4_SERIAL, @FM_PART1_MODEL, @FM_PART2_MODEL, @FM_PART3_MODEL, @FM_PART4_MODEL, @FM_PART1_MFGR, @FM_PART2_MFGR, @FM_PART3_MFGR, @FM_PART4_MFGR, @FM_FILTER_INFO, @FM_BELT_1_QTY, @fm_secondaryId, @fm_lifeExpectancy, @FM_DISP, @FM_PARTS_VEND, @fm_serviceInteruption, @fm_safetyPrecautions, @FM_ELECTR_1, @FM_ELECTR_2, @FM_ELECTR_3, @FM_STEAM, @FM_COLD_WATER, @FM_HOT_WATER, @FM_SEWER, @FM_FRESH_AIR, @FM_GAS, @FM_COMPR_AIR, @FM_VACUUM, @FM_SUPPLIES, @FM_BELT_1, @FM_BELT_2, @FM_BELT_SIZE_1, @FM_BELT_SIZE_2, @FM_FILTER_SIZ_1, @FM_FILTER_SIZ_2, @FM_FILTER_OTHER, @FM_PART_TYPE1, @FM_PART_TYPE2, @FM_PART_TYPE3, @FM_PART_TYPE4, @FM_BELT_QTY2, @FM_LUB_EXTRA1, @fm_comments, @fm_startingHours, @fm_currentMeter, @fm_meterDigits, @fm_meterRolloverCount, @fm_powerUsage, @fm_riskFactor, @fm_majorTag, @fm_amperageDraw, @fm_amperageRating, @fm_BTUOut, @fm_BTUPerHour, @fm_leased, @fm_deliveryCode, @fm_inspectedBy, @fm_inspectionDate, @FM_LTD_OP_ERS, @FM_LTD_PAT_RISK, @FM_LST_OP_ER, @FM_LST_PAT_RISK, @FM_PURGE_DATE, @fm_active, @fm_ven_fk, @fm_so_fk, @fm_dp_fk, @fm_owner_dp_fk, @fm_tg_fk, @fm_mfg_fk, @fm_rf_fk, @fm_buildingFixture, @fm_lastCalibrationDate, @fm_sy_fk, @FM_INC_FK, @fm_PONumber, @fm_drawingName, @fm_refrigerantPounds, @fm_refrigerantOunces, @fm_lastInventoryDate, @fm_lastInventoryLocation, @fm_wk_fk, @FM_LTD_OP_RISK, @FM_LST_OP_RISK, @fm_conditionInventory, @fm_deviceNumber, @fm_certificationExpires, @fm_FAAPaperworkRequired, @fm_de_fk, @fm_parent_fk, @FM_PART_VEN_FK, @fm_ss_fk, @fm_status, @fm_subLocation, @fm_modifiedDate, @fm_createdDate, @fm_modifier_fk, @fm_creator_fk, @fm_fv_fk, @fm_bmp, @fm_RegisteredDate, @fm_syt_fk, @fm_ACIReplacecost, @fm_ACITargetpercent, @fm_ACIActualpercent, @fm_curr_fk, @fm_exch_fk, @fm_exch_date, @fm_jco_fk, @fm_object_fk, @fm_popupMsg, @rc_pk

WHILE (@@fetch_status <> -1) BEGIN
	
	INSERT INTO f_equipment
	VALUES (@fm_clnt_fk, @fm_fc_fk, @fm_fu_fk, @fm_ff_fk, @fm_fb_fk, @fm_fd_fk, @fm_defaultAccount_fk, @fm_tagNumber, @fm_description, @fm_acquisitionCost, @fm_purchaseDate, @fm_warrantyExpires, @fm_serviceContractPhone, @fm_serviceContract, @fm_serviceContractExpires, @fm_lastCertificationDate, @fm_nextCertificationDate, @fm_ECRICode, @fm_modelNumber, @fm_serialNumber, @FM_PART1_NAME, @FM_PART2_NAME, @FM_PART3_NAME, @FM_PART4_NAME, @FM_PART1_SERIAL, @FM_PART2_SERIAL, @FM_PART3_SERIAL, @FM_PART4_SERIAL, @FM_PART1_MODEL, @FM_PART2_MODEL, @FM_PART3_MODEL, @FM_PART4_MODEL, @FM_PART1_MFGR, @FM_PART2_MFGR, @FM_PART3_MFGR, @FM_PART4_MFGR, @FM_FILTER_INFO, @FM_BELT_1_QTY, @fm_secondaryId, @fm_lifeExpectancy, @FM_DISP, @FM_PARTS_VEND, @fm_serviceInteruption, @fm_safetyPrecautions, @FM_ELECTR_1, @FM_ELECTR_2, @FM_ELECTR_3, @FM_STEAM, @FM_COLD_WATER, @FM_HOT_WATER, @FM_SEWER, @FM_FRESH_AIR, @FM_GAS, @FM_COMPR_AIR, @FM_VACUUM, @FM_SUPPLIES, @FM_BELT_1, @FM_BELT_2, @FM_BELT_SIZE_1, @FM_BELT_SIZE_2, @FM_FILTER_SIZ_1, @FM_FILTER_SIZ_2, @FM_FILTER_OTHER, @FM_PART_TYPE1, @FM_PART_TYPE2, @FM_PART_TYPE3, @FM_PART_TYPE4, @FM_BELT_QTY2, @FM_LUB_EXTRA1, @fm_comments, @fm_startingHours, @fm_currentMeter, @fm_meterDigits, @fm_meterRolloverCount, @fm_powerUsage, @fm_riskFactor, @fm_majorTag, @fm_amperageDraw, @fm_amperageRating, @fm_BTUOut, @fm_BTUPerHour, @fm_leased, @fm_deliveryCode, @fm_inspectedBy, @fm_inspectionDate, @FM_LTD_OP_ERS, @FM_LTD_PAT_RISK, @FM_LST_OP_ER, @FM_LST_PAT_RISK, @FM_PURGE_DATE, @fm_active, @fm_ven_fk, @fm_so_fk, @fm_dp_fk, @fm_owner_dp_fk, @fm_tg_fk, @fm_mfg_fk, @fm_rf_fk, @fm_buildingFixture, @fm_lastCalibrationDate, @fm_sy_fk, @FM_INC_FK, @fm_PONumber, @fm_drawingName, @fm_refrigerantPounds, @fm_refrigerantOunces, @fm_lastInventoryDate, @fm_lastInventoryLocation, @fm_wk_fk, @FM_LTD_OP_RISK, @FM_LST_OP_RISK, @fm_conditionInventory, @fm_deviceNumber, @fm_certificationExpires, @fm_FAAPaperworkRequired, @fm_de_fk, @fm_parent_fk, @FM_PART_VEN_FK, @fm_ss_fk, @fm_status, @fm_subLocation, @fm_modifiedDate, @fm_createdDate, @fm_modifier_fk, @fm_creator_fk, @fm_fv_fk, @fm_bmp, @fm_RegisteredDate, @fm_syt_fk, @fm_ACIReplacecost, @fm_ACITargetpercent, @fm_ACIActualpercent, @fm_curr_fk, @fm_exch_fk, @fm_exch_date, @fm_jco_fk, @fm_object_fk, @fm_popupMsg)
	SET @fm_pk=SCOPE_IDENTITY()
	PRINT 'Repair Center = ' + convert(varchar, @rc_pk) + ', Identity = ' + convert(varchar, @fm_pk)
	INSERT INTO f_equipmentRepairCenterLink (fmrc_rc_fk, fmrc_fm_fk, fmrc_clnt_fk, fmrc_active, fmrc_modifiedDate, fmrc_modifier_fk, fmrc_createdDate, fmrc_creator_fk, fmrc_preferred)
	VALUES (@rc_pk, @fm_pk, 1000, 1, NULL, NULL, getdate(), 555487, 1)
	
	fetch next from g_cursor into @fm_clnt_fk, @fm_fc_fk, @fm_fu_fk, @fm_ff_fk, @fm_fb_fk, @fm_fd_fk, @fm_defaultAccount_fk, @fm_tagNumber, @fm_description, @fm_acquisitionCost, @fm_purchaseDate, @fm_warrantyExpires, @fm_serviceContractPhone, @fm_serviceContract, @fm_serviceContractExpires, @fm_lastCertificationDate, @fm_nextCertificationDate, @fm_ECRICode, @fm_modelNumber, @fm_serialNumber, @FM_PART1_NAME, @FM_PART2_NAME, @FM_PART3_NAME, @FM_PART4_NAME, @FM_PART1_SERIAL, @FM_PART2_SERIAL, @FM_PART3_SERIAL, @FM_PART4_SERIAL, @FM_PART1_MODEL, @FM_PART2_MODEL, @FM_PART3_MODEL, @FM_PART4_MODEL, @FM_PART1_MFGR, @FM_PART2_MFGR, @FM_PART3_MFGR, @FM_PART4_MFGR, @FM_FILTER_INFO, @FM_BELT_1_QTY, @fm_secondaryId, @fm_lifeExpectancy, @FM_DISP, @FM_PARTS_VEND, @fm_serviceInteruption, @fm_safetyPrecautions, @FM_ELECTR_1, @FM_ELECTR_2, @FM_ELECTR_3, @FM_STEAM, @FM_COLD_WATER, @FM_HOT_WATER, @FM_SEWER, @FM_FRESH_AIR, @FM_GAS, @FM_COMPR_AIR, @FM_VACUUM, @FM_SUPPLIES, @FM_BELT_1, @FM_BELT_2, @FM_BELT_SIZE_1, @FM_BELT_SIZE_2, @FM_FILTER_SIZ_1, @FM_FILTER_SIZ_2, @FM_FILTER_OTHER, @FM_PART_TYPE1, @FM_PART_TYPE2, @FM_PART_TYPE3, @FM_PART_TYPE4, @FM_BELT_QTY2, @FM_LUB_EXTRA1, @fm_comments, @fm_startingHours, @fm_currentMeter, @fm_meterDigits, @fm_meterRolloverCount, @fm_powerUsage, @fm_riskFactor, @fm_majorTag, @fm_amperageDraw, @fm_amperageRating, @fm_BTUOut, @fm_BTUPerHour, @fm_leased, @fm_deliveryCode, @fm_inspectedBy, @fm_inspectionDate, @FM_LTD_OP_ERS, @FM_LTD_PAT_RISK, @FM_LST_OP_ER, @FM_LST_PAT_RISK, @FM_PURGE_DATE, @fm_active, @fm_ven_fk, @fm_so_fk, @fm_dp_fk, @fm_owner_dp_fk, @fm_tg_fk, @fm_mfg_fk, @fm_rf_fk, @fm_buildingFixture, @fm_lastCalibrationDate, @fm_sy_fk, @FM_INC_FK, @fm_PONumber, @fm_drawingName, @fm_refrigerantPounds, @fm_refrigerantOunces, @fm_lastInventoryDate, @fm_lastInventoryLocation, @fm_wk_fk, @FM_LTD_OP_RISK, @FM_LST_OP_RISK, @fm_conditionInventory, @fm_deviceNumber, @fm_certificationExpires, @fm_FAAPaperworkRequired, @fm_de_fk, @fm_parent_fk, @FM_PART_VEN_FK, @fm_ss_fk, @fm_status, @fm_subLocation, @fm_modifiedDate, @fm_createdDate, @fm_modifier_fk, @fm_creator_fk, @fm_fv_fk, @fm_bmp, @fm_RegisteredDate, @fm_syt_fk, @fm_ACIReplacecost, @fm_ACITargetpercent, @fm_ACIActualpercent, @fm_curr_fk, @fm_exch_fk, @fm_exch_date, @fm_jco_fk, @fm_object_fk, @fm_popupMsg, @rc_pk
END

CLOSE g_cursor
DEALLOCATE g_cursor

--UPDATE IT..TmaEquipmentForImport SET Imported = 1 WHERE Imported = 0

--The following code is no longer necessary. The link gets created by the code above.
--Add the link to repair center  INSERT INTO f_equipmentRepairCenterLink
--SELECT rc.rc_pk AS fmrc_rc_fk, fm_pk as fmrc_fm_fk, 1000 AS fmrc_clnt_fk, 1 AS fmrc_active, NULL AS fmrc_modifiedDate, NULL AS fmrc_modifier_fk, getdate() AS fmrc_createdDate, 555487 AS fmrc_creator_fk, 1 AS fmrc_preferred
--FROM f_equipment fm
--INNER JOIN f_Facility fd ON fm.fm_fd_fk = fd.fd_pk
--INNER JOIN f_repairCenter rc ON fd.fd_code = rc.rc_code
--where fd.fd_code IN ('01', '02', '03', '04', '05', '06', '07', '09') AND fm_pk = 1505140 --and fm_tagnumber between '008745' and '009513'

--Here is the old way. It only fired the trigger for the first record to create the f_statushistory rows (2 per equipment record).
--INSERT INTO f_equipment
--SELECT --fd.fd_name, fb.fb_name, fu.fu_roomNumber, fc.fc_code, fc_sub.fc_code, ISNULL(ven.ven_name, fmunique.fm_mfg_fk),
--1000 AS fm_clnt_fk, IsNull(fc_sub.fc_pk, fc.fc_pk) AS fm_fc_fk, fu.fu_pk AS fm_fu_fk, fmunique.fm_ff_fk AS fm_ff_fk, fb.fb_pk AS fm_fb_fk, fd.fd_pk
--	, fmunique.fm_defaultAccount_fk as fm_defaultAccount_fk, e.TagNumber as fm_tagNumber, e.Description as fm_description, fmunique.fm_acquisitionCost, fmunique.fm_purchaseDate, fmunique.fm_warrantyExpires, fmunique.fm_serviceContractPhone, fmunique.fm_serviceContract, fmunique.fm_serviceContractExpires, fmunique.fm_lastCertificationDate, fmunique.fm_nextCertificationDate, fmunique.fm_ECRICode
--	, CASE LEN(e.ModelNumber) WHEN 0 THEN fmunique.fm_modelNumber ELSE e.ModelNumber END AS fm_modelNumber, CASE LEN(e.SerialNumber) WHEN 0 THEN fmunique.fm_serialNumber ELSE e.SerialNumber END AS fm_serialNumber, fmunique.fm_PART1_NAME, fmunique.fm_PART2_NAME, fmunique.fm_PART3_NAME, fmunique.fm_PART4_NAME, fmunique.fm_PART1_SERIAL, fmunique.fm_PART2_SERIAL, fmunique.fm_PART3_SERIAL, fmunique.fm_PART4_SERIAL, fmunique.fm_PART1_MODEL, fmunique.fm_PART2_MODEL, fmunique.fm_PART3_MODEL, fmunique.fm_PART4_MODEL, fmunique.fm_PART1_MFGR, fmunique.fm_PART2_MFGR, fmunique.fm_PART3_MFGR, fmunique.fm_PART4_MFGR, fmunique.fm_FILTER_INFO, fmunique.fm_BELT_1_QTY, fmunique.fm_secondaryId, fmunique.fm_lifeExpectancy, fmunique.fm_DISP, fmunique.fm_PARTS_VEND, fmunique.fm_serviceInteruption, fmunique.fm_safetyPrecautions, fmunique.fm_ELECTR_1, fmunique.fm_ELECTR_2, fmunique.fm_ELECTR_3, fmunique.fm_STEAM, fmunique.fm_COLD_WATER, fmunique.fm_HOT_WATER, fmunique.fm_SEWER, fmunique.fm_FRESH_AIR, fmunique.fm_GAS, fmunique.fm_COMPR_AIR, fmunique.fm_VACUUM, fmunique.fm_SUPPLIES, fmunique.fm_BELT_1, fmunique.fm_BELT_2, fmunique.fm_BELT_SIZE_1, fmunique.fm_BELT_SIZE_2, fmunique.fm_FILTER_SIZ_1, fmunique.fm_FILTER_SIZ_2, fmunique.fm_FILTER_OTHER, fmunique.fm_PART_TYPE1, fmunique.fm_PART_TYPE2, fmunique.fm_PART_TYPE3, fmunique.fm_PART_TYPE4, fmunique.fm_BELT_QTY2, fmunique.fm_LUB_EXTRA1, fmunique.fm_comments, fmunique.fm_startingHours, fmunique.fm_currentMeter, fmunique.fm_meterDigits, fmunique.fm_meterRolloverCount, fmunique.fm_powerUsage, fmunique.fm_riskFactor, fmunique.fm_majorTag, fmunique.fm_amperageDraw, fmunique.fm_amperageRating, fmunique.fm_BTUOut, fmunique.fm_BTUPerHour, fmunique.fm_leased, fmunique.fm_deliveryCode, fmunique.fm_inspectedBy, fmunique.fm_inspectionDate, fmunique.fm_LTD_OP_ERS, fmunique.fm_LTD_PAT_RISK, fmunique.fm_LST_OP_ER, fmunique.fm_LST_PAT_RISK, fmunique.fm_PURGE_DATE, fmunique.fm_active, fmunique.fm_ven_fk, fmunique.fm_so_fk, fmunique.fm_dp_fk, fmunique.fm_owner_dp_fk, fmunique.fm_tg_fk
--	, ISNULL(ven.ven_pk, fmunique.fm_mfg_fk) AS fm_mfg_fk, fmunique.fm_rf_fk, fmunique.fm_buildingFixture, fmunique.fm_lastCalibrationDate, fmunique.fm_sy_fk, fmunique.fm_INC_FK, fmunique.fm_PONumber, fmunique.fm_drawingName, fmunique.fm_refrigerantPounds, fmunique.fm_refrigerantOunces, fmunique.fm_lastInventoryDate, fmunique.fm_lastInventoryLocation, fmunique.fm_wk_fk, fmunique.fm_LTD_OP_RISK, fmunique.fm_LST_OP_RISK, fmunique.fm_conditionInventory, fmunique.fm_deviceNumber, fmunique.fm_certificationExpires, fmunique.fm_FAAPaperworkRequired, fmunique.fm_de_fk, fmunique.fm_parent_fk, fmunique.fm_PART_VEN_FK, fmunique.fm_ss_fk, fmunique.fm_status, fmunique.fm_subLocation
--	, NULL AS fm_modifiedDate, getdate() AS fm_createdDate, fmunique.fm_modifier_fk, fmunique.fm_creator_fk, fmunique.fm_fv_fk, fmunique.fm_bmp, fmunique.fm_RegisteredDate, fmunique.fm_syt_fk, fmunique.fm_ACIReplacecost, fmunique.fm_ACITargetpercent, fmunique.fm_ACIActualpercent, fmunique.fm_curr_fk, fmunique.fm_exch_fk, fmunique.fm_exch_date, fmunique.fm_jco_fk, fmunique.fm_object_fk, fmunique.fm_popupMsg
--FROM IT..TmaEquipmentForImport e
--	INNER JOIN f_EquipmentType fc on e.EquipmentType = fc.fc_code
--	LEFT OUTER JOIN f_EquipmentType fc_sub on e.EquipmentSubType = fc_sub.fc_code AND fc.fc_pk = fc_sub.fc_parent_fk
--	INNER JOIN f_facility fd on e.AreaName = fd.fd_name
--	INNER JOIN f_building fb ON e.LocationName = fb.fb_name
--	INNER JOIN f_area fu on fb.fb_pk = fu.fu_fb_fk and e.SlotNumber = fu.fu_roomNumber
--	INNER JOIN f_equipment fmunique ON 1198 = fmunique.fm_pk
--	LEFT OUTER JOIN f_vendor ven ON ven.ven_name = e.Manufacturer -- 1010
--WHERE Imported = 0
--order by e.TagNumber

--2 Status records get created by a trigger but only for one of the rows. 
--select * from f_statushistory where sth_fm_fk is not null and sth_date >= '8/5/2014 15:15:00' and (sth_status = 'Created' OR sth_status = 'Risk Level:0')
--INSERT INTO f_statusHistory
--SELECT sth.sth_DATE, sth.sth_STATUS, sth.sth_WO_FK, sth.sth_LOG_FK, sth.sth_PROJ_FK, sth.sth_ACT_FK, sth.sth_SS_FK, sth.sth_dontSend, sth.sth_QT_FK, sth.sth_pr_FK, sth.sth_PO_FK, sth.sth_SRQ_FK, sth.sth_TD_FK, sth.sth_RET_FK, sth.sth_OR_FK, sth.sth_RC_FK, sth.sth_VEN_FK, sth.sth_MFG_FK, sth.sth_PPO_FK, sth.sth_FD_FK, sth.sth_CONT_FK, fm_pk AS sth_FM_FK, sth.sth_ev_fk, sth.sth_est_fk, sth.sth_ce_fk, sth.sth_api_fk, sth.sth_itfm_fk, sth.sth_con_fk, sth.sth_COMMENT, sth.sth_CLNT_FK, sth.sth_MODIFIER_FK, sth.sth_CREATOR_FK, sth.sth_modifiedDate, sth.sth_createdDate, sth.sth_lease_fk, sth.sth_woNumber
--FROM f_equipment fm INNER JOIN f_statusHistory sth ON 1505012 = sth.STH_FM_FK where fm_pk >= 1504794 AND fm_pk <> 1505012 and (sth.sth_status = 'Created' or sth.sth_status = 'Risk Level:0')
--UPDATE IT..TmaEquipmentForImport SET Imported = 1 where Imported = 0
