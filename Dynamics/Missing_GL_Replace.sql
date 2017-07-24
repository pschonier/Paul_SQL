--Test query to see data set
SELECT TOP 1000  pm00200.VNDCLSID, DSTINDX, pm10000.*, pm10100.* FROM pm10000 
JOIN pm10100 ON PM10100.VCHRNMBR = PM10000.VCHRNMBR 
JOIN pm00200 ON PM00200.VENDORID = PM10000.VENDORID
--JOIN gl00105 g ON g.ACTINDX = pm10100.DSTINDX
 WHERE DOCNUMBR LIKE '%osinv%' ORDER BY DOCDATE DESC

--**RULES**
--____________________________________________________________________________________________
--DSTYPE = 2 Pay, 6 Purchase
--1063 = 520001-0-000-0-9000 (non affiliate credit) dsttype = 2 AND v.VNDCLSID = 'STANDARD'
--7482 =  '520001-0-000-0-9200 (affiliate credit)   dsttype = 2 AND v.VNDCLSID = 'AFFILIATE'           
--2132 = '823443-9-381-0-0000'    (Everyone debit amount)   dsttype = 6 
--____________________________________________________________________________________________                                                                                      
BEGIN TRAN
UPDATE pm10100 SET DSTINDX = 1063
FROM pm10100 p
JOIN pm00200 v ON v.vendorID = p.vendorID
WHERE DSTINDX = 0 AND p.DISTTYPE = 2 AND v.VNDCLSID = 'STANDARD'
ROLLBACK TRAN

BEGIN TRAN
UPDATE pm10100 SET DSTINDX = 7482
FROM pm10100 p
JOIN pm00200 v ON v.vendorID = p.vendorID
WHERE DSTINDX = 0 AND p.DISTTYPE = 2 AND v.VNDCLSID = 'AFFILIATE'
ROLLBACK TRAN

BEGIN TRAN
UPDATE pm10100 SET DSTINDX = 2132
FROM pm10100 p
JOIN pm00200 v ON v.vendorID = p.vendorID
WHERE DSTINDX = 0 AND p.DISTTYPE = 6
ROLLBACK TRAN

--Test Query for above changes. No results indicates success
SELECT * FROM pm10100 p
JOIN pm00200 v ON v.vendorID = p.vendorID
WHERE DSTINDX = 0 AND p.DISTTYPE = 2 AND v.VNDCLSID = 'AFFILIATE'

