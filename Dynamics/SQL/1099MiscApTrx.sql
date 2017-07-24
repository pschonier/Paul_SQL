--1=Not 1099 Vendor, 2=Dividend,3=Interest,4=Misc

------------------------Original------------------------
declare @startdate as datetime
declare @enddate as datetime

select @startdate = '1/1/2014'
select @enddate = '1/1/2015'


select pm30300.vendorid, sum(apfrmaplyamt) AS 'Total Payments', sum(ten99amnt) AS 'Total 1099'
, sum(apfrmaplyamt) - sum(ten99amnt) AS UnAssigned , TXIDNMBR
from pm30300
inner join pm00200 on pm30300.vendorid = pm00200.vendorid
where ten99type != 1 -- 1099 indicator
and doctype = 6 -- Payment
and aptodcty = 1 -- Applied to Invoice
and datepart(year,docdate) = datepart(year,getdate()) -1 
GROUP BY pm30300.vendorid, TXIDNMBR
order by (sum(apfrmaplyamt) - sum(ten99amnt)) desc, VENDORID


-------------------Correction Research-------------------
select vendorID as vendorID, sum(Ten99Amnt) as RevisedTen99Total from PM00204 where Year1 = 2014 and vendorID in
( select pm30300.vendorid
from pm30300
inner join pm00200 on pm30300.vendorid = pm00200.vendorid
where ten99type != 1 -- 1099 indicator
and doctype = 6 -- Payment
and aptodcty = 1 -- Applied to Invoice
and datepart(year,docdate) = datepart(year,getdate()) -1 
group by pm30300.vendorID
having sum(apfrmaplyamt) - sum(ten99amnt) ! = 0
 ) 
group by pm00204.VENDORID order by sum(Ten99Amnt) desc


-------------------1099 MISC query in 1099Pro format---------------------------

select p2.TXIDNMBR as 'RCP TIN', p2.vendname as 'Last Name/Company', '' as 'First Name'
, case when upper(left(address1,4)) = 'DBA:' then rtrim(substring(Address1,5,50)) else '' end as 'Name Line 2'
, '' as 'Address Type'
, case when upper(left(address1,4)) = 'DBA:' then p2.ADDRESS2 else Address1 end as 'Address Deliv/Street'
, case when upper(left(address1,4)) = 'DBA:' then '' else p2.ADDRESS2 + ' ' + p2.ADDRESS3 end as 'Address Apt/Suite'
, p2.city as 'City',
p2.state as'State',
p2.zipcode as 'Zip',
p2.country as 'COUNTRY',
ACNMVNDR as 'Rcp Account',
'' as 'Rcp Email',
'' as '2nd TIN Notice',
sum(case when p1.TEN99BOXNUMBER = 1 then p1.TEN99AMNT else 0 end) as  'Box 1 Amount',
sum(case when p1.TEN99BOXNUMBER = 2 then p1.TEN99AMNT else 0 end) as  'Box 2 Amount',
sum(case when p1.TEN99BOXNUMBER = 3 then p1.TEN99AMNT else 0 end) as  'Box 3 Amount',
sum(case when p1.TEN99BOXNUMBER = 4 then p1.TEN99AMNT else 0 end) as  'Box 4 Amount',
sum(case when p1.TEN99BOXNUMBER = 5 then p1.TEN99AMNT else 0 end) as  'Box 5 Amount',
sum(case when p1.TEN99BOXNUMBER = 6 then p1.TEN99AMNT else 0 end) as  'Box 6 Amount',
sum(case when p1.TEN99BOXNUMBER = 7 then p1.TEN99AMNT else 0 end) as  'Box 7 Amount',
sum(case when p1.TEN99BOXNUMBER = 8 then p1.TEN99AMNT else 0 end) as  'Box 8 Amount',
sum(case when p1.TEN99BOXNUMBER = 9 then p1.TEN99AMNT else 0 end) as  'Box 9 Checkbox',
sum(case when p1.TEN99BOXNUMBER = 10 then p1.TEN99AMNT else 0 end) as  'Box 10 Amount',
sum(case when p1.TEN99BOXNUMBER = 11 then p1.TEN99AMNT else 0 end) as  'Box 13 Amount',
sum(case when p1.TEN99BOXNUMBER = 12 then p1.TEN99AMNT else 0 end) as  'Box 14 Amount',
sum(case when p1.TEN99BOXNUMBER = 13 then p1.TEN99AMNT else 0 end) as  'Box 15a Amount',
sum(case when p1.TEN99BOXNUMBER = 14 then p1.TEN99AMNT else 0 end) as  'Box 15b Amount',
sum(case when p1.TEN99BOXNUMBER = 15 then p1.TEN99AMNT else 0 end) as  'Box 16 Amount',
sum(case when p1.TEN99BOXNUMBER = 16 then p1.TEN99AMNT else 0 end) as  'Box 17 ID Number',
sum(case when p1.TEN99BOXNUMBER = 17 then p1.TEN99AMNT else 0 end) as  'Box 17 State',
sum(case when p1.TEN99BOXNUMBER = 18 then p1.TEN99AMNT else 0 end) as  'Box 18 Amount',
'' as 'Opt Rcp Text Line 1',
'' as 'Opt Rcp Text Line 2',
'' as 'Form Category',
'' as 'Form Source',
'' as 'Tax State'
from PM00204 p1
join pm00200 p2 on p1.vendorid = p2.vendorid 
where p1.YEAR1 = datepart(year,getdate()) -1 
and p2.TEN99TYPE = 4 -- 1099 indicator
group by p2.TXIDNMBR , p2.vendname, p2.address1, p2.address2, p2.address3, p2.city, p2.state,p2.ZIPCODE, p2.country, acnmvndr
order by vendname asc

select distinct ten99boxnumber from pm00204 

--select * from PM00204
--select * from pm00200


select vendorid, p.TEN99BOXNUMBER, sum(p.TEN99AMNT), ten99type from pm00204 p
where vendorid = 'Bobcat'
group by vendorID, p.TEN99BOXNUMBER, ten99type
