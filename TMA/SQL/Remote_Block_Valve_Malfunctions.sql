declare @startdate datetime
declare @enddate datetime

set @startdate = '2014-09-01'
set @enddate = '2014-12-01'

--select @area

SELECT        distinct fw.wo_number, fw.wo_requestDate, fw.wo_completionDate, f_workorder_1.wo_number AS RepairWO, 
              f_workorder_1.wo_completionDate AS RepairCloseDate, f_workorder_1.wo_actionRequested, f_workorderTask.woTask_fo_fk, g.grp_tagNumber, 
              f_repairCenter.rc_name, isnull(isnull(fb.fb_name, fbfm.fb_name), '-') as Location
FROM          f_repairCenter 
		INNER JOIN f_workorder fw ON f_repairCenter.rc_pk = fw.wo_rc_fk 
		LEFT OUTER JOIN f_workorder AS f_workorder_1 ON fw.wo_number = f_workorder_1.wo_ReferenceNumber 
		LEFT OUTER JOIN f_group g ON fw.wo_tag_fk = g.grp_pk
		LEFT OUTER JOIN f_workorderTask ON fw.wo_pk = f_workorderTask.woTask_wo_fk
        INNER JOIN f_genInspectionForm gif ON g.grp_gif_fk = gif.gif_pk
        INNER JOIN f_genInspectionSection gis ON gif.gif_pk = gis.gis_gif_fk
        INNER JOIN f_genInspectionItem gii ON gis.gis_pk = gii.gii_gis_fk
	    LEFT OUTER JOIN f_equipment fm ON gii.GII_item_fk = fm.fm_pk AND gii.GII_ItemType_fk = 0
        LEFT OUTER JOIN f_building fbfm ON fm.fm_fb_fk = fbfm.fb_pk
        LEFT OUTER JOIN f_building fb ON gii.GII_item_fk = fb.fb_pk AND gii.GII_ItemType_fk = 9
WHERE       (fw.wo_requestDate BETWEEN @StartDate AND @EndDate) 
			AND (f_workorderTask.woTask_fo_fk = 547505) 
			AND ( fw.wo_itemType_fk = 3)
			AND (f_repairCenter.rc_name IN ('Glenpool Area'))
	
ORDER BY fw.wo_requestDate

--select * from f_repairCenter
----select top 100 * from f_workorder where f_workorder.wo_rc_fk is not null and f_workorder.wo_pk in (select f_workordertask.woTask_wo_fk from f_workordertask where f_workorderTask.woTask_fo_fk = 547505)
----select top 100 * from f_workorder
----and wo_fb_fk is not null
----select top 100 * from f_building
----select top 100 * from f_workordertask where f_workorderTask.woTask_fo_fk = 547505
--select top 100 fb.fb_description
--, wo.wo_fb_fk, * from f_group g 
--join f_workorder wo on wo.wo_tag_fk = g.grp_pk 
--join f_building fb on fb.fb_pk = wo.wo_fb_fk
--where wo.wo_fb_fk is not null
--select wo.*, ISNULL(fbfm.fb_code, fb.fb_code) fb_code 
--from f_workordertask woTask 
--	   INNER JOIN f_workorder wo ON woTask.woTask_wo_fk = wo.wo_pk
--       INNER JOIN f_joblibrary fo ON woTask.woTask_fo_fk = fo_pk
--       INNER JOIN f_group grp ON wo_tag_fk = grp.grp_pk  --wol_itemType_fk = 3 means group; see f_webtmaItemTypes
--       INNER JOIN f_genInspectionForm gif ON grp.grp_gif_fk = gif.gif_pk
--       INNER JOIN f_genInspectionSection gis ON gif.gif_pk = gis.gis_gif_fk
--       INNER JOIN f_genInspectionItem gii ON gis.gis_pk = gii.gii_gis_fk
--       LEFT OUTER JOIN f_equipment fm ON gii.GII_item_fk = fm.fm_pk AND gii.GII_ItemType_fk = 0
--       LEFT OUTER JOIN f_building fbfm ON fm.fm_fb_fk = fbfm.fb_pk
--       LEFT OUTER JOIN f_building fb ON gii.GII_item_fk = fb.fb_pk AND gii.GII_ItemType_fk = 9
--where fo_pk = 547505 AND wo_itemType_fk = 3


--select top 100* from f_building

