

SELECT   jt.fj_code,fb.fb_name,
			wo.wo_requestDate
			, wo.wo_completionDate
			,case  when  wo.wo_completionDate is NULL then 'OPEN' else 'CLOSED' end as "Status"
			, wo.wo_number
			, isnull(fu.fu_roomNumber, '_') as Slot
			,fd.fd_name as Area
			,fb.fb_name as Location
			,jt.fj_code
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
WHERE      (fd.fd_name IN (@Area)) AND (jt.fj_code IN (@TaskType)) AND (wo.wo_requestDate >= @StartDate) AND 
                      (ISDATE(wo.wo_completionDate) IN (@STATUS)) AND (wo.wo_requestDate < DATEADD(day, 1, @EndDate))





			
select * from f_building fb where fb.fb_name = 'East Saint Louis'
select distinct fd_name from f_facility where fd_pk != 89

select top 100 * from dbo.f_workorder wo where wo.wo_number = 'gln-25548'
--task types
select distinct  jt.fj_code from f_jobType jt where jt.fj_code not in ('AUTOTRACK JOBS','ZzAUTOTRACK JOBSzz','Key')
select top 100 * from dbo.f_workorderTask wt
select top 100 * from dbo.f_workorderTaskComment wc
select top 1000 * from dbo.f_area
select top 100 * from dbo.f_workorder wo where wo.wo_pk not in (select wotask_wo_fk from f_workorderTask)
--F_area = slot
--F_equipment = equipment
--select * from f_workorder wo where wo_tag_fk = 45
--select * from f_equipment fm order by fm.fm_pk asc




SELECT     wo.wo_requestDate, wo.wo_completionDate, wo.wo_number, dbo.f_area.fu_unitID, fd_name, dbo.f_building.fb_name,
                      dbo.f_jobType.fj_code, dbo.f_area.fu_description, dbo.f_jobLibrary.fo_description
					  , REPLACE(REPLACE(REPLACE(REPLACE(cast(wo.wo_actionRequested as nvarchar(max)), CHAR(13) + CHAR(10), ' ... '), 
			CHAR(10) + CHAR(13), ' ... '), CHAR(13), ' '), CHAR(10), ' ... ') Request 
			, wo.wo_creator_fk
			, dbo.f_users.user_login_ID
			, wo.wo_requestor
FROM         dbo.f_jobType RIGHT OUTER JOIN
                      dbo.f_users INNER JOIN
                      dbo.f_workorder wo right outer join
                      dbo.f_area ON wo.wo_fu_fk = dbo.f_area.fu_pk left outer join
                      dbo.f_building ON dbo.f_area.fu_fb_fk = dbo.f_building.fb_pk ON dbo.f_users.user_pk = wo.wo_creator_fk JOIN
					  dbo.f_facility fd on fd_pk = wo.wo_fd_fk join
                      dbo.f_workorderTask ON wo.wo_pk = dbo.f_workorderTask.woTask_wo_fk JOIN
                      dbo.f_jobLibrary ON dbo.f_workorderTask.woTask_fo_fk = dbo.f_jobLibrary.fo_pk on dbo.f_jobType.fj_pk = dbo.f_jobLibrary.fo_fj_fk
WHERE      (f_jobType.fj_code IN (@TaskType)) AND (wo.wo_requestDate >= @StartDate) AND 
                      (ISDATE(wo.wo_completionDate) IN (0,1)) AND (wo.wo_requestDate < DATEADD(day, 1, @EndDate))    
                       AND ((f_building.fb_name IN ('Glenpool','Arlington','Hammond','Wood River','Greenville','Houston','Port Arthur') or 
					   fd.fd_name IN ('Glenpool','Arlington','Hammond','Wood River','Greenville','Houston','Port Arthur'))) 
      
	  select distinct fd_name from dbo.f_building




	  select rtrim(fp.wk_firstName) +' '+ fp.wk_lastName, * from f_personnel fp 
		     join f_workorderTaskSchedule wts on wts.wos_wk_fk = fp.wk_pk 