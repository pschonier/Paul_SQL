select isnull(cast(a.ME_Job_ID as nvarchar), 'N/A') as AFENum
, a.actindx
, Actnumst as GLAccount
, isnull(cast(a.JRNENTRY as nvarchar), 'N/A') as JournalEntry
, GLPOSTDT
, g.CRDTAMNT - g.DebitAmt as TrnAmt
, trxamnt
, g.REFRENCE
, d.VCHRNMBR
, t.DOCNUMBR
, BACHNUMB
, t.TRXSORCE
, ORCTRNUM
, ORMSTRNM
, ORCTRNUM
, a.DSCRIPTN
, ME_Originating_Mstr_Name
from pm30200 t
inner join pm30600 d on t.VCHRNMBR = d.VCHRNMBR
inner join GL20000 g on d.VCHRNMBR = g.ORCTRNUM and d.DSTSQNUM = g.SEQNUMBR  
left outer join (SELECT * FROM ME97705
				 --where ISNUMERIC(ME_JOB_ID) = 1
				 ) as a on d.VCHRNMBR = a.DOCNUMBR and d.DSTSQNUM = a.LNITMSEQ
inner join EPCO.dbo.gl00105 act on act.ACTINDX = a.ACTINDX
order by a.GLPOSTDT desc


