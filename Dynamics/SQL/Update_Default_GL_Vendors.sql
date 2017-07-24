select p1.PMprchix, VendorID, g1.actnumst as InactiveAcct, 'PM Purchases' as AcctType from pm00200 p1
join GL00105 g1 on g1.ACTINDX = p1.PMPRCHIX
join gl00100 g2 on g2.actindx = p1.PMPRCHIX
where g2.active = 0
--and p1.VENDSTTS = 1
Order by VENDORID


begin transaction
update pm00200 set PMPRCHIX = 0 where PMPRCHIX in (

select p1.PMPRCHIX from pm00200 p1
join GL00105 g1 on g1.ACTINDX = p1.PMPRCHIX
join gl00100 g2 on g2.actindx = p1.PMPRCHIX
where g2.active = 0 )

rollback transaction

--Find accounts tied to specific account prefixes

select * from pm00200 where pmprchix in (select actindx from gl00100 where left(actnumbr_1, 3) = 824)

