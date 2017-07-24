SELECT   
			wo.wo_requestDate
			, wo.wo_completionDate
			,case  when  wo.wo_completionDate is NULL then 'OPEN' else 'CLOSED' end as "Status"
			, wo.wo_number
			, isnull(fu.fu_roomNumber, '_') as Slot
			,fd.fd_name as Area, fb.fb_name as Location,  jt.fj_code
		   ,case wo_itemType_fk when 0 then (select fm.fm_description from f_equipment fm where fm.fm_pk = wo.wo_tag_fk) else '_' end as EquipDescr
		   , jl.fo_description
		   , REPLACE(REPLACE(REPLACE(REPLACE(cast(wo.wo_actionRequested as nvarchar(max)), CHAR(13) + CHAR(10), ' ... '), 
			CHAR(10) + CHAR(13), ' ... '), CHAR(13), ' '), CHAR(10), ' ... ') Request 
		   ,isnull(case  when  wo.wo_completionDate is NULL then REPLACE(REPLACE(REPLACE(REPLACE(cast(wo.wo_techComments as nvarchar(max)), CHAR(13) + CHAR(10), ' ... '), 
			CHAR(10) + CHAR(13), ' ... '), CHAR(13), ' '), CHAR(10), ' ... ') else
			 REPLACE(REPLACE(REPLACE(REPLACE(cast(wc.wot_comment as nvarchar(max)), CHAR(13) + CHAR(10), ' ... '), 
			CHAR(10) + CHAR(13), ' ... '), CHAR(13), ' '), CHAR(10), ' ... ') end , isnull(REPLACE(REPLACE(REPLACE(REPLACE(cast(wo.wo_techComments as nvarchar(max)), CHAR(13) + CHAR(10), ' ... '), 
			CHAR(10) + CHAR(13), ' ... '), CHAR(13), ' '), CHAR(10), ' ... '), '-')) as Comment
		   ,userCreatedBy.user_login_ID, wo.wo_requestor
		   ,isnull((select top 1 rtrim(fp.wk_firstName) + fp.wk_lastName from f_personnel fp 
		     join f_workorderTaskSchedule wts on wts.wos_wk_fk = fp.wk_pk and wts.wos_woTask_fk = wot.wotask_pk
		      ), '-') as AssignedTechnician
		   --, wo.wo_itemType_fk, wo.wo_tag_fk, wo.wo_fu_fk, wo.wo_fd_fk, wo_fb_fk
FROM        dbo.f_workorder wo 
            LEFT OUTER JOIN dbo.f_area fu ON wo.wo_fu_fk = fu.fu_pk 
            INNER JOIN dbo.f_building fb ON wo_fb_fk=fb_pk
			INNER JOIN dbo.f_facility fd on fd.fd_pk = wo.wo_fd_fk
                     INNER JOIN f_workorderTask wot ON woTask_wo_fk=wo_pk
                     INNER JOIN f_jobLibrary jl ON wot.woTask_fo_fk= jl.fo_pk
                     INNER JOIN f_jobType jt ON fo_fj_fk=jt.fj_pk
                     INNER JOIN f_users userCreatedBy ON wo_creator_fk=user_pk
					 LEFT OUTER JOIN f_workorderTaskComment wc on wc.wot_wotask_fk = wot.woTask_pk
WHERE      (fb.fb_name IN ('Claremore',
				'Glenpool',
				'GLN_CLA_24_MP009.82',
				'GLN_CLA_24_MP026.99',
				'Joplin',
				'Mount Vernon',
				'MTV_SPR_24_MP170.78',
				'Sarcoxie',
				'Springfield',
				'VIN_JOP_24_MP092.21',
				'VIN_JOP_24_MP100.18',
				'Vinita',
				'Badger',
				'Chatsworth',
				'Columbus',
				'DEC_CHA_24_MP541.58',
				'Decatur',
				'East Chicago',
				'Griffith',
				'Hammond',
				'Harbor Canal',
				'Irwin',
				'Kennedy',
				'Peotone',
				'Schererville',
				'White Oak',
				'Amoco',
				'East Saint Louis',
				'Gerald',
				'Lebanon',
				'Premcor',
				'Rolla',
				'Saint Louis',
				'Saint Peters',
				'Shell',
				'STP_WDR_24_MP379.59',
				'WDR_DEC_24_MP411.26',
				'WEL_STP_24_MP362.88',
				'Weldon Spring',
				'Wood River'))
           AND (jt.fj_code IN ('Malfunction')) 
           AND (wo.wo_requestDate  >= DATEADD(day,-14, GETDATE())) 
		   AND ((wo.wo_completionDate is NULL or wo.wo_completionDate = '') or ((wo.wo_completionDate  >= DATEADD(day,-14, GETDATE())) )) 
		   order by isnull(wo_completionDate, 0)


		   --select top 100 * from f_building where fb_code = 'GLN_CLA_ROBV009.82'
		   --select top 100 * from f_area
		   --select top 100 * from f_facility