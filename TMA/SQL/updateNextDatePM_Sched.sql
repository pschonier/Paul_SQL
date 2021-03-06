

 SELECT DATEADD(Month, DateDiff(Month, 0, pm_nextDate), 0) , fo_code, fo_description, pm_nextDate, pm_lastDate FROM dbo.f_pm_schedules pm
 JOIN dbo.f_jobLibrary fo  ON fo.fo_pk = pm.pm_fo_fk
WHERE SUBSTRING(CAST(pm_nextDate AS NVARCHAR),5,2) !=' 1' 


BEGIN TRANSACTION
UPDATE dbo.f_pm_schedules SET pm_nextDate = DATEADD(Month, DateDiff(Month, 0, pm_nextDate), 0) 
WHERE SUBSTRING(CAST(pm_nextDate AS NVARCHAR),5,2) !=' 1' 
ROLLBACK TRANSACTION