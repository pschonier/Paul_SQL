select p2.TXIDNMBR as 'RCP TIN', p2.vendname as 'Last Name/Company', '' as 'First Name'
, '' as 'Name Line 2'
, '' as 'Address Type' -- Delete for MISC. Leave for DIV
, p2.ADDRESS1 as 'Address Deliv/Street'
, p2.ADDRESS2 + ' ' + p2.ADDRESS3 as 'Address Apt/Suite'
, p2.city as 'City',
p2.state as'State',
p2.zipcode as 'Zip',
p2.country as 'COUNTRY',
ACNMVNDR as 'Rcp Account',
'' as 'Rcp Email',
'' as '2nd TIN Notice',
sum(case when p1.TEN99BOXNUMBER = 1 then p1.TEN99AMNT else 0 end) as  'Box 1a Amount',
'' as 'Box 1b Amount',
sum(case when p1.TEN99BOXNUMBER = 2 then p1.TEN99AMNT else 0 end) as  'Box 2a Amount',
'' as 'Box 2b Amount',
'' as 'Box 2c Amount',
'' as 'Box 2d Amount',
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
'' as 'Form Category',
'' as 'Form Source',
'' as 'Tax State'
from PM00204 p1
join pm00200 p2 on p1.vendorid = p2.vendorid 
where p1.YEAR1 = datepart(year,getdate()) -1 
and p2.TEN99TYPE = 2 -- 1099 indicator
group by p2.TXIDNMBR , p2.vendname, p2.address1, p2.address2, p2.address3, p2.city, p2.state,p2.ZIPCODE, p2.country, acnmvndr
order by vendname asc
