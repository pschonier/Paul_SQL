/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 *
  FROM [WebTMA].[dbo].[f_workorder]



--begin transaction
--update f_request
--set log_fu_fk = NULL --log_fb_fk
--from f_request fr
--where log_wo_fk in (select wo_pk from paul_temp2)
--rollback transaction

begin transaction
update f_request
set log_comments = (select fu_unitID from f_area fa where fu_pk = fr.log_fu_fk) --log_fu_fk = NULL --log_fb_fk
from f_request fr
where fr.log_number between 14 and 7714
rollback transaction



begin transaction
update f_request 
set log_fu_fk = NULL
from f_request fr
where fr.log_number between 14 and 7714
rollback transaction

--workorder Task reassignment

begin transaction
update f_workorderTask
set woTask_fo_fk = 477175
from f_workorderTask w where w.wotask_pk in (
select fwt.woTask_pk from f_workorder fw
join f_workorderTask fwt on fwt.woTask_wo_fk = fw.wo_pk
join f_jobLibrary fjl on fjl.fo_pk = fwt.woTask_fo_fk
where fo_code in (select ec from tempdb.dbo.TMATemp_Paul))
rollback transaction

--select * into tempdb.dbo.f_workordertask from f_workordertask -- workordertask backup table

select * from f_joblibrary t
join f_jobType fj on fj.fj_pk = t.fo_fj_fk
--join f_workorderTask wt
--join f_workorder fw on fw.wo_log_fk = fw.wo_pk
where fo_code in (select ec from tempdb.dbo.TMATemp_Paul) 
--fo_code = 'GENERIC'
--fo_pk = 477175

begin transaction
update f_jobLibrary 
set fo_description = tj.fo_description --fo_description, fo_code
from f_jobLibrary j
join WebTma_Test.dbo.f_jobLibrary tj on tj.fo_pk = j.fo_pk
where tj.fo_code in (select ec from tempdb.dbo.TMATemp_Paul)
rollback transaction


--tag and type display
begin transaction
update webtma.dbo.f_workorder
set wo_tag_fk = wo_fb_fk
from webtma.dbo.f_workorder wo
where wo_pk in (select wo_pk from paul_temp)
rollback transaction


--select wo_pk, wo_number into webtma.dbo.paul_temp2  from f_workorder
--where wo_pk in (select wo_pk from paul_temp)


--select log_fd_fk, fd_name, wo_number, * from f_request r join f_facility f on f.fd_pk = r.log_fd_fk join f_workorder w on w.wo_pk = r.log_wo_fk where log_number between 14 and 7714 
--select * from f_facility
--select * from f_area
--select * from f_workorder
--select * from f_building 
--select * from f_request
--select * from f_joblibrary

select distinct left(wo_number,3) from f_request r join f_facility f on f.fd_pk = r.log_fd_fk join f_workorder w on w.wo_pk = r.log_wo_fk where log_number between 14 and 7714

--update relationship with requests
begin transaction
update f_request
set log_fd_fk = 1008
from f_request r
join f_facility f on f.fd_pk = r.log_fd_fk 
join f_workorder w on w.wo_pk = r.log_wo_fk 
where log_number between 14 and 7714 
and left(wo_number,2) = 'TD'
rollback transaction


select log_fd_fk, fd_name, wo_number, * 
from f_request r 
join f_facility f on f.fd_pk = r.log_fd_fk 
join f_workorder w on w.wo_pk = r.log_wo_fk 
where log_number between 14 and 7714 


select top 100 *, fwt.woTask_pk from f_workorder fw
join f_workorderTask fwt on fwt.woTask_wo_fk = fw.wo_pk
join f_jobLibrary fjl on fjl.fo_pk = fwt.woTask_fo_fk

