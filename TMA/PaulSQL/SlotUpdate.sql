BEGIN TRANSACTION
UPDATE dbo.f_area SET fu_unitID = b.fb_code +'-'+ LTRIM( a.fu_roomNumber)
FROM dbo.f_area a
JOIN dbo.f_building b ON b.fb_pk = a.fu_fb_fk
JOIN tempdb.dbo.SlotChanges c ON c.[New Area Description] = a.fu_description
ROLLBACK TRANSACTION