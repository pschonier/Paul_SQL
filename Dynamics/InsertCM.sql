 
 BEGIN TRANSACTION 
 INSERT INTO cm20200 (CMRECNUM ,
        sRecNum ,
        RCRDSTTS ,
        CHEKBKID ,
        CMTrxNum ,
        CMTrxType ,
        TRXDATE ,
        GLPOSTDT ,
        TRXAMNT ,
        CURNCYID ,
        CMLinkID ,
        paidtorcvdfrom ,
        DSCRIPTN ,
        Recond ,
        RECONUM ,
        ClrdAmt ,
        clearedate ,
        VOIDED ,
        VOIDDATE ,
        VOIDPDATE ,
        VOIDDESC ,
        NOTEINDX ,
        AUDITTRAIL ,
        DEPTYPE ,
        SOURCDOC ,
        SRCDOCTYP ,
        SRCDOCNUM ,
        POSTEDDT ,
        PTDUSRID ,
        MODIFDT ,
        MDFUSRID ,
        USERDEF1 ,
        USERDEF2 ,
        ORIGAMT ,
        Checkbook_Amount ,
        RATETPID ,
        EXGTBLID ,
        XCHGRATE ,
        EXCHDATE ,
        TIME1 ,
        RTCLCMTD ,
        EXPNDATE ,
        CURRNIDX ,
        DECPLCUR ,
        DENXRATE ,
        MCTRXSTT ,
        Xfr_Record_Number ,
        EFTFLAG )
SELECT (SELECT MAX(cmrecnum) FROM cm20200) + ROW_NUMBER() OVER (PARTITION BY p.CHEKBKID ORDER BY p.DEX_ROW_ID desc), (SELECT MAX(cmrecnum) FROM cm20200) 
+ ROW_NUMBER() OVER (PARTITION BY p.CHEKBKID ORDER BY p.DEX_ROW_ID desc), 40, 'LIBERTY', DOCNUMBR, 3, DOCDATE, p.POSTEDDT, docamnt, '', p.VENDORID,
		(SELECT v.VENDNAME FROM pm00200 v WHERE v.VENDORID = p.VENDORID),'',0,0,0,'1900-01-01 00:00:00.000',0,'1900-01-01 00:00:00.000','1900-01-01 00:00:00.000', ''
		, p.NOTEINDX, p.TRXSORCE, 0, 'PMCHK', 6, p.VCHRNMBR, p.POSTEDDT, p.PTDUSRID, p.DOCDATE, p.PTDUSRID, '','',p.DOCAMNT, p.DOCAMNT
		, '','',0, '1900-01-01 00:00:00.000' ,'1900-01-01 00:00:00.000' ,0,'1900-01-01 00:00:00.000', 0, 0, 0, 0, 0, 0
FROM pm30200 p
LEFT OUTER JOIN cm20200 c ON c.CMTrxNum = p.DOCNUMBR AND c.SRCDOCNUM = p.VCHRNMBR AND c.SRCDOCTYP = p.DOCTYPE
WHERE p.BACHNUMB IN ('07/07/15JPMEFT') 
ROLLBACK TRANSACTION

SELECT * FROM pm30200 WHERE BACHNUMB IN ('07/07/15JPMEFT') 

SELECT * FROM cm20200 WHERE SRCDOCNUM LIKE '%198548'

