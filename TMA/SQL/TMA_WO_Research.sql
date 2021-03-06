--Area Query
SELECT fu_roomNumber, fu_description, fu_unitID, wo_number, wo_requestDate
,REPLACE(REPLACE(REPLACE(REPLACE(cast(wo_actionRequested as nvarchar(max)), CHAR(13) + CHAR(10), ' ... '), 
			CHAR(10) + CHAR(13), ' ... '), CHAR(13), ' '), CHAR(10), ' ... ') ActionRequested
,REPLACE(REPLACE(REPLACE(REPLACE(cast(wo_TechComments as nvarchar(max)), CHAR(13) + CHAR(10), ' ... '), 
			CHAR(10) + CHAR(13), ' ... '), CHAR(13), ' '), CHAR(10), ' ... ') TechComments
--,*
FROM [WebTMA].[dbo].[f_area] fa 
  join WebTMA.DBo.f_workorder fw on fw.wo_fu_fk = fa.fu_pk
  where  ISNUMERIC(left(fu_RoomNumber,3)) = 1 and wo_techComments is not null 
  

  

--Building Query
SELECT wo_number, wo_createdDate, *
  FROM [WebTMA].[dbo].[f_building] fb 
  join WebTMA.DBo.f_workorder fw on fw.wo_fb_fk = fb.fb_pk
  where ISNUMERIC(rtrim(left(fb_code,3))) = 1 and right(fb_name,3) != 'Old'
  --where fb_code = 'FNA' and wo_actionRequested not like '%Tank inspection%' and wo_fu_fk is not null
  

-- move area to building 
--select top 2000 * 
--from WebTMA.dbo.f_workorder fw
--join WebTMA.DBo.f_area fa on fw.wo_fu_fk = fu_pk