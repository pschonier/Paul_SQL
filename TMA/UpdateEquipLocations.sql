
BEGIN TRANSACTION
UPDATE dbo.f_equipment
  SET fm_fd_fk = (SELECT fd_pk FROM f_facility WHERE fd_name = m.[Area Name]),
  fm_fb_fk = (SELECT fb_pk FROM f_building WHERE fb_name = m.[Location Name]),
  fm_fu_fk = (SELECT fu_pk FROM f_area ar WHERE ar.fu_roomNumber = m.[Slot #] AND m.[Location Name] = (SELECT fb_name FROM f_building b WHERE fb_pk = ar.fu_fb_fk))
FROM dbo.f_equipment e
JOIN tempdb.dbo.massequipupdate m ON m.[Tag #] = e.fm_tagNumber
ROLLBACK TRANSACTION


SELECT m.[Description], fb_name, a.* from tempdb.dbo.f_equipment_test t
JOIN f_area a ON a.fu_pk = t.fm_fu_fk
JOIN dbo.f_building b ON b.fb_pk = t.fm_fb_fk
JOIN dbo.f_facility f ON f.fd_pk = b.fb_fd_fk
JOIN tempdb.dbo.massequipupdate m ON m.[Tag #] = t.fm_tagNumber
WHERE fb_name = 'Holdenville'


SELECT * FROM tempdb.dbo.massequipupdate 
WHERE [Location Name] = 'Holdenville'