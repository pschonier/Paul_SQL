--SELECT * FROM dbo.f_repairCenter

--SELECT * FROM dbo.f_facility

--SELECT * FROM dbo.f_equipment WHERE fm_tagNumber = '008383'


--SELECT * FROM dbo.f_equipmentRepairCenterLink WHERE fmrc_fm_fk = 1503541



BEGIN TRANSACTION
UPDATE dbo.f_equipmentRepairCenterLink SET fmrc_rc_fk = rc.rc_pk
FROM dbo.f_equipmentRepairCenterLink rcl
JOIN tempdb.dbo.TMARepairCentFix tr ON tr.[Tag #] = (SELECT fm_tagNumber FROM dbo.f_equipment WHERE fm_pk = rcl.fmrc_fm_fk)
JOIN dbo.f_facility f ON f.fd_name = tr.[Area Name]
JOIN f_repairCenter rc ON rc.rc_code = f.fd_code
ROLLBACK TRANSACTION


--michelle keeley


SELECT * INTO f_equipmentRCLink_Backup FROM dbo.f_equipmentRepairCenterLink 