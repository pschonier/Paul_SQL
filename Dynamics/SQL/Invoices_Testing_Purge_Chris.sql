begin transaction
delete from rm00401
where DOCDATE = '2014-11-5' and DOCNUMBR like 'sales000000%'
rollback transaction

select * from rm00401 where DOCDATE = '2014-11-5' and DOCNUMBR like 'sales000000%'

begin transaction
delete from RM10101
where TRXSORCE = ''
rollback transaction

select * from RM10101
where TRXSORCE = ''