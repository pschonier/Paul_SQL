SELECT
	['Internet Addresses'].Master_ID AS 'Vendor ID'
	,['Internet Addresses'].ADRSCODE AS 'Address Code'
	,['Internet Addresses'].EmailToAddress AS 'Email To Address'
	,['Internet Addresses'].EmailCcAddress AS 'Email Cc Address'
	,['Internet Addresses'].EmailBccAddress AS 'Email Bcc Address'
	,['Internet Addresses'].INET1 AS 'Email'
	,p.COMMENT1, p.COMMENT2
FROM
	SY01200 AS ['Internet Addresses']
	RIGHT OUTER JOIN pm00200 p ON p.VENDORID = ['Internet Addresses'].Master_ID
WHERE
	['Internet Addresses'].Master_Type = 'VEN' AND p.VENDSTTS = 1





	SELECT * FROM dbo.PM00200