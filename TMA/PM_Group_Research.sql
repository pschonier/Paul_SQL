SELECT DISTINCT g.grp_tagNumber FROM f_group g
LEFT OUTER JOIN dbo.f_genInspectionForm gi ON gi.GIF_PK = g.grp_gif_fk
LEFT OUTER JOIN dbo.f_pm_schedules s ON s.pm_fo_fk = gi.GIF_FO_FK
WHERE gif_fo_fk = 547505 AND g.grp_active = 1
--sELECT * FROM f_users

--UPDATE f_users SET user_active = 0 WHERE user_login_ID LIKE '%ISD%'


--SELECT grp_tagNumber, COUNT(*) FROM dbo.f_group GROUP BY grp_tagNumber ORDER BY COUNT(*)


--SELECT * FROM dbo.f_genInspectionForm


--SELECT * FROM dbo.f_group