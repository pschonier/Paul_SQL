
SELECT *FROM tempdb.dbo.f_areaBackup 

BEGIN TRANSACTION
UPDATE f_area SET fu_unitID = fb_code+'-'+a.fu_roomNumber
FROM f_area a 
JOIN f_building b ON b.fb_pk = a.fu_fb_fk
ROLLBACK TRANSACTION



SELECT * FROM dbo.f_area



