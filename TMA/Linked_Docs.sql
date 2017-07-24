SELECT        distinct 

              fb.fb_buildingNumber, fw.wo_number, left(cast(fw.wo_requestDate as nvarchar),12) as wo_requestDate, left(cast(fw.wo_completionDate as nvarchar),12) as wo_completionDate, f_workorder_1.wo_number AS RepairWO, 
              left(cast(f_workorder_1.wo_completionDate as nvarchar),12) AS RepairCloseDate, f_workorder_1.wo_actionRequested, f_workorderTask.woTask_fo_fk, g.grp_tagNumber, 
              f_repairCenter.rc_name, isnull(isnull(fb.fb_name, fbfm.fb_name), '-') as Location, g.grp_description
			  			 ,isnull((select top 1 rtrim(fp.wk_firstName) +' '+ fp.wk_lastName from f_personnel fp 
		     join f_workorderTaskSchedule wts on wts.wos_wk_fk = fp.wk_pk and wts.wos_woTask_fk = f_workordertask.wotask_pk
		      ), p.wk_firstName + ' ' + p.wk_lastName) as AssignedTechnician
			 
			  ,isnull(REPLACE(REPLACE(REPLACE(REPLACE(cast(f_workorder_1.wo_techComments as nvarchar(max)), CHAR(13) + CHAR(10), ' ... '), CHAR(10) + CHAR(13), ' ... '), CHAR(13), ' '), CHAR(10), ' ... '),'-') 
			  + isnull(REPLACE(REPLACE(REPLACE(REPLACE(cast(c1.wot_comment as nvarchar(max)), CHAR(13) + CHAR(10), ' ... '), CHAR(10) + CHAR(13), ' ... '), CHAR(13), ' '), CHAR(10), ' ... '),'-') as 'Repair Comments'
			  , ISNULL(ld.lds_remarks, ld.lds_fileName) AS FileName
			 FROM          f_repairCenter 
		INNER JOIN f_workorder fw ON f_repairCenter.rc_pk = fw.wo_rc_fk 
		LEFT OUTER JOIN f_workorder AS f_workorder_1 ON fw.wo_number = f_workorder_1.wo_ReferenceNumber 
		LEFT OUTER JOIN f_group g ON fw.wo_tag_fk = g.grp_pk
		LEFT OUTER JOIN f_workorderTask ON fw.wo_pk = f_workorderTask.woTask_wo_fk
		LEFT OUTER JOIN f_workorderTaskComment wc on wc.wot_wotask_fk = f_workorderTask.woTask_pk
		LEFT OUTER JOIN f_workorderTask t1 ON f_workorder_1.wo_pk = t1.woTask_wo_fk
		LEFT OUTER JOIN f_workorderTaskComment c1 on c1.wot_wotask_fk = t1.woTask_pk
        INNER JOIN f_genInspectionForm gif ON g.grp_gif_fk = gif.gif_pk
        INNER JOIN f_genInspectionSection gis ON gif.gif_pk = gis.gis_gif_fk
        INNER JOIN f_genInspectionItem gii ON gis.gis_pk = gii.gii_gis_fk
		LEFT OUTER JOIN f_GenInspectionResult GIR1 on GIR1.GIN_WOTask_FK = f_workorderTask.wotask_pk
		LEFT OUTER JOIN f_personnel p on p.wk_pk = GIR1.GIN_InspectedBy_fk
	    LEFT OUTER JOIN f_equipment fm ON gii.GII_item_fk = fm.fm_pk AND gii.GII_ItemType_fk = 0
		LEFT OUTER JOIN f_area fa ON fa.fu_pk = fm.fm_fu_fk
        LEFT OUTER JOIN f_building fbfm ON fm.fm_fb_fk = fbfm.fb_pk
        LEFT OUTER JOIN f_building fb ON gii.GII_item_fk = fb.fb_pk AND gii.GII_ItemType_fk = 9
		LEFT OUTER JOIN dbo.f_linkeddocs ld ON ld.lds_item_fk = fm.fm_pk OR ld.lds_item_fk = fw.wo_pk OR ld.lds_item_fk = f_repairCenter.rc_pk OR ld.lds_item_fk = fa.fu_pk
WHERE     
			(f_workorderTask.woTask_fo_fk = 547505) 
			AND ( fw.wo_itemType_fk = 3)

and fb.fb_name is not null
and g.grp_active = 1