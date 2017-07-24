SELECT distinct AFENum, act.ACTNUMST as GLAccount, cmb.JournalEntry, cmb.GLPOSTDT, cmb.TrnAmt, cmb.REFRENCE, cmb.VCHRNMBR, cmb.DOCNUMBR, cmb.BACHNUMB
        , cmb.TRXSORCE, cmb.ORCTRNUM, cmb.ORMSTRNM, cmb.ORDOCNUM, cmb.DSCRIPTN, ME_Originating_Mstr_Name
FROM
(
SELECT CASE ISNUMERIC(a.ME_JOB_ID) WHEN 0 THEN '_' ELSE cast(a.ME_Job_ID as nvarchar) END as AFENum
, g.OrigSeqNum, g.JRNENTRY, g.ORTRXTYP, g.ACTINDX
, isnull(cast(g.JRNENTRY as nvarchar), 'N/A') as JournalEntry
, g.TRXDATE as GLPOSTDT
, g.DebitAmt - g.CRDTAMNT  as TrnAmt
, g.REFRENCE
, '' as VCHRNMBR
, g.ORDOCNUM as DOCNUMBR
, '' as BACHNUMB
, '' as TRXSORCE
, g.ORCTRNUM
, g.ORMSTRNM
, g.ORDOCNUM
, g.DSCRIPTN
, isnull(a.ME_Originating_Mstr_Name, '') as ME_Originating_Mstr_Name
FROM GL20000 g
LEFT OUTER JOIN ME97705 a on g.JRNENTRY = a.JRNENTRY and CASE g.OrigSeqNum WHEN 0 THEN g.SEQNUMBR ELSE g.OrigSeqNum END = a.SQNCLINE
LEFT OUTER JOIN ME97704 a1 on g.JRNENTRY = a1.JRNENTRY and CASE g.OrigSeqNum when 0 then g.SEQNUMBR else g.OrigSeqNum end = a1.SQNCLINE
WHERE g.SERIES = 2
UNION ALL
SELECT 
CASE ISNUMERIC(ISNULL(a.ME_JOB_ID, ISNULL(ah.ME_JOB_ID, '_'))) WHEN 1 THEN ISNULL(a.ME_JOB_ID, ISNULL(ah.ME_JOB_ID, '_')) ELSE '_' END as AFENum
,g.OrigSeqNum, g.JRNENTRY, g.ORTRXTYP, g.ACTINDX
, isnull(cast(g.JRNENTRY as nvarchar), 'N/A') as JournalEntry
, g.TRXDATE as GLPOSTDT
, g.DebitAmt - g.CRDTAMNT  as TrnAmt
, g.REFRENCE
, isnull(d.VCHRNMBR, '') as VCHRNMBR
, g.ORDOCNUM as DOCNUMBR
, isnull(t.BACHNUMB,'') as BACHNUMB
, isnull(t.TRXSORCE,'') as TRXSORCE
, g.ORCTRNUM
, g.ORMSTRNM
, g.ORDOCNUM
, g.DSCRIPTN
, isnull(a.ME_Originating_Mstr_Name, isnull(ah.ME_Originating_Mstr_Name, '')) as ME_Originating_Mstr_Name
FROM GL20000 g
inner join pm30600 d on d.VCHRNMBR = g.ORCTRNUM and d.DSTSQNUM = g.OrigSeqNum AND d.DOCTYPE = g.ORTRXTYP 
inner join PM30200 t on t.VCHRNMBR = d.VCHRNMBR AND t.DOCTYPE = d.DOCTYPE 
LEFT OUTER JOIN ME97705 a ON d.VCHRNMBR = a.DOCNUMBR and d.DOCTYPE = a.DOCTYPE and d.DSTSQNUM = a.ME_GL_Distribution_LI_In 
LEFT OUTER JOIN ME97704 ah ON d.VCHRNMBR = ah.DOCNUMBR and d.DOCTYPE = ah.DOCTYPE and d.DSTSQNUM = ah.ME_GL_Distribution_LI_In 
where series = 4
UNION ALL
SELECT CASE ISNUMERIC(ISNULL(a.ME_JOB_ID, ISNULL(ah.ME_JOB_ID, '_'))) WHEN 1 THEN ISNULL(a.ME_JOB_ID, ISNULL(ah.ME_JOB_ID, '_')) ELSE '_' END as AFENum
, g.OrigSeqNum, g.JRNENTRY, g.ORTRXTYP, g.ACTINDX
, isnull(cast(g.JRNENTRY as nvarchar), 'N/A') as JournalEntry
, g.TRXDATE as GLPOSTDT
, g.DebitAmt - g.CRDTAMNT  as TrnAmt
, g.REFRENCE
, isnull(d.VCHRNMBR, '') as VCHRNMBR
, g.ORDOCNUM as DOCNUMBR
, isnull(t.BACHNUMB,'') as BACHNUMB
, isnull(t.TRXSORCE,'') as TRXSORCE
, g.ORCTRNUM
, g.ORMSTRNM
, g.ORDOCNUM
, g.DSCRIPTN
, isnull(a.ME_Originating_Mstr_Name, '') as ME_Originating_Mstr_Name
FROM GL20000 g
inner join pm10100 d on d.VCHRNMBR = g.ORCTRNUM and d.DSTSQNUM = g.OrigSeqNum
inner join PM20000 t on t.VCHRNMBR = d.VCHRNMBR
LEFT OUTER JOIN ME97705 a ON d.VCHRNMBR = a.DOCNUMBR and (d.DSTSQNUM = a.ME_GL_Distribution_LI_In or d.DSTSQNUM = a.LNITMSEQ)
LEFT OUTER JOIN ME97704 ah ON d.VCHRNMBR = ah.DOCNUMBR and (d.DSTSQNUM = ah.ME_GL_Distribution_LI_In or d.DSTSQNUM = a.LNITMSEQ)
WHERE g.SERIES = 4
UNION ALL
SELECT '_' AFENum
, g.OrigSeqNum, g.JRNENTRY, g.ORTRXTYP, g.ACTINDX
, isnull(cast(g.JRNENTRY as nvarchar), 'N/A') as JournalEntry
, g.TRXDATE as GLPOSTDT
, g.DebitAmt - g.CRDTAMNT  as TrnAmt
, g.REFRENCE
, '' as VCHRNMBR
, g.ORDOCNUM as DOCNUMBR
, isnull(r2.BACHNUMB,'') as BACHNUMB
, isnull(r2.TRXSORCE,'') as TRXSORCE
, g.ORCTRNUM
, g.ORMSTRNM
, g.ORDOCNUM
, g.DSCRIPTN
, '_' as ME_Originating_Mstr_Name
FROM GL20000 g
left outer join RM30301 r1 on r1.DOCNUMBR = g.ORDOCNUM and r1.TRXSORCE = ORGNTSRC -- receivables Dist History
left outer join RM30101 r2 on r2.DOCNUMBR = g.ORDOCNUM and r2.TRXSORCE = ORGNTSRC and r1.RMDTYPAL = r2.RMDTYPAL -- receivables Trn History
WHERE g.SERIES = 3
) AS cmb
inner join EPCO.dbo.gl00105 act on act.ACTINDX = cmb.ACTINDX


