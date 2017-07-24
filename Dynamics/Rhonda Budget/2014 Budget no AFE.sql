SELECT distinct act.ACTNUMST as GLAccount,
 g.OrigSeqNum, g.JRNENTRY, g.ORTRXTYP, g.ACTINDX
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
, cast (datepart(Month, TRXDATE) as nvarchar) + '/' + cast(DATEPART(year, trxdate) as nvarchar) as MMYYYY
FROM GL30000 g
inner join PM30600 d on d.VCHRNMBR = g.ORCTRNUM and d.DSTSQNUM = g.OrigSeqNum
inner join PM30200 t on t.VCHRNMBR = d.VCHRNMBR
inner join EPCO.dbo.gl00105 act on act.ACTINDX = g.ACTINDX
inner join EPCO.dbo.gl00100 gl on gl.actindx = act.actindx
join GL00102 b on b.ACCATNUM = gl.ACCATNUM
where TRXDATE between '2014-1-1' and '2015-1-1' and left(act.ACTNUMST,1) = '8'  
and  g.SERIES in (2,4)           