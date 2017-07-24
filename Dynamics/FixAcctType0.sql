SELECT * FROM dbo.GL00100 WHERE ACTNUMBR_1 = '175806'


SELECT * FROM dbo.GL00100 WHERE ACCTTYPE = 0

SELECT * FROM dynamics.dbo.SY01500 WHERE act = 0

--6954 is dex row id

DECLARE @MyOutput table(
   OldNOTEINDX numeric(19,5),
   NewNOTEINDX numeric(19,5)
   )
UPDATE DYNAMICS.dbo.SY01500
SET NOTEINDX = NOTEINDX + 1
OUTPUT deleted.NOTEINDX, inserted.NOTEINDX INTO @MyOutput
WHERE CMPANYID = 2
-- Make note of the NewNOTEINDX value and use in your GL00100 update(s) below
SELECT * FROM @MyOutput
SELECT NOTEINDX FROM DYNAMICS.dbo.SY01500 WHERE CMPANYID = 2

-- Fix each of the ACTINDX records by setting ACCTTYPE=1 and assign a generated next NOTEINDEX value
UPDATE GL00100 SET ACCTTYPE = 1, NOTEINDX = 1522160.00000 WHERE ACTINDX = 7552

