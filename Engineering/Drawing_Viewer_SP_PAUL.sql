USE [Assets]

--Create temp tables
--drop table assets.dbo.temp_Paul_north
--drop table assets.dbo.temp_Paul_south
--Select * into assets.dbo.TEMP_Paul_North from [Assets].[dbo].view_DrawingDescriptions_North
--Select * into assets.dbo.TEMP_Paul_South from [Assets].[dbo].view_DrawingDescriptions_South


--update Catalog - PJS 1/12/2015

declare @Paths table 
(
pathfile nvarchar(max)
)

insert into @Paths (pathfile)
(select pathfile from temp_paul_north union select pathfile from temp_paul_south)
delete from SYS_DrawingCatalog
insert into SYS_DrawingCatalog (pathfile)  (select pathfile from @Paths)



-- Create temporary SYS_DrawingDescriptions table
create table SYS_DrawingDescriptions(pathfile varchar(max), Description varchar(max))
insert into sys_drawingdescriptions(pathfile,description)
select pathfile,'Description' =

                expr1 + ' - ' + expr2 + ' - ' + expr3 + ' - ' + expr4
from dbo.temp_Paul_North

insert into sys_drawingdescriptions(pathfile,description)

select pathfile,'Description' =

                expr1 + ' - ' + expr2 + ' - ' + expr3 + ' - ' + expr4
from dbo.temp_paul_south







--2009.06.04 JVS
--Update drawing catalog descriptions



update dc
set dc.description = dd.Description
from SYS_DrawingCatalog as dc inner join sys_drawingdescriptions as dd on dc.pathfile = dd.pathfile


--2009.06.04 JVS
--Remove temporary SYS_DrawingDescriptions table
--
drop table sys_drawingdescriptions
--
--2009.06.06 JVS
--Insert records so drawings get categorized into areas
--
insert into SYS_DrawingCatalog(asset_id,discipline)
values(100,'District')
insert into SYS_DrawingCatalog(asset_id,discipline)
values(1000,'District')
insert into SYS_DrawingCatalog(asset_id,discipline)
values(4300,'District')
insert into SYS_DrawingCatalog(asset_id,discipline)
values(5300,'District')
insert into SYS_DrawingCatalog(asset_id,discipline)
values(11300,'District')
insert into SYS_DrawingCatalog(asset_id,discipline)
values(13200,'District')
insert into SYS_DrawingCatalog(asset_id,discipline)
values(16200,'District')
--
--2009.06.04 JVS
--Update drawing catalog asset_ids
--
update SYS_DrawingCatalog
set asset_link = substring(pathfile,19,charindex('/',substring(pathfile,19,999))-1)  from SYS_DrawingCatalog where pathfile like '%Facilities%'
update SYS_DrawingCatalog
set asset_link = substring(pathfile,19,charindex('/',substring(pathfile,19,999))-1)  from SYS_DrawingCatalog where pathfile like '%Pipelines%'
update dc
set dc.asset_id = asset.asset_id
from SYS_DrawingCatalog as dc inner join sys_asset as asset on dc.asset_link = asset.dwg_path
--from SYS_DrawingCatalog as dc inner join sys_asset as asset on left(RIGHT(rtrim(pathfile),CHARINDEX('/',REVERSE(rtrim(pathfile)))-1)
--,len(RIGHT(rtrim(pathfile),CHARINDEX('/',REVERSE(rtrim(pathfile)))-1))-4) = ltrim(rtrim(asset.dwg_path))
--select dwg_path, * from SYS_Asset
--select
--asset_link
--from SYS_DrawingCatalog


--2009.06.18 JVS
--Remap asset_id for Accounting Code 225
--
update SYS_DrawingCatalog
set asset_id = 4400
where asset_id = 3900 and pathfile = 'Assets/Pipelines/225_Houston_to_Greenville/Alignment_Sheets/225-226-AA-1084.jpg'
--
--2009.06.04 JVS
--Update drawing catalog shortcuts
--
update dc
set dc.pathfile = sc.target
from SYS_DrawingCatalog as dc inner join sys_drawingshortcut as sc on dc.pathfile = sc.shortcut
--
--2009.06.04 JVS
--Replace UNC with URL slashes
--
update SYS_DrawingCatalog
set pathfile = replace(pathfile,'F:\','')
update SYS_DrawingCatalog
set pathfile = replace(pathfile,'\','/')
--
--2009.06.18 JVS
--Remap drawing asset-ids to account for mid-line district boundaries
--
update SYS_DrawingCatalog
set SYS_DrawingCatalog.asset_id = sys_drawing_remap.asset_id
from SYS_DrawingCatalog inner join sys_drawing_remap on SYS_DrawingCatalog.pathfile = sys_drawing_remap.pathfile
--
--2009.0618 JVS
--Cross reference alignment sheets that span district boundaries
--
--Port Arthur and Houston Districts
--
insert into SYS_DrawingCatalog(drawing_id,pathfile,discipline,description)
select drawing_id,pathfile,discipline,description from SYS_DrawingCatalog
where pathfile = 'Assets/Pipelines/222_Port_Arthur_to_Houston/Alignment_Sheets/222-AA-1026.jpg'
update SYS_DrawingCatalog
set asset_id = 1100
where asset_id is null and pathfile = 'Assets/Pipelines/222_Port_Arthur_to_Houston/Alignment_Sheets/222-AA-1026.jpg'
--
--Houston and Greenville Districts
--
insert into SYS_DrawingCatalog(drawing_id,pathfile,discipline,description)
select drawing_id,pathfile,discipline,description from SYS_DrawingCatalog
where pathfile = 'Assets/Pipelines/225_Houston_to_Greenville/Alignment_Sheets/225-AA-1064.jpg'
update SYS_DrawingCatalog
set asset_id = 4400
where asset_id is null and pathfile = 'Assets/Pipelines/225_Houston_to_Greenville/Alignment_Sheets/225-AA-1064.jpg'
--
--Greenville and Arlington Districts
--
insert into SYS_DrawingCatalog(drawing_id,pathfile,discipline,description)
select drawing_id,pathfile,discipline,description from SYS_DrawingCatalog
where pathfile = 'Assets/Pipelines/231_Greenville_to_Carrollton/Alignment_Sheets/231-AA-1006.jpg'
update SYS_DrawingCatalog
set asset_id = 5400
where asset_id is null and pathfile = 'Assets/Pipelines/231_Greenville_to_Carrollton/Alignment_Sheets/231-AA-1006.jpg'
--
--Glenpool and Wood River Districts
--
insert into SYS_DrawingCatalog(drawing_id,pathfile,discipline,description)
select drawing_id,pathfile,discipline,description from SYS_DrawingCatalog
where pathfile = 'Assets/Pipelines/421_Oklahoma_State_Line_to_Mississippi_River/Alignment_Sheets/421-AA-1168.jpg'
update SYS_DrawingCatalog
set asset_id = 13300
where asset_id is null and pathfile = 'Assets/Pipelines/421_Oklahoma_State_Line_to_Mississippi_River/Alignment_Sheets/421-AA-1168.jpg'
--
--2009.0623 JVS
--Assemble route segments into line segments
--
--12" LKC to PTA (LA/TX State Line)
--
update SYS_DrawingCatalog
set asset_id = 300 
where discipline = 'Alignment Sheets' and (asset_id >= 330 and asset_id <= 360)
--
--10" ALD to ARL (HOU District)
--
update SYS_DrawingCatalog
set asset_id = 3400 
where discipline = 'Alignment Sheets' and (asset_id >= 3450 and asset_id <= 3850)
--
--10" ALD to ARL (ARL District)
--
update SYS_DrawingCatalog
set asset_id = 7900 
where discipline = 'Alignment Sheets' and (asset_id >= 8000 and asset_id <= 8400)
--
--12" GVL to GRP (ARL District)
--
update SYS_DrawingCatalog
set asset_id = 5400 
where discipline = 'Alignment Sheets' and (asset_id >= 5450 and asset_id <= 5550)
--
--28" GVL to GLN (GVL District + TX/OK State Line)
--
update SYS_DrawingCatalog
set asset_id = 10800 
where discipline = 'Alignment Sheets' and (asset_id >= 10850 and asset_id <= 11200)
--
--28" GVL to GLN (GLN District)
--
update SYS_DrawingCatalog
set asset_id = 11400 
where discipline = 'Alignment Sheets' and (asset_id >= 11450 and asset_id <= 11700)
--
--24" GLN to WDR (GLN District + OK/MO State Line)
--
update SYS_DrawingCatalog
set asset_id = 12400 
where discipline = 'Alignment Sheets' and (asset_id >= 12450 and asset_id <= 13100)
--
--24" GLN to WDR (WDR District)
--
update SYS_DrawingCatalog
set asset_id = 13300 
where discipline = 'Alignment Sheets' and (asset_id >= 13350 and asset_id <= 14000)
--
--14" ESL to STL (IL/MO State Line)
--
update SYS_DrawingCatalog
set asset_id = 15600 
where discipline = 'Alignment Sheets' and (asset_id >= 15630 and asset_id <= 15700)
--
--24" WDR to SCH (WDR District)
--
update SYS_DrawingCatalog
set asset_id = 16000 
where discipline = 'Alignment Sheets' and (asset_id >= 16050 and asset_id <= 16100)
--
--24" WDR to SCH (HMD District + IL/IN State Line)
--
update SYS_DrawingCatalog
set asset_id = 16300 
where discipline = 'Alignment Sheets' and (asset_id >= 16350 and asset_id <= 16900)
--
--2009.0618 JVS
--Fix MS River Crossing shortcuts where there are accounting code changes
--
--  Delete records referencing decoded shortcuts under \423 and \521 folders
--
delete from SYS_DrawingCatalog where pathfile like '%421-423%' and asset_id = 13300
--
--  Update asset_id to catalog this alignment sheet under WDR's district
--
update SYS_DrawingCatalog set asset_id = 13300 where pathfile like '%421-423%' and description is not null
--
--2012.0317 JVS
--Calculate class of drawing based on numeric category in "Drafting Standards 7-17-12.doc"
--
update SYS_DrawingCatalog set [Class] = 'Isometrics'                  where pathfile like '%/_0[0-9][0-9][0-9]%' ESCAPE '/'
update SYS_DrawingCatalog set [Class] = 'Civil/ Alignments'           where pathfile like '%/_1[0-9][0-9][0-9]%' ESCAPE '/'
update SYS_DrawingCatalog set [Class] = 'Architectural'               where pathfile like '%/_2[0-9][0-9][0-9]%' ESCAPE '/'
update SYS_DrawingCatalog set [Class] = 'Concrete'                    where pathfile like '%/_3[0-9][0-9][0-9]%' ESCAPE '/'
update SYS_DrawingCatalog set [Class] = 'Structural'                  where pathfile like '%/_4[0-9][0-9][0-9]%' ESCAPE '/'
update SYS_DrawingCatalog set [Class] = 'Vessels'                     where pathfile like '%/_5[0-9][0-9][0-9]%' ESCAPE '/'
update SYS_DrawingCatalog set [Class] = 'Piping'                      where pathfile like '%/_6[0-9][0-9][0-9]%' ESCAPE '/'
update SYS_DrawingCatalog set [Class] = 'Instrumentation/ Hydraulics' where pathfile like '%/_7[0-9][0-9][0-9]%' ESCAPE '/'
update SYS_DrawingCatalog set [Class] = 'Mechanical Equipment'        where pathfile like '%/_8[0-9][0-9][0-9]%' ESCAPE '/'
update SYS_DrawingCatalog set [Class] = 'Electrical'                  where pathfile like '%/_9[0-9][0-9][0-9]%' ESCAPE '/'
--
--2012.0317 JVS
--Adjustment to create a 'Cathodic Protection' class of drawing to ease querying by Corrosion group
--
update SYS_DrawingCatalog set Class = 'Cathodic Protection'         where pathfile like '%/_CP/_%' ESCAPE '/'
--
--2012.0317 JVS
--Adjustments for drawings where class could not be defined due to non-standard filename or that pesky 'District' discipline
--
update SYS_DrawingCatalog set discipline = 'Elec' where pathfile like '%/Elec/%'
update SYS_DrawingCatalog set discipline = 'MechCivil' where pathfile like '%/MechCivil/%'
update SYS_DrawingCatalog set discipline = 'PID' where pathfile like '%/PID/%'
update SYS_DrawingCatalog set discipline = 'Alignment Sheets' where pathfile like '%Alignment_Sheets%'
update SYS_DrawingCatalog set Class = 'Civil/ Alignments' where Class is null and discipline = 'Alignment Sheets'

--
--Enhancement: Write out view in sorted order to final table
--
--drop table SYS_Drawing_Catalog
--select * into SYS_Drawing_Catalog from view_AssetDrawingCatalog

--drop temp tables
--drop table temp_Paul_north
--drop table temp_Paul_south


select distinct Asset_link, * from SYS_DrawingCatalog where asset_id is null

select * from sys_asset order by DWG_Path