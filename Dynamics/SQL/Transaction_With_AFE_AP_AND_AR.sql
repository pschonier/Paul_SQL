
select distinct  
 isnull(cast(ME_Job_ID as nvarchar), '') as AFENum
, Actnumst as GLAccount
, isnull(cast(g.JRNENTRY as nvarchar), 'N/A') as JournalEntry
, ORPSTDDT as GLPOSTDT
, g.DebitAmt - g.CRDTAMNT  as TrnAmt
, g.REFRENCE
, isnull(d.VCHRNMBR, '') as VCHRNMBR
, g.ORDOCNUM as DOCNUMBR
, isnull(isnull(t.BACHNUMB, r2.BACHNUMB),'') as BACHNUMB
, isnull(isnull(t.TRXSORCE, r2.TRXSORCE),'') as TRXSORCE
, ORCTRNUM
, ORMSTRNM
, ORDOCNUM
, g.DSCRIPTN
, isnull(ME_Originating_Mstr_Name, '') as ME_Originating_Mstr_Name
from GL20000 g
 left outer join pm30600 d on d.VCHRNMBR = g.ORCTRNUM and d.DSTSQNUM = g.SEQNUMBR AND d.DOCTYPE = g.ORTRXTYP 
 left outer join RM30301 r1 on r1.DOCNUMBR = g.ORDOCNUM and r1.TRXSORCE = ORGNTSRC -- receivables Dist History
 left outer join PM30200 t on t.VCHRNMBR = d.VCHRNMBR AND t.DOCTYPE = d.DOCTYPE
 left outer join RM30101 r2 on r2.DOCNUMBR = g.ORDOCNUM and r2.TRXSORCE = ORGNTSRC and r1.RMDTYPAL = r2.RMDTYPAL -- receivables Trn History
 left outer join ME97705 a on d.VCHRNMBR = a.DOCNUMBR and d.DSTSQNUM = a.LNITMSEQ and d.doctype = a.DOCTYPE
inner join EPCO.dbo.gl00105 act on act.ACTINDX = g.ACTINDX



--select top 1000 * from GL20000 g where series = 3
--select top 1000* from RM30101
--select top 1000 * from Rm30301