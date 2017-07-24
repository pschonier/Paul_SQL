update pm00400 set docdate = '2015-1-1' from pm00400 where cntrlnum = '00000000000245326'
update pm20000 set DOCDATE = '2015-1-1'  from pm20000 where VCHRNMBR = '00000000000245326'
update pm20000 set DUEDATE = '2015-1-1' from pm20000 where VCHRNMBR = '00000000000245326'
update pm20000 set Tax_Date = '2015-1-1'  from pm20000 where VCHRNMBR = '00000000000245326'


select * from pm20000 where VCHRNMBR = '00000000000245326'
