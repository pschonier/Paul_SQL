

select top 1000 * from (
select DOCNUMBR as 'Trx Number', ME_Job_ID as AFE, m1.GLPOSTDT as 'Posted Date', gl.ACTNUMST, gl2.ACTDESCR, m1.TRXAMNT as TransactionAmount
, ME_User_Defined as 'Year', MEuserdefined2 as 'Class' , m1.MEuserdefined3 as DEPT, m2.DSCRIPTN as "Project Description", 'Hist' as 'Status' 
from me97704 m1 
join EPCO.dbo.gl00105 gl on gl.ACTINDX = m1.ACTINDX
join EPCO.dbo.gl00100 gl2 on gl2.ACTINDX = m1.ACTINDX
join epco.dbo.ME97702 m2 on m2.MEuserdefined3 = m1.MEuserdefined3

Union 
select DOCNUMBR as 'Trx Number', ME_Job_ID as AFE, m1.GLPOSTDT as 'Posted Date', gl.ACTNUMST, gl2.ACTDESCR, m1.TRXAMNT as TransactionAmount
, ME_User_Defined as 'Year', MEuserdefined2 as 'Class' , m1.MEuserdefined3 as DEPT, m2.DSCRIPTN as "Project Description", 'Open' as 'Status' 
from me97705 m1 
join EPCO.dbo.gl00105 gl on gl.ACTINDX = m1.ACTINDX
join EPCO.dbo.gl00100 gl2 on gl2.ACTINDX = m1.ACTINDX
join epco.dbo.ME97702 m2 on m2.MEuserdefined3 = m1.MEuserdefined3

Union
select DOCNUMBR as 'Trx Number', ME_Job_ID as AFE, m1.GLPOSTDT as 'Posted Date', gl.ACTNUMST, gl2.ACTDESCR, m1.TRXAMNT as TransactionAmount
, ME_User_Defined as 'Year', MEuserdefined2 as 'Class' , m1.MEuserdefined3 as DEPT, m2.DSCRIPTN as "Project Description", 'Work' as 'Status' 
from me97706 m1 
join EPCO.dbo.gl00105 gl on gl.ACTINDX = m1.ACTINDX
join EPCO.dbo.gl00100 gl2 on gl2.ACTINDX = m1.ACTINDX
join epco.dbo.ME97702 m2 on m2.MEuserdefined3 = m1.MEuserdefined3 ) as a

where a.AFE between @BeginProj and @endProj
and a.[Posted Date] between @Startdate and @EndDate
and a.status in (@Status)
Order by AFE
