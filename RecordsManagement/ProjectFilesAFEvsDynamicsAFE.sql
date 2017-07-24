
SELECT * FROM (
(SELECT 'OPEN' AS AFEStatus, me_job_id FROM epco.dbo.me97708) 
UNION all
(SELECT 'CLOSED' AS AFEStatus, ME_Job_ID FROM epco.dbo.me97707)) a
WHERE a.ME_Job_ID NOT IN (SELECT DISTINCT afe FROM dbo.vwProjectWithAFE)
AND ISNUMERIC(a.me_job_id) = 1
ORDER BY a.AFEStatus DESC, me_job_id
