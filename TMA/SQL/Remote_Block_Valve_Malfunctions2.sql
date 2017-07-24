SELECT        distinct fw.wo_number, fw.wo_requestDate, fw.wo_completionDate, f_workorder_1.wo_number AS RepairWO, 
              f_workorder_1.wo_completionDate AS RepairCloseDate, f_workorder_1.wo_requestDate as TestWorkDate, f_workorder_1.wo_actionRequested, f_workorderTask.woTask_fo_fk, g.grp_tagNumber, 
              f_repairCenter.rc_name, isnull(isnull(fb.fb_name, fbfm.fb_name), '-') as Location, g.grp_description
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
WHERE       (fw.wo_requestDate BETWEEN '2014-8-1' AND '2014-12-1') 
			AND (f_workorderTask.woTask_fo_fk = 547505) 
			AND ( fw.wo_itemType_fk = 3)
			AND (f_repairCenter.rc_name IN ('Glenpool Area')) 
                        and (isdate(fw.wo_completionDate) in (0,1))
			and fb.fb_name is not null

	
ORDER BY g.grp_tagNumber


--select top 100 fw.wo_requestDate InspectionRequest, f1.wo_requestDate RepairRequestDate
--, fw.wo_completionDate InspectionCompDate, f1.wo_completionDate RepairCompletionDate
--, fw.wo_finishDate as InspectionFinishDate, f1.wo_finishDate as RepairFinishDate, datepart(d,f1.wo_requestDate-f1.wo_completionDate ) as RepairDateDifference
--from f_workorder fw 
--join f_workorder as f1 on f1.wo_number = fw.wo_ReferenceNumber 

--select * from f_workorder where wo_number = 'GLN-25613'