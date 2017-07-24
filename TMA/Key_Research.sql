USE [WebTMA]
ALTER view [dbo].[KEYREPORT] AS
SELECT * FROM 
(SELECT CONVERT(DATE,MAX(ktr_date)) 'Transaction Date',CAST(ks.kser_serialNumber AS BIGINT) AS  Serial, ISNULL(ISNULL(c.kc_description, h.kh_firstName + ' ' +h.kh_lastName), 'N/A') AS 'Current Location'
,ROW_NUMBER() OVER (PARTITION BY ks.kser_serialNumber ORDER BY tr.ktr_date DESC) AS 'Rank'
, at.kaType_Description AS 'Action', ISNULL(c.kc_tagNumber, '-') AS 'Cabinet' 
,ISNULL( ISNULL(fc.fd_name, REPLACE(REPLACE(rc.rc_name, ' Area', ''), ' Departments', '')), 'Destroyed') AS Area, ISNULL(dpt.dp_name, '-') AS Department
, ISNULL(jl.fo_description, '-') AS ActionDetail, ISNULL(kh_position, '-') AS 'Holder Position'
	FROM dbo.f_keyTransaction tr
	LEFT OUTER JOIN dbo.f_keySerialized ks ON ks.kser_pk = tr.ktr_kser_fk
	LEFT OUTER JOIN dbo.f_keyAdjustment a ON a.kmov_pk = tr.ktr_kmov_fk
	LEFT OUTER JOIN dbo.f_keyQueue q ON q.kqueue_available_ktr_fk = tr.ktr_pk AND q.kqueue_unavailable_ktr_fk IS NULL
	LEFT OUTER JOIN dbo.f_keyCabinet c ON c.kc_pk = q.kqueue_kc_fk
	JOIN dbo.f_webtmaKeyAdjustmentType at ON at.katype_pk = tr.ktr_action_fk
	LEFT OUTER JOIN dbo.f_keyHolder h ON h.kh_pk = tr.ktr_kh_fk
	LEFT OUTER JOIN dbo.f_repairCenter rc ON rc.rc_pk = h.kh_rc_fk
	LEFT OUTER JOIN dbo.f_area ar ON ar.fu_pk = c.kc_fu_fk
	LEFT OUTER JOIN dbo.f_building bl ON bl.fb_pk = ar.fu_fb_fk
	LEFT OUTER JOIN dbo.f_facility fc ON fc.fd_pk = bl.fb_fd_fk
	LEFT OUTER JOIN dbo.f_department dpt ON dpt.dp_pk = h.kh_dp_fk
	LEFT OUTER JOIN f_workordertask wot ON wot.wotask_pk = ktr_woTask_fk 
	LEFT OUTER JOIN dbo.f_jobLibrary jl ON jl.fo_pk = wot.woTask_fo_fk
	GROUP BY ktr_date, KS.kser_serialNumber, c.kc_description,ISNULL(c.kc_description, h.kh_firstName + ' ' +h.kh_lastName),at.kaType_Description, rc.rc_name, c.kc_tagNumber
	,fc.fd_name, ISNULL(dpt.dp_name, '-'), ISNULL(jl.fo_description, '-'), kh_position
	) t WHERE t.rank = 1 AND t.Serial IS NOT NULL
GO


--'KEY-10277'


SELECT *   FROM f_keyadjustment
--1123, 1121, showing issued when it's been lost 
BEGIN TRANSACTION 
SELECT * FROM f_keyadjustment WHERE kmov_pk = 1135
ROLLBACK TRANSACTION

BEGIN TRANSACTION

SELECT s.kser_serialNumber AS SerialNum, tr.* FROM f_keytransaction tr JOIN dbo.f_keySerialized s ON s.kser_pk = tr.ktr_kser_fk  WHERE ktr_kser_fk IN (1566, 1574, 1826)

ROLLBACK TRANSACTION

BEGIN TRANSACTION
SELECT * FROM dbo.f_keySerialized WHERE kser_serialNumber IN ('20', '12', '136')

SELECT * FROM dbo.f_keyQueue WHERE kqueue_unavailable_ktr_fk IN (SELECT ktr_pk  FROM f_keytransaction tr JOIN dbo.f_keySerialized s ON s.kser_pk = tr.ktr_kser_fk  WHERE ktr_kser_fk IN (1566, 1574, 1826))
SELECT * FROM f_keytransaction WHERE ktr_kmov_fk = 1135
ROLLBACK TRANSACTION

SELECT * FROM dbo.f_keyCabinet

SELECT * INTO tempdb.dbo.keyqueue FROM dbo.f_keyQueue

--kser_pk	kser_serialNumber
--1566	12
--1574	20
--1826	136