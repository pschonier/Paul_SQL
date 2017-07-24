-- All Sites already exist
SELECT s.*,  s.AreaName, s.LocationName, s.SlotNumber FROM IT..TmaSlotsForImport s LEFT OUTER JOIN f_building fb on s.LocationName = fb.fb_name WHERE s.Imported = 0 AND fb.fb_pk is null

--INSERT INTO f_area
SELECT fb.fb_pk AS fu_fb_fk, wa.wa_pk AS fu_wa_fk, f_area.fu_ff_fk, f_area.fu_tg_fk, f_area.fu_cst_fk, f_area.fu_parent_fk, s.SlotNumber AS fu_roomNumber, s.SlotDescription AS fu_description
	, fb.fb_code + '-' + REPLACE(s.SlotNumber, ' ', '-') AS fu_unitID, f_area.fu_active, f_area.fu_parkingCount, f_area.fu_squareFootage, f_area.fu_smokeDetector, f_area.fu_phoneMain, f_area.fu_floorNumber, f_area.fu_usableSquareFootage
	, f_area.fu_asbestosAmount, f_area.fu_gender, f_area.fu_assignable, f_area.fu_floorType, f_area.fu_occupancy, f_area.fu_confinedSpace, f_area.fu_hazardousMaterial, f_area.fu_lead, f_area.fu_asbestos, f_area.fu_mold, f_area.fu_mailStop
	, f_area.fu_inspectionRequired, f_area.fu_lockoutProcess, f_area.fu_clnt_fk, getdate() AS fu_createdDate, f_area.fu_modifiedDate, f_area.fu_modifier_fk, 65 AS fu_creator_fk, f_area.fu_cleanableSquareFeet, f_area.fu_sink, f_area.fu_toilet
	, f_area.fu_urinal, f_area.fu_shower, f_area.fu_plumbing1, f_area.fu_plumbing2, f_area.fu_plumbing3, f_area.fu_paintDate, f_area.fu_paintWall, f_area.fu_paintCeiling, f_area.fu_paintTrim, f_area.fu_lightDate, f_area.fu_lightBulb, f_area.fu_lightFixture
	, f_area.fu_HVAC1, f_area.fu_HVAC2, f_area.fu_HVAC3, f_area.fu_floorReplaceDate, f_area.fu_floorCleanDate, f_area.fu_flooring1, f_area.fu_flooring2, f_area.fu_smokeDetectorCheckDate, f_area.fu_extinguisherCheckDate, f_area.fu_lifeSafety1
	, f_area.fu_lifeSafety2, f_area.fu_custodial, f_area.fu_custodialPriority, f_area.fu_fnc_fk, f_area.fu_apwa_fk, f_area.fu_gisfeat_fk, f_area.fu_cleanDrapedate, f_area.fu_replaceDrapedate, f_area.fu_realportfolio, f_area.fu_offsite, f_area.fu_wk_fk
	, f_area.fu_sublet, f_area.fu_preventAPPAOverride, f_area.fu_cprg_fk, f_area.fu_popupMsg, f_area.fu_warrantyDate, f_area.fu_isCarpeted
FROM IT..TmaSlotsForImport s 
	INNER JOIN f_building fb on s.LocationName = fb.fb_name
	INNER JOIN f_areaType wa on s.SlotSubType = wa.wa_description
	INNER JOIN f_area on 438794 = f_area.fu_pk
	LEFT OUTER JOIN WebTMA..f_area fuunique on wa.wa_pk = fuunique.fu_wa_fk and fb.fb_pk = fuunique.fu_fb_fk and s.SlotNumber = fuunique.fu_roomNumber
WHERE fuunique.fu_pk is null and s.Imported = 0
--update IT..TmaSlotsForImport set imported = 1 where imported = 0

