
select * into tempdb.dbo.PTemp from pm10000 where bachnumb = 'RWR 1/7/15A' -- create temp table
update pm10000 set vendorID = 'TXHARRISCO'
where BACHNUMB = 'RWR 1/7/15A'
update pm10100 set VENDORID = 'TXHARRISCO'
where VCHRNMBR in (select VCHRNMBR from tempdb.dbo.PTemp)
update pm00400 set VENDORID = 'TXHARRISCO'
where CNTRLNUM in (select VCHRNMBR from tempdb.dbo.PTemp)


