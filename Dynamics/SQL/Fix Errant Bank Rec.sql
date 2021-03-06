--Delete errant transaction 
BEGIN TRANSACTION
DELETE FROM cm20200 WHERE CMTrxNum = 'XFR000008162'
ROLLBACK TRANSACTION

--Admust total for accounts properly. Both the "to" and "from" will need to be adjusted accordingly
--update CM00100 SET CURRBLNC = CURRBLNC-30562.07 where CHEKBKID = 'BOKCDA'


SELECT TOP 1000 * FROM cm20200 WHERE TRXAMNT = 50169.88
ORDER BY TRXDATE DESC --WHERE CMTrxNum LIKE 'PYMNT%21959'

BEGIN TRANSACTION
delete FROM dbo.CM20300
WHERE (SRCDOCNUM LIKE 'PYMNT%2196%' OR SRCDOCNUM LIKE 'PYMNT%2195%' OR 
SRCDOCNUM LIKE 'PYMNT%2194%') AND CHEKBKID = 'BOKPAYABLES' AND DEPOSITED = 0
ROLLBACK TRANSACTION

BEGIN TRANSACTION
delete fROM cm20100 WHERE DEX_ROW_ID BETWEEN 224194 AND 224218 AND CHEKBKID = 'BOKPAYABLES'
AND AUDITTRAIL LIKE '%RMC%'
ROLLBACK TRANSACTION

BEGIN TRANSACTION
delete FROM cm20100 WHERE DEX_ROW_ID BETWEEN 224573 AND 224578 AND CHEKBKID = 'BOKPAYABLES'
AND AUDITTRAIL LIKE '%RMC%'
ROLLBACK TRANSACTION

BEGIN TRANSACTION
delete FROM dbo.CM20300 WHERE DEPOSITED = 0 and SRCDOCNUM LIKE 'PYMNT%2200%' 
AND CHEKBKID = 'BOKPAYABLES'
ROLLBACK TRANSACTION
