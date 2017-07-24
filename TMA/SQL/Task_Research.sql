declare @area nvarchar(30)
declare @tasktype nvarchar(100)
declare @startdate datetime
declare @enddate datetime
declare @status varchar (10)
set @tasktype = 'Malfunction'
set @startdate = '2014-1-1'
set @enddate = getdate()

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
      



					  select top 1000 * from f_building
					  select top 1000 * from f_facility
					  select top 1000 * from f_area
					  select * from f_workorderTask fwt join f_workorder fwo on fwo.wo_pk = fwt.wotask_wo_fk order by woTask_completionDate desc
					  select top 1000 * from f_equipment order by fm_createdDate desc
					  select top 1000 * from f_jobType
					  select * from f_users
					  select * from f_request
					  select top 1000 * from f_workorder

					 --YOU CANNOT HAVE A WORKORDER ASSIGNED TO A PIECE OF EQUIPMENT -- or can you? Awaiting response from Dan M.

					 
					  --INNER JOIN
       --               dbo.f_building ON dbo.f_area.fu_fb_fk = dbo.f_building.fb_pk ON dbo.f_users.user_pk = dbo.f_workorder.wo_creator_fk INNER JOIN
					  --dbo.f_facility fd on fd_pk = f_building.fb_fd_fk Join
       --               dbo.f_workorderTask ON dbo.f_workorder.wo_pk = dbo.f_workorderTask.woTask_wo_fk LEFT OUTER JOIN
       --               dbo.f_jobLibrary ON dbo.f_workorderTask.woTask_fo_fk = dbo.f_jobLibrary.fo_pk on dbo.f_jobType.fj_pk = dbo.f_jobLibrary.fo_fj_fk

	   select * from f_workorder fwo 
	   join f_equipment fe on fe.fm_pk = fwo.wo_itemType_fk

SELECT sc.name +'.'+ ta.name TableName
,SUM(pa.rows) RowCnt
FROM sys.tables ta
INNER JOIN sys.partitions pa
ON pa.OBJECT_ID = ta.OBJECT_ID
INNER JOIN sys.schemas sc
ON ta.schema_id = sc.schema_id
WHERE ta.is_ms_shipped = 0 and sc.name +'.'+ ta.name = 'dbo.f_workorder' -- use schema+table ex: dbo.users
group by sc.name, ta.name

select * from sys.partitions