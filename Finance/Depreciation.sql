WITH CTEM AS ( SELECT A.OCompID, A.ACCT_LOC, A.ACCT_PR, B.DeprRate,
                     Sum(A.AMNT) AS SumOfAMNT 
               FROM Assets AS A INNER JOIN SubAccounts AS B
                  ON (A.ACCT_PR = B.PRID) AND (A.ACCT_SUB = B.SubID)
               WHERE (((A.ACCT_GL) = '30'))
               GROUP BY A.OCompID, A.ACCT_LOC, A.ACCT_PR, B.DeprRate 
                  HAVING (((A.ACCT_PR) <> '51') And ((Sum(A.AMNT)) <> 0)))


SELECT OCompID, ACCT_LOC, ACCT_PR, DeprRate, 
               SumOfAMNT, round([DeprRate]*[SumOfAMNT],2) AS DeprAmt 
            FROM (SELECT A.OCompID, A.ACCT_LOC, A.ACCT_PR, B.DeprRate,
                     Sum(A.AMNT) AS SumOfAMNT 
               FROM Assets AS A INNER JOIN SubAccounts AS B
                  ON (A.ACCT_PR = B.PRID) AND (A.ACCT_SUB = B.SubID)
               WHERE (((A.ACCT_GL) = '30'))
               GROUP BY A.OCompID, A.ACCT_LOC, A.ACCT_PR, B.DeprRate 
                  HAVING (((A.ACCT_PR) <> '51') And ((Sum(A.AMNT)) <> 0))) AS G


SELECT Y.ACCT_LOC, Y.OCompID, Sum(Y.DeprAmt) AS Depr 
               FROM (SELECT OCompID, ACCT_LOC, ACCT_PR, DeprRate, 
               SumOfAMNT, round([DeprRate]*[SumOfAMNT],2) AS DeprAmt 
            FROM (SELECT A.OCompID, A.ACCT_LOC, A.ACCT_PR, B.DeprRate,
                     Sum(A.AMNT) AS SumOfAMNT 
               FROM Assets AS A INNER JOIN SubAccounts AS B
                  ON (A.ACCT_PR = B.PRID) AND (A.ACCT_SUB = B.SubID)
               WHERE (((A.ACCT_GL) = '30'))
               GROUP BY A.OCompID, A.ACCT_LOC, A.ACCT_PR, B.DeprRate 
                  HAVING (((A.ACCT_PR) <> '51') And ((Sum(A.AMNT)) <> 0))) AS G) 
			   AS Y 
               GROUP BY Y.ACCT_LOC, Y.OCompID 
               ORDER BY Y.ACCT_LOC








--DEBIT
SELECT  '825445-' + CASE OCompID
                      WHEN '02' THEN '8'
                      ELSE ( SELECT AcctLoc.Department
                             FROM   AcctLoc
                             WHERE  AcctLoc.Location = Y.ACCT_LOC
                           )
                    END + '-' + CASE OCompID
                                  WHEN '02' THEN '381'
                                  ELSE ACCT_LOC
                                END + '-0-0000' AS GLAccount ,
        CASE Y.OCompID
          WHEN '01' THEN 'Pipeline'
          ELSE 'Services'
        END AS Company ,
        SUM(Y.DeprAmt) AS Depr ,
        CASE WHEN Y.ServiceYear BETWEEN 70 AND 99 THEN '19'
             ELSE '20'
        END + CAST(Y.ServiceYear AS VARCHAR) + '-'
        + CAST(Y.ServiceMonth AS VARCHAR) + '-' + '01' AS ServiceDate
FROM    ( SELECT    X.OCompID ,
                    X.ACCT_LOC ,
                    X.ACCT_PR ,
                    X.DeprRate ,
                    X.SumOfAMNT ,
                    ROUND([DeprRate] * [SumOfAMNT], 2) AS DeprAmt ,
                    X.ServiceYear ,
                    X.ServiceMonth
          FROM      ( SELECT    A.OCompID ,
                                A.ACCT_LOC ,
                                A.ACCT_PR ,
                                B.DeprRate ,
                                A.ServiceYear ,
                                A.ServiceMonth ,
                                SUM(A.AMNT) AS SumOfAMNT
                      FROM      Assets AS A
                                INNER JOIN SubAccounts AS B ON ( A.ACCT_PR = B.PRID )
                                                              AND ( A.ACCT_SUB = B.SubID )
                      WHERE     ( (( A.ACCT_GL ) = '30') )
                      GROUP BY  A.OCompID ,
                                A.ACCT_LOC ,
                                A.ACCT_PR ,
                                B.DeprRate ,
                                A.ServiceYear ,
                                A.ServiceMonth
                      HAVING    ( ( ( A.ACCT_PR ) <> '51' )
                                  AND ( ( SUM(A.AMNT) ) <> 0 )
                                )
                    ) AS X
        ) AS Y
WHERE   Y.ServiceYear = '15'
GROUP BY Y.ACCT_LOC ,
        Y.OCompID ,
        Y.ServiceYear ,
        Y.ServiceMonth
ORDER BY Y.ACCT_LOC;

--Credit
SELECT  CASE LEFT(Y.ACCT_LOC, 1)
          WHEN 2 THEN 'TX'
          WHEN 3 THEN 'OK'
          WHEN 4 THEN 'MO'
          WHEN 5 THEN 'IL'
          WHEN 6 THEN 'IN'
        END AS State ,
        Y.ACCT_PR ,
        CASE Y.OCompID
          WHEN '01' THEN 'Pipeline'
          ELSE 'Services'
        END AS Company ,
        Y.ServiceYear ,
        Y.ServiceMonth ,
        CASE WHEN Y.ServiceYear BETWEEN 71 AND 99 THEN '19'
             ELSE '20'
        END + CAST(Y.ServiceYear AS VARCHAR) + '-'
        + CAST(Y.ServiceMonth AS VARCHAR) + '-' + '01' AS ServiceDate ,
        SUM(Y.AMNT) AS Depr ,
        '31' + Y.ACCT_PR + '01' + '-' + CASE OCompID
                                          WHEN '01' THEN '9'
                                          ELSE '8'
                                        END + '-' + '00' + LEFT(Y.ACCT_LOC, 1)
        + '-0-0000' AS GLAccount
FROM    ( SELECT    A.OCompID ,
                    A.ACCT_LOC ,
                    A.ACCT_PR ,
                    --B.DeprRate ,
                    A.ServiceYear ,
                    A.ServiceMonth ,
                    SUM(A.AMNT) AS SumOfAMNT ,
                    A.AMNT
          FROM      Assets AS A
                    INNER JOIN SubAccounts AS B ON ( A.ACCT_PR = B.PRID )
                                                   AND ( A.ACCT_SUB = B.SubID )
          WHERE     ( (( A.ACCT_GL ) = '30') )
          GROUP BY  A.OCompID ,
                    A.ACCT_LOC ,
                    A.ACCT_PR ,
                    A.AMNT ,
                    A.ServiceYear ,
                    A.ServiceMonth
          HAVING    ( ( ( A.ACCT_PR ) <> '51' )
                      AND ( ( SUM(A.AMNT) ) <> 0 )
                    )
        ) AS Y
WHERE   Y.ServiceYear = '15'
GROUP BY LEFT(Y.ACCT_LOC, 1) ,
        Y.ACCT_PR ,
        Y.OCompID ,
        Y.ACCT_LOC ,
        Y.ServiceYear ,
        Y.ServiceMonth
ORDER BY LEFT(Y.ACCT_LOC, 1) ,
        Y.ACCT_PR;


SELECT ServiceYear, ServiceMonth, CASE WHEN ServiceYear BETWEEN 71 AND 99 THEN '19' ELSE '20' END + CAST(serviceYear AS VARCHAR)+ '-' +CAST(ServiceMonth AS VARCHAR ) +'-'+ '01'
--, CAST(CASE WHEN ServiceYear BETWEEN 71 AND 99 THEN '19' ELSE '20' END + CAST(serviceYear AS VARCHAR)+CAST(ServiceMonth AS VARCHAR ) + '01'  AS DATETIME)
, * FROM assets
WHERE (ServiceYear BETWEEN 71 AND 99) OR ServiceYear BETWEEN 1 AND 16



SELECT * FROM assets WHERE serviceMonth = '03' AND ServiceYear = '15'