begin transaction
delete from pm10200 where APTVCHNM like '%272777%'
delete from pm80500 where APTVCHNM like '%272777%'
delete from pm80600 where VCHRNMBR like '%272777%'
delete from PM20100 where APTVCHNM like '%272777%'
delete from GL50508 where ORCTRNUM like '%272777%'
delete from ME97705 where DOCNUMBR like '%272777%'
delete from PM10100 where VCHRNMBR like '%272777%'
delete from PM00400 where CNTRLNUM like '%272777%'
delete from GL20000 where ORCTRNUM like '%272777%'
delete from PM10201 where VCHRNMBR like '%272777%'
delete from ME97749 where DTAControlNum like '%272777%'
delete from pm20000 where vchrnmbr = '00000000000272777'
rollback transaction