SELECT g.HSTYEAR, CASE LEFT(g1.ACTNUMBR_1,2) WHEN '82' THEN 'Expense' ELSE 'Capital' END AS type, g2.ACTNUMST, g.DEBITAMT FROM dbo.GL30000 g
JOIN gl00100 g1 ON g1.ACTINDX = g.ACTINDX
JOIN gl00105 g2 ON g2.ACTINDX = g.ACTINDX
WHERE g.ORTRXTYP = 1 AND LEFT(g1.ACTNUMBR_1,2) IN ('82', '01') AND g.HSTYEAR >2012 AND g2.ACTNUMBR_3 = '216'
ORDER BY g.TRXDATE DESC --Expense 825, 823 == expense 305 306

SELECT 
        ISNULL([system], 'Office') AS 'System' ,
        a.Year ,
        a.ORPSTDDT ,
        a.ACTNUMST ,
        a.Amount ,
        a.PERIODID
FROM    ( SELECT    g.OPENYEAR AS [Year] ,
                    g.ORPSTDDT ,
                    [system] ,
                    g2.ACTNUMST ,
                    g.DEBITAMT - g.CRDTAMNT AS Amount ,
                    g.PERIODID
          FROM      GL20000 g
                    JOIN GL00100 g1 ON g1.ACTINDX = g.ACTINDX
                    JOIN dbo.locsys l ON l.div = g1.ACTNUMBR_2
                                         AND l.LoCode = g1.ACTNUMBR_3
                    JOIN GL00105 g2 ON g2.ACTINDX = g.ACTINDX
          WHERE     g.ORTRXTYP IN ( 5, 6 )
          UNION
          SELECT    g.HSTYEAR AS [Year] ,
                    g.ORPSTDDT ,
                    [system] ,
                    g2.ACTNUMST ,
                    g.DEBITAMT - g.CRDTAMNT AS Amount ,
                    g.PERIODID
          FROM      GL30000 g
                    JOIN GL00100 g1 ON g1.ACTINDX = g.ACTINDX
                    JOIN dbo.locsys l ON l.div = g1.ACTNUMBR_2
                                         AND l.LoCode = g1.ACTNUMBR_3
                    JOIN GL00105 g2 ON g2.ACTINDX = g.ACTINDX
          WHERE     g.ORTRXTYP IN ( 5, 6 )
        ) a
WHERE a.Year >= 2012

SELECT * FROM locsys