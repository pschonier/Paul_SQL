begin transaction
update gl00100
set ACCATNUM = g3.ACCATNUM
from  gl00100 g1 
join gl00105 g2 on g2.ACTINDX = g1.ACTINDX
join dbo.CategoryTemp ct on ct.AcctNum = g2.ACTNUMST
join gl00102 g3 on '%' + g3.ACCATDSC + '%' like  '%' + ct.toDescr + '%'
rollback transaction

select accatnum from gl00100

select ct.fromdescr, ct.todescr, g2.ACTNUMST, g1.ACCATNUM, g3.ACCATNUM, g3.ACCATDSC, * from gl00100 g1
join gl00105 g2 on g2.ACTINDX = g1.ACTINDX

join dbo.CategoryTemp ct on ct.AcctNum = g2.ACTNUMST
join gl00102 g3 on '%' + g3.ACCATDSC + '%' like  '%' + ct.toDescr + '%'

where accatdsc is null
order by ct.ToDescr

--select * into dbo.gl00100_BKUP from dbo.gl00100
--where g2.ACTNUMST = '015100-9-000-0-0000'
--select * from gl00100
--select * from gl00102 order by ACCATDSC
--update dbo.CategoryTemp 
--set todescr = 'Amortized Debt Expense'
--where todescr = 'Debt expense amortized'       


select * 
from  gl00100 g1 
join gl00105 g2 on g2.ACTINDX = g1.ACTINDX
join dbo.CategoryTemp ct on ct.AcctNum = g2.ACTNUMST
join gl00102 g3 on '%' + g3.ACCATDSC + '%' like  '%' + ct.FromDescr + '%'

select * from gl00102