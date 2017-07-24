begin transaction
update dbo.f_building
set fb_y_coordinate = tl.y
from dbo.f_building fb
join tempdb.dbo.TMALatLong tl on tl.Code = fb.fb_code
where fb.fb_code = tl.Code
rollback transaction

--select top 100 fb_x_coordinate, fb_y_coordinate, * from f_building
--select top 100 * from tempdb.dbo.TMALatLong