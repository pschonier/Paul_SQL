
select *
from GL20000 g
 left outer join pm30600 d on d.VCHRNMBR = g.ORCTRNUM and d.DSTSQNUM = g.SEQNUMBR AND d.DOCTYPE = g.ORTRXTYP 
 left outer join RM30301 r1 on r1.DOCNUMBR = g.ORDOCNUM and r1.TRXSORCE = ORGNTSRC -- receivables Dist History
 left outer join PM30200 t on t.VCHRNMBR = d.VCHRNMBR AND t.DOCTYPE = d.DOCTYPE
 left outer join RM30101 r2 on r2.DOCNUMBR = g.ORDOCNUM and r2.TRXSORCE = ORGNTSRC and r1.RMDTYPAL = r2.RMDTYPAL -- receivables Trn History
 left outer join ME97705 a on a.DOCNUMBR  = d.VCHRNMBR and d.DSTSQNUM = a.LNITMSEQ and d.doctype = a.DOCTYPE
inner join EPCO.dbo.gl00105 act on act.ACTINDX = g.ACTINDX
where a.ME_Job_ID = '7221'
Order by g.DebitAmt - g.CRDTAMNT

select top 100 * from ME97705 a
where ME_Job_ID = '7221' 
order by TRXAMNT

--select top 100 * from GL20000


--select * from pm30600 d 
-- left outer join ME97705 a on a.DOCNUMBR = d.VCHRNMBR  and d.DSTSQNUM = a.LNITMSEQ and d.doctype = a.DOCTYPE
-- where ME_Job_ID = '7221' 
--order by TRXAMNT


