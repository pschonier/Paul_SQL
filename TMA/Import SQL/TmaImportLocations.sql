--Check for dups
SELECT l.LocationCode, fb.fb_code FROM IT..TmaLocationsForImport l INNER JOIN f_building fb ON l.LocationCode = fb.fb_code where isimported = 0

--Verify foreign keys.
SELECT fd.fd_code, LocationCode, LocationName, fbt_code, fbt_pk, CASE StatusText WHEN 'Active' THEN 1 ELSE 0 END, DESCRIPTION FROM IT..TmaLocationsForImport l
	LEFT OUTER JOIN WebTMA..f_facility fd on l.AreaName = fd.fd_name
	LEFT OUTER JOIN WebTMA..f_BuildingType fbt ON l.LocationSubType = fbt.fbt_code
	WHERE isimported = 0

--INSERT INTO f_building
SELECT LocationCode AS fb_code, LocationName as fb_name, fb.fb_buildingNumber, l.DESCRIPTION as fb_description, fb.fb_dp_fk, fb.fb_originalContractor
	, fb.fb_completedDate, fb.fb_originalCost, fb.fb_cleanoutProcess, fb.fb_shutoffProcess, fb.fb_emergencyInformation, fb.fb_secondaryContractor, fb.fb_roofInformation
	, fb.fb_floorCount, fb.fb_address1, fb.fb_address2, fb.fb_city, fb.fb_stateCode, fb.fb_zip, fb.fb_squareFootage, fb.fb_capacity, fb.fb_replacementCost, fb.fb_BTURating
	, fd_pk AS fb_fd_fk, fbt_pk AS fb_fbt_fk, CASE StatusText WHEN 'Active' THEN 1 ELSE 0 END AS fb_active, fb.fb_cst_fk, fb.fb_rc_fk, fb.fb_x_coordinate
	, fb.fb_y_coordinate, fb.fb_country_fk, fb.fb_roofWarranty, fb.fb_roofReplaced, fb.fb_roofSlope, fb.fb_roofArea, fb.fb_warrantyEnd, fb.fb_rts_fk
	, 1000 AS fb_clnt_fk, getdate() AS fb_createdDate, getdate() AS fb_modifiedDate, 555487 AS fb_modifier_fk, fb.fb_creator_fk, fb.fb_benchmarkUsage
	, fb.fb_benchmarkCost, 0 AS fb_leased, fb.fb_curr_fk, fb.fb_exch_fk, fb.fb_exch_date, fb.fb_gisfeat_fk, fb.fb_fn_fk, fb.fb_bcty_fk, fb.fb_costpersqft
	, fb.fb_lastRenovationdate, fb.fb_parent_fk, 0 AS fb_offsite, 0 AS fb_sublet, fb.fb_wk_fk, fb.fb_replacementCostEstimateDate, fb.fb_replacementCostInflationDate
	, fb.fb_replacementConstructionCost, fb.fb_replacementProjectCost, fb.fb_popupMsg, fb.fb_renovationDate
FROM IT..TmaLocationsForImport l
	INNER JOIN WebTMA..f_facility fd on l.AreaName = fd.fd_name
	INNER JOIN WebTMA..f_BuildingType fbt ON l.LocationSubType = fbt.fbt_code
	INNER JOIN WebTMA..f_Building fb ON fb.fb_pk = 210522
	LEFT OUTER JOIN WebTMA..f_Building fbunique on l.Locationcode = fbunique.fb_code
WHERE fbunique.fb_code IS NULL and isimported = 0

--update IT..TmaLocationsForImport set isimported = 1 where isimported = 0
--INSERT INTO [f_webtmaUserDataAccess] 
SELECT 65, 1001, fb_pk, 1, 1000 from f_building b left outer join [f_webtmaUserDataAccess] wda on b.fb_pk = wda.tag_fk where wda.tag_fk is null and b.fb_fbt_fk = 1017

