select top 2000 * from ME97705 where ME_Amount_Type = 9 order by DOCDATE desc

select * from pm30200  where docamnt = 6600.42 

update pm30600 set VENDORID = 'BOKINTEREST' where DEBITAMT - CRDTAMNT  = 6600.42 



update gl20000 set ORMSTRID = 'BOKINTEREST' where jrnentry in (452539,
452587)


update pm00400 set VENDORID = 'BOKINTEREST'
where CNTRLNUM in ('00000000000245033','00000000000192464') and DOCNUMBR in ('DEBTFEES12/19/14', '1349')
