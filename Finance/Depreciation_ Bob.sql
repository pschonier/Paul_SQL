
DECLARE @ServiceMonth tinyint

SET @ServiceMonth = 1

WHILE (@ServiceMonth <= 12) BEGIN
       SELECT A.*, B.DeprRate, ROUND(A.AMNT * B.DeprRate, 2) Depreciation
       , '825445-' + CASE OCompId WHEN '02' THEN '8' ELSE (SELECT AcctLoc.Department FROM AcctLoc WHERE AcctLoc.Location = A.ACCT_LOC) END + '-'
                 + CASE OCompId WHEN '02' THEN '381' ELSE ACCT_LOC END + '-0-0000' 'GL Account'
       FROM Assets AS A INNER JOIN SubAccounts AS B 
       ON (A.ACCT_PR = B.PRID) AND (A.ACCT_SUB = B.SubID)
       WHERE (((A.ACCT_GL) = '30')) AND (((A.ServiceYear * 100 + A.ServiceMonth) <= 1400 + @ServiceMonth OR (A.ServiceYear * 100 + A.ServiceMonth) >= 5001))
       ORDER BY A.OCompID, A.ACCT_PR, A.ACCT_SUB, ACCT_LOC, B.DeprRate
       SET @ServiceMonth = @ServiceMonth + 1
END
