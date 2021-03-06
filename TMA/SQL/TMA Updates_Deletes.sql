/****** Script for SelectTopNRows command from SSMS  ******/


begin transaction
delete from dbo.f_workorder where wo_pk in (
SELECT wo_pk FROM [master].[dbo].[TMAPaulDelete] tpd
join webtma.dbo.f_workorder wo on tpd.wo_number = wo.wo_number)
rollback transaction

begin transaction
update dbo.f_workordertask  
set wotask_wo_fk = 0 
from dbo.f_workordertask wot 
where wot.wotask_wo_fk in (SELECT wo_pk FROM [master].[dbo].[TMAPaulDelete] tpd
join webtma.dbo.f_workorder wo on tpd.wo_number = wo.wo_number)
rollback transaction


select wo.wo_number, woTask_pk, wo.wo_actionrequested, jl.fo_code, jl.fo_description from f_workordertask wot 
join f_jobLibrary jl on jl.fo_pk = wot.woTask_fo_fk
join f_workorder wo on wo.wo_pk = wot.woTask_wo_fk
where wot.woTask_wo_fk in 
(SELECT wo_pk FROM [master].[dbo].[TMAPaulDelete] tpd
join webtma.dbo.f_workorder wo on tpd.wo_number = wo.wo_number)


select * from f_workorder where wo_pk in 

(SELECT wo_pk FROM [master].[dbo].[TMAPaulDelete] tpd
join webtma.dbo.f_workorder wo on tpd.wo_number = wo.wo_number)

begin transaction 
delete from f_workordertask where 
woTask_wo_fk in (SELECT wo_pk FROM [master].[dbo].[TMAPaulDelete] tpd
join webtma.dbo.f_workorder wo on tpd.wo_number = wo.wo_number)
rollback transaction



begin transaction 
update f_workorder
set wo_tag_fk = wo_fb_fk -- set wo_itemtype_fk = 9
where wo_number in  (select wo_number from tempdb.dbo.TMAPaul)
rollback transaction
select * from f_workorder where wo_number in (select wo_number from tempdb.dbo.TMAPaul)