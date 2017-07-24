SELECT * FROM dbo.f_key
SELECT * FROM dbo.f_keyAdjustment WHERE kmov_
SELECT * FROM dbo.f_keyQueue WHERE kqueue_unavailable_ktr_fk = 563037
SELECT * FROM dbo.f_keySerialized WHERE kser_serialNumber = 260
	SELECT * FROM dbo.f_keyAdjustment 
	SELECT * FROM dbo.f_keyCabinet -- 1006 = Tulsa
SELECT * FROM dbo.f_webtmaKeyAdjustmentType
SELECT * FROM dbo.f_keyTransaction tr
	LEFT OUTER JOIN dbo.f_keySerialized ks ON ks.kser_pk = tr.ktr_kser_fk
	LEFT OUTER JOIN dbo.f_keyAdjustment a ON a.kmov_pk = tr.ktr_kmov_fk
	LEFT OUTER JOIN dbo.f_keyQueue q ON q.kqueue_available_ktr_fk = tr.ktr_pk AND q.kqueue_unavailable_ktr_fk IS NULL
	LEFT OUTER JOIN dbo.f_keyCabinet c ON c.kc_pk = q.kqueue_kc_fk
	JOIN dbo.f_webtmaKeyAdjustmentType at ON at.katype_pk = tr.ktr_action_fk
	WHERE ks.kser_serialNumber=36

	BEGIN TRAN
	update dbo.f_keyQueue SET kqueue_kc_fk = 1006 WHERE kqueue_pk = 6048
	ROLLBACK TRAN
	
	BEGIN TRAN
	DELETE FROM dbo.f_keyTransaction WHERE ktr_pk = 563178
	ROLLBACK TRAN

	delete FROM dbo.f_keySerialized WHERE kser_serialNumber = '122'


	INSERT INTO dbo.f_keyQueue
	        ( kqueue_clnt_fk ,
	          kqueue_available_ktr_fk ,
	          kqueue_lost_ktr_fk ,
	          kqueue_found_ktr_fk ,
	          kqueue_extend_ktr_fk ,
	          kqueue_unavailable_ktr_fk ,
	          kqueue_locationType ,
	          kqueue_isAvailable ,
	          kqueue_isLost ,
	          kqueue_ky_fk ,
	          kqueue_kser_fk ,
	          kqueue_kc_fk ,
	          kqueue_kh_fk ,
	          kqueue_kr_fk ,
	          kqueue_unDocumentedTransaction
	        )
SELECT 
       kqueue_clnt_fk ,
       563275 ,
       kqueue_lost_ktr_fk ,
       kqueue_found_ktr_fk ,
       kqueue_extend_ktr_fk ,
       563275,
       kqueue_locationType ,
       kqueue_isAvailable ,
       kqueue_isLost ,
       kqueue_ky_fk ,
       1816 ,
       kqueue_kc_fk ,
       kqueue_kh_fk ,
       kqueue_kr_fk ,
       kqueue_unDocumentedTransaction FROM dbo.f_keyQueue WHERE kqueue_unavailable_ktr_fk = 563037


SELECT  [Transaction Date] ,
        Serial ,
        [Current Location] ,
        [Rank] ,
        [Action] ,
        Cabinet ,
        Area ,
        Department ,
        CASE WHEN [Action] = 'Issue Key'
                  AND ActionDetail = '-' THEN 'Issue Key to Key Holder'
             WHEN [Action] = 'Create'
                  AND Cabinet != '-' THEN 'Create to Cabinet'
             WHEN [Action] = 'Destroy' THEN [Action]
			 WHEN [Action] = 'Create' AND Area = 'Destroyed' THEN [Action] -- Ask Sansone
             ELSE ActionDetail
        END AS [ActionDetail] ,
        [Holder Position]
FROM    KEYREPORT
WHERE   Area IN ( @Area )
ORDER BY Area ,
        Serial;

