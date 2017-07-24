

select 
fd.fd_name as Area
,fb.fb_name as Location
,isnull(fu.fu_roomNumber, '_') as Slot
,case wo_itemType_fk when 0 then (select fm.fm_description from f_equipment fm where fm.fm_pk = wo.wo_tag_fk) else '_' end as EquipDescr
,isnull(fe.fm_tagNumber,'-') as EquipTag
,wo.wo_number as 'WO Number'
,wo_requestDate as DateRequested
,wo_completionDate as CompletionDate
,wo.wo_actionRequested as Requested
,isnull(clr_comment + REPLACE(REPLACE(REPLACE(REPLACE(cast(wo.wo_techComments as nvarchar(max)), CHAR(13) + CHAR(10), ' ... '), 
			CHAR(10) + CHAR(13), ' ... '), CHAR(13), ' '), CHAR(10), ' ... '),'-') as Comment
,case left(chk_description,11) when 'Record Pump' then (substring((REPLACE(REPLACE(chk_description,'.',''),'"',':')),25,len(rtrim(chk_description))-2)) else chk_description end as 'Value Type'
,clr_value as Value
,fo_code as TaskID
from f_mastercheck mc
join f_jobLibraryMasterCheckLink mcl  on mc.chk_pk = mcl.fochk_chk_fk
join f_masterCheckResult mcr on mcr.clr_chk_fk = mc.chk_pk
join f_joblibrary jl on jl.fo_pk = mcl.fochk_fo_fk
join f_jobType jt on jt.fj_pk = jl.fo_fj_fk
join f_workorderTask wot on wot.wotask_pk = mcr.clr_woTask_fk
join f_workorder wo on wo_pk = wot.wotask_wo_fk
LEFT OUTER JOIN dbo.f_area fu ON wo.wo_fu_fk = fu.fu_pk 
INNER JOIN dbo.f_building fb ON wo_fb_fk=fb_pk
INNER JOIN dbo.f_facility fd on fd.fd_pk = wo.wo_fd_fk
left outer join f_equipment fe on fe.fm_pk = wo.wo_tag_fk
--EPLDCC0 (corrosion coupon change), P00012S (pump end thrust), P00023A (tube turn annual), P00023V (tube turn 5-year)
