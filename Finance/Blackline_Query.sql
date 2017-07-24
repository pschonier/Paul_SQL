--SELECT * FROM pm30200 WHERE VENDORID = 'nextdyn'


--UPDATE sy00500 SET BCHSTTUS = 0 WHERE BACHNUMB = 'EC-854'


--update sy00500 SET BCHSTTUS = 0 WHERE BCHSTTUS != 0

SELECT a.ACTINDX ,
       a.ACTNUMBR_1 ,
       a.ACTNUMBR_2 ,
       a.ACTNUMBR_3 ,
       a.ACTNUMBR_4 ,
       a.ACTNUMBR_5 ,
       a.ACTNUMBR_6 ,
       a.ACTNUMBR_7 ,
       a.Key7 ,
       a.Key8 ,
       a.Key9 ,
       a.ACTDESCR ,
       a.ACCATDSC ,
       SUM(a.Total) AS CurrentBal FROM (
SELECT  g1.ACTINDX ,
        g1.ACTNUMBR_1 ,
        g1.ACTNUMBR_2 ,
        g1.ACTNUMBR_3 ,
        g1.ACTNUMBR_4 ,
        g1.ACTNUMBR_5 ,
        g1.ACTNUMBR_6 ,
        g1.ACTNUMBR_7 ,
        '' AS Key7 ,
        '' AS Key8 ,
        '' AS Key9 ,
        g1.ACTDESCR ,
		g2.ACCATDSC,
		g3.DEBITAMT - g3.CRDTAMNT AS Total
FROM    GL00100 g1
        JOIN GL00102 g2 ON g2.ACCATNUM = g1.ACCATNUM
        JOIN GL20000 g3 ON g3.ACTINDX = g1.ACTINDX) a 
GROUP BY a.ACTINDX ,
         a.ACTNUMBR_1 ,
         a.ACTNUMBR_2 ,
         a.ACTNUMBR_3 ,
         a.ACTNUMBR_4 ,
         a.ACTNUMBR_5 ,
         a.ACTNUMBR_6 ,
         a.ACTNUMBR_7 ,
         a.Key7 ,
         a.Key8 ,
         a.Key9 ,
         a.ACTDESCR ,
         a.ACCATDSC 
--WHERE   ACTIVE = 1;

--SELECT EOMONTH(GETDATE())
SELECT * FROM sy40100
SELECT  CLOSED ,
        ODESCTN ,
        YEAR1 ,
        PERIODID ,
        PERNAME, *
FROM    SY40100
WHERE   YEAR1 = 2017
        --AND SERIES = 0
ORDER BY PERIODDT

n