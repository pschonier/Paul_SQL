declare @startdate datetime
declare @enddate datetime
set @startdate = '2014-1-1'
set @enddate = '2014-11-8'
 
select 
g3.ACTNUMST AccountNumber
, g2.ACTNUMBR_3 as CostCenter
, g2.ACTDESCR AcctDescr
, g4.ACCATDSC as AcctCategory
, case isnumeric(case a.ME_Job_ID when NULL then a1.ME_Job_ID else a.ME_Job_ID end) when 0 then '_' else (case a.ME_Job_ID when NULL then a1.ME_Job_ID else a.ME_Job_ID end)  end as AFENumber
, g.DebitAmt - g.CRDTAMNT as Amount
, case g.series when 2 then 'Financial' when 4 then 'Purchasing' end as Series
, g.ORPSTDDT as PostDate
, g.TRXDATE as TransDate
from GL20000 g -- Current year posted transactions
join gl00100 g2 on g2.ACTINDX = g.ACTINDX -- Account Master
join EPCO.dbo.gl00105 g3 on g3.ACTINDX = g2.ACTINDX -- Table with account number concatenated
join gl00102 g4 on g4.ACCATNUM = g2.ACCATNUM -- Category Table
LEFT OUTER JOIN ME97705 a on g.JRNENTRY = a.JRNENTRY and CASE g.OrigSeqNum WHEN 0 THEN g.SEQNUMBR ELSE g.OrigSeqNum END = a.SQNCLINE -- AFE Table
LEFT OUTER JOIN ME97704 a1 on g.JRNENTRY = a1.JRNENTRY and CASE g.OrigSeqNum when 0 then g.SEQNUMBR else g.OrigSeqNum end = a1.SQNCLINE -- AFE table.
where series in (2) -- Financial 
and g2.ACTNUMBR_3 not in (381,389) -- Accounts to be excluded. There are probalby more than these 2.
and g.TRXDATE between @startdate and @enddate

Union all

select 
g3.ACTNUMST AccountNumber
, g2.ACTNUMBR_3 as CostCenter
, g2.ACTDESCR AcctDescr
, g4.ACCATDSC as AcctCategory
, case isnumeric(case a.ME_Job_ID when NULL then a1.ME_Job_ID else a.ME_Job_ID end) when 0 then '_' else (case a.ME_Job_ID when NULL then a1.ME_Job_ID else a.ME_Job_ID end)  end as AFENumber
, g.DebitAmt - g.CRDTAMNT as Amount
, case g.series when 2 then 'Financial' when 4 then 'Purchasing' end as Series
, g.ORPSTDDT as PostDate
, g.TRXDATE as TransDate
from GL20000 g -- Current year posted transactions
join gl00100 g2 on g2.ACTINDX = g.ACTINDX -- Account Master
join EPCO.dbo.gl00105 g3 on g3.ACTINDX = g2.ACTINDX -- Table with account number concatenated
join gl00102 g4 on g4.ACCATNUM = g2.ACCATNUM -- Category Table
inner join pm30600 d on d.VCHRNMBR = g.ORCTRNUM and d.DSTSQNUM = g.OrigSeqNum AND d.DOCTYPE = g.ORTRXTYP 
inner join PM30200 t on t.VCHRNMBR = d.VCHRNMBR AND t.DOCTYPE = d.DOCTYPE 
LEFT OUTER JOIN ME97705 a ON d.VCHRNMBR = a.DOCNUMBR and d.DOCTYPE = a.DOCTYPE and d.DSTSQNUM = a.ME_GL_Distribution_LI_In --AFE Table
LEFT OUTER JOIN ME97704 a1 ON d.VCHRNMBR = a1.DOCNUMBR and d.DOCTYPE = a1.DOCTYPE and d.DSTSQNUM = a1.ME_GL_Distribution_LI_In --AFE Table
where series in (4) --  Purchasing
and g2.ACTNUMBR_3 not in (381,389) -- Accounts to be excluded. There are probalby more than these 2.
and g.TRXDATE between @startdate and @enddate
