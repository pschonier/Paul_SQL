SELECT * FROM dbo.f_keyQueue

SELECT * FROM dbo.f_repairCenter

alter VIEW dbo.KEYREPORT as
SELECT * FROM 
(SELECT CONVERT(DATE,MAX(ktr_date)) 'Transaction Date',CAST(ks.kser_serialNumber AS BIGINT) AS  Serial, ISNULL(ISNULL(c.kc_description, h.kh_ID), 'N/A') AS 'Current Location'
,ROW_NUMBER() OVER (PARTITION BY ks.kser_serialNumber ORDER BY tr.ktr_date DESC) AS 'Rank'
, at.kaType_Description AS 'Action', ISNULL(c.kc_tagNumber, '-') AS 'Cabinet' 
, ISNULL(fc.fd_name, REPLACE(REPLACE(rc.rc_name, ' Area', ''), ' Departments', '')) AS Area, ISNULL(dpt.dp_name, '-') AS Department
, ISNULL(jl.fo_description, '-') AS ActionDetail
	FROM dbo.f_keyTransaction tr
	LEFT OUTER JOIN dbo.f_keySerialized ks ON ks.kser_pk = tr.ktr_kser_fk
	LEFT OUTER JOIN dbo.f_keyAdjustment a ON a.kmov_pk = tr.ktr_kmov_fk
	JOIN dbo.f_keyQueue q ON q.kqueue_available_ktr_fk = tr.ktr_pk AND q.kqueue_unavailable_ktr_fk IS NULL
	LEFT OUTER JOIN dbo.f_keyCabinet c ON c.kc_pk = q.kqueue_kc_fk
	JOIN dbo.f_webtmaKeyAdjustmentType at ON at.katype_pk = tr.ktr_action_fk
	LEFT OUTER JOIN dbo.f_keyHolder h ON h.kh_pk = tr.ktr_kh_fk
	LEFT OUTER JOIN dbo.f_repairCenter rc ON rc.rc_pk = h.kh_rc_fk
	LEFT OUTER JOIN dbo.f_area ar ON ar.fu_pk = c.kc_fu_fk
	LEFT OUTER JOIN dbo.f_building bl ON bl.fb_pk = ar.fu_fb_fk
	LEFT OUTER JOIN dbo.f_facility fc on fc.fd_pk = bl.fb_fd_fk
	LEFT OUTER JOIN dbo.f_department dpt ON dpt.dp_pk = h.kh_dp_fk
	LEFT OUTER JOIN f_workordertask wot ON wot.wotask_pk = ktr_woTask_fk 
	LEFT OUTER JOIN dbo.f_jobLibrary jl ON jl.fo_pk = wot.woTask_fo_fk
	GROUP BY ktr_date, KS.kser_serialNumber, c.kc_description,ISNULL(c.kc_description, h.kh_ID),at.kaType_Description, rc.rc_name, c.kc_tagNumber
	,fc.fd_name, ISNULL(dpt.dp_name, '-'), ISNULL(jl.fo_description, '-')
	) t WHERE t.rank = 1 
	--ORDER BY t.Serial
go


SELECT * FROM dbo.KEYREPORT ORDER BY CAST(Serial AS INT)



