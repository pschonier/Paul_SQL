SELECT * FROM dbo.GL10110 WHERE ACTINDX = 3086 AND PERIODID = 11
SELECT * FROM dbo.GL10110 WHERE ACTINDX = 1246 AND PERIODID = 11
SELECT * FROM gl00105 WHERE ACTNUMST ='560083-0-000-0-9002'-- '825881-9-381-0-0000' --



BEGIN TRAN
UPDATE gl10110 SET DEBITAMT = DEBITAMT + 550.78 WHERE ACTINDX = 1246 AND PERIODID = 11
ROLLBACK TRAN



--short ON MR income STATEMENT 


--