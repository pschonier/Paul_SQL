--Captains log, star date... (RRD 9/20140
--Sam game me a spreadsheet of slots. Some were for import, some to update type and description. I imported the all, so some were duplicated with different types.
--Compounding the original mistake, I imported equipment inner joined to the slots, so that was duplicated too. Here's how I got rid of them.

--Are there duplicate slots? How many pieces of equipment are in each, because equipment might have been duplicated too.
select fu1.fu_unitid, wa.wa_code, count(fm.fm_pk) as 'Count Of Equipment' from f_area fu1 inner join f_area fu2 on fu1.fu_unitID = fu2.fu_unitID 
inner join f_areatype wa on fu1.fu_wa_fk = wa.wa_pk
left outer join f_equipment fm on fu1.fu_pk = fm.fm_fu_fk
where fu1.fu_wa_fk <> fu2.fu_wa_fk
group by fu1.fu_unitid, wa.wa_code
order by fu1.fu_unitid, wa.wa_code

--Duplicate equipment?
select fu.fu_description, fm1.* from f_equipment fm1 inner join f_equipment fm2 on fm1.fm_tagNumber = fm2.fm_tagNumber 
inner join f_area fu on fm1.fm_fu_fk = fu.fu_pk
where fm1.fm_pk <> fm2.fm_pk

--Are the duplicate pieces of equipment because of duplications slots?
select giii.gii_item_fk_name, count(fm_fu_fk) 'CountOf'
from IT.dbo.TmagenInspectionItemimport giii
left outer join f_equipment fm on giii.GII_item_fk_name = fm.fm_tagNumber
inner join f_area fu on fm.fm_fu_fk = fu.fu_pk
where imported = 0 and giii.GII_ItemType_fk = 0 and giii.gii_item_fk_name not in ('006319', '009725')
GROUP by giii.gii_item_fk_name HAVING count(fm_fu_fk) > 1
order by GII_item_fk_name

--1011 is Pipeline Block Valve (DOT), 1012 is PM. PM has 2 items. PBV has 1. Delete 1011(DOT,PBV). Change PM to PBV.
select fmDOT.fm_pk 'fm_pk_DOT', fmPM.fm_pk 'fm_pk_PM', giiDOT.gii_pk 'gii_pk_DOT', giiPM.gii_pk 'gii_pk_PM'
	, fuDOT.fu_pk 'fu_pk_DOT', fuPM.fu_pk 'fu_pk_PM', fmDOT.fm_tagNumber 'fm_tagNumber', fuDOT.fu_description 'fu_description_DOT'
into #InspectionItemsToDelete
from f_genInspectionItem giiDOT 
inner join f_equipment fmDOT on giiDOT.GII_item_fk = fmDOT.fm_pk
inner join f_area fuDOT on fmDOT.fm_fu_fk = fuDOT.fu_pk
inner join f_equipment fmPM on fmDOT.fm_tagNumber = fmPM.fm_tagNumber
inner join f_area fuPM on fmPM.fm_fu_fk = fuPM.fu_pk
inner join f_genInspectionItem giiPM on fmPM.fm_pk = giiPM.gii_item_fk
where giiDOT.GII_ItemType_fk = 0 and fuDOT.fu_wa_fk = 1011 and fuPM.fu_wa_fk = 1012

--Recreate the data of the duplicate items if necessary, since originals are now deleted.
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505475,1505476,4490,4491,456743,441849,009965,'Manifold Valve - Conoco Delive')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505477,1505478,4492,4493,456744,441850,009966,'Magellan 20" Oil Suction Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505479,1505480,4494,4495,456745,441851,009967,'Magellan Gasoline Suction Valv')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505481,1505482,4496,4497,456746,441852,009968,'Conoco Suction Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505487,1505488,4500,4501,456747,441876,009973,'Receiver Inlet Valve - 28" Mai')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505489,1505490,4502,4503,456748,441877,009974,'Receiver Bypass Valve - 28" Ma')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505491,1505492,4504,4505,456749,441878,009975,'Receiver Outlet Valve - 28" Ma')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505493,1505494,4506,4507,456750,441879,009976,'Launcher Outlet Valve - 28" We')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505495,1505496,4508,4509,456751,441880,009977,'Launcher Bypass Valve - 28" We')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505497,1505498,4510,4511,456752,441881,009978,'Launcher Inlet Valve - 28" Wes')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505499,1505500,4512,4513,456753,441882,009979,'Launcher Outlet Valve - 24" Ma')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505501,1505502,4514,4515,456754,441883,009980,'Launcher Bypass Valve - 24" Ma')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505503,1505504,4516,4517,456755,441884,009981,'Launcher Inlet Valve - 24" Mai')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505505,1505506,4518,4519,456756,441977,009982,'Block Valve to 20" Magellan Co')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505721,1505722,4685,4686,456834,452319,010138,'14" Launcher Block Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505723,1505724,4687,4688,456835,452320,010139,'14" Launcher Bypass Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505725,1505726,4689,4690,456836,452321,010140,'14" Launcher Inlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505715,1505716,4679,4680,456831,452363,010135,'24" Launcher Block Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505719,1505720,4683,4684,456833,452364,010137,'24" Launcher Bypass Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505717,1505718,4681,4682,456832,452365,010136,'24" Launcher Inlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505709,1505710,4673,4674,456828,452389,010132,'24" Receiver Block Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505711,1505712,4675,4676,456829,452390,010133,'24" Receiver Bypass Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505713,1505714,4677,4678,456830,452391,010134,'24" Receiver Outlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505587,1505588,4583,4584,456757,452518,010040,'Block Valve (Delivery)')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505591,1505592,4587,4588,456759,452808,010042,'Delivery Valve (Gas)')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505589,1505590,4585,4586,456758,452809,010041,'Delivery Valve (Oil)')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505696,1505697,4661,4662,456822,452811,010125,'Delivery Valve to Conoco 12"')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505692,1505693,4657,4658,456820,452812,010123,'Delivery Valve to Marathon')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505690,1505691,4655,4656,456819,452814,010122,'Delivery Valve to Shell/Amoco')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505647,1505648,4621,4622,456787,453234,010094,'Griffith Header')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505649,1505650,4896,4897,456787,453234,010095,'Griffith Header')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505571,1505572,4571,4572,456795,453240,010028,'Header Valve From Pasadena To ')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505577,1505578,4577,4578,456798,453358,010031,'Launcher Inlet Valve to Galena')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505575,1505576,4575,4576,456797,453360,010030,'Launcher Outlet Valve to Galen')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505698,1505699,4663,4664,456823,453371,010126,'Local Delivery to Buckeye 20" ')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505567,1505568,4568,4569,456794,453392,010025,'Mainline Block Valve From Pasa')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505867,1505868,4764,4765,456735,453456,010273,'Manifold Delivery Valve to Alo')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505865,1505866,4762,4763,456734,453457,010272,'Manifold Delivery Valve to Alo')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505861,1505862,4758,4759,456731,453458,010270,'Manifold Delivery Valve To Con')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505863,1505864,4760,4761,456732,453459,010271,'Manifold Delivery Valve To Con')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505707,1505708,4671,4672,456827,453477,010131,'Manifold Valve To and From Cla')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505703,1505704,4667,4668,456825,453478,010129,'Manifold Valve to and From Con')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505705,1505706,4669,4670,456826,453479,010130,'Manifold Valve To and From Con')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505289,1505290,4391,4392,456724,453482,009789,'Manifold Valve To Star')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505287,1505288,4389,4390,456723,453483,009788,'Manifold Valve To Williams')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505672,1505673,4642,4643,456816,453662,010112,'Prover Bypass Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505674,1505675,4644,4645,456817,453673,010113,'Prover Inlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505676,1505677,4898,4899,456817,453673,010114,'Prover Inlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505680,1505681,4900,4901,456818,453680,010116,'Prover Outlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505678,1505679,4646,4647,456818,453680,010115,'Prover Outlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505545,1505546,4550,4551,456777,453705,010010,'PU-1 Delivery Valve to BET')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505541,1505542,4546,4547,456775,453706,010008,'PU-1 Delivery Valve to Phillip')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505535,1505536,4540,4541,456772,453707,010005,'PU-1 Delivery Valve to Wolveri')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505539,1505540,4544,4545,456774,453708,010007,'PU-1 Delivery Valve to WSP')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505547,1505548,4552,4553,456778,453853,010011,'PU-2 Delivery Valve to BET')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505537,1505538,4542,4543,456773,453854,010006,'PU-2 Delivery Valve to CIT')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505551,1505552,4556,4557,456780,453855,010013,'PU-2 Delivery Valve to Phillip')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505549,1505550,4554,4555,456779,453856,010012,'PU-2 Delivery Valve to Wolveri')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505543,1505544,4548,4549,456776,453857,010009,'PU-2 Delivery Valve to WSP')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505525,1505526,4530,4531,456767,453977,010000,'PU-3 Delivery Valve to BET')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505527,1505528,4532,4533,456768,453978,010001,'PU-3 Delivery Valve to CIT')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505529,1505530,4534,4535,456769,453979,010002,'PU-3 Delivery Valve to E. Chic')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505531,1505532,4536,4537,456770,453980,010003,'PU-3 Delivery Valve to Phillip')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505533,1505534,4538,4539,456771,453981,010004,'PU-3 Delivery Valve to Wolveri')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505523,1505524,4528,4529,456766,453982,009999,'PU-3 Delivery Valve to WSP')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505684,1505685,4649,4650,456760,454097,010119,'Receiver Block Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505859,1505860,4756,4757,456765,454098,010269,'Receiver Inlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505827,1505828,4738,4739,456763,454099,010239,'Receiver Bypass Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505666,1505667,4638,4639,456812,454100,010109,'Receiver Bypass Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505561,1505562,4564,4565,456783,454102,010020,'Receiver Bypass Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505686,1505687,4651,4652,456761,454103,010120,'Receiver Bypass Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505377,1505378,4446,4447,456793,454104,009868,'Receiver Bypass Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505375,1505376,4444,4445,456792,454106,009867,'Receiver Discharge Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505557,1505558,4560,4561,456781,454113,010018,'Receiver Inlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505662,1505663,4634,4635,456810,454114,010107,'Receiver Inlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505373,1505374,4442,4443,456791,454115,009866,'Receiver Inlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505573,1505574,4573,4574,456796,454117,010029,'Receiver Inlet Valve From Port')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505688,1505689,4653,4654,456762,454118,010121,'Receiver Outlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505857,1505858,4754,4755,456764,454119,010268,'Receiver Outlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505559,1505560,4562,4563,456782,454120,010019,'Receiver Outlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505664,1505665,4636,4637,456811,454121,010108,'Receiver Outlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505668,1505669,4640,4641,456815,454168,010110,'Station Block Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505641,1505642,4617,4618,456785,454170,010091,'Station Bypass')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505643,1505644,4894,4895,456785,454170,010092,'Station Bypass')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505791,1505792,4716,4717,456730,454267,010204,'Station Exxon Delivery Valve  ')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505700,1505701,4665,4666,456824,454286,010127,'Station Header Valve to I.P')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505645,1505646,4619,4620,456786,454312,010093,'Station Inlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505887,1505888,4781,4782,456742,454323,010286,'Station Launcher Bypass Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505885,1505886,4779,4780,456741,454328,010285,'Station Launcher Inlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505883,1505884,4777,4778,456740,454332,010284,'Station Launcher Outlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505694,1505695,4659,4660,456821,454336,010124,'Station Local/14" Cross')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505881,1505882,4775,4776,456739,454358,010283,'Mainline Block Valve - 12" fro')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505291,1505292,4393,4394,456725,454451,009790,'Station Receiver Block Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505875,1505876,4769,4770,456736,454452,010280,'Station Receiver Block Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505879,1505880,4773,4774,456738,454454,010282,'Station Receiver Bypass Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505295,1505296,4397,4398,456727,454457,009792,'Station Receiver Bypass Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505293,1505294,4395,4396,456726,454464,009791,'Station Receiver Outlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505877,1505878,4771,4772,456737,454466,010281,'Station Receiver Outlet Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505371,1505372,4440,4441,456790,455419,009865,'Block Valve - From Magellan')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505369,1505370,4438,4439,456789,455420,009864,'Block Valve - To EPL Houston o')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505367,1505368,4436,4437,456788,455421,009863,'Tankage Delivery Block Valve')
INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (1505727,1505728,4691,4692,456837,455480,010141,'Valve from COP 20" to Mainline')

--Script all the delete and update statements. Run those in another query window.
DECLARE @fm_pk_DOT int, @fm_pk_PM int, @gii_pk_DOT int, @gii_pk_PM int, @fu_pk_DOT int, @fu_pk_PM int, @fm_tagNumber varchar(6), @fu_description_DOT varchar(100)
DECLARE g_cursor CURSOR FOR
select fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT
from #InspectionItemsToDelete

OPEN g_cursor

FETCH NEXT FROM g_cursor INTO  @fm_pk_DOT, @fm_pk_PM, @gii_pk_DOT, @gii_pk_PM, @fu_pk_DOT, @fu_pk_PM, @fm_tagNumber, @fu_description_DOT

WHILE (@@fetch_status <> -1) BEGIN

	--PRINT ('INSERT INTO #InspectionItemsToDelete (fm_pk_DOT, fm_pk_PM, gii_pk_DOT, gii_pk_PM, fu_pk_DOT, fu_pk_PM, fm_tagNumber, fu_description_DOT) VALUES (' + CONVERT(varchar, @fm_pk_DOT) + ',' + CONVERT(varchar, @fm_pk_PM) + ',' + CONVERT(varchar, @gii_pk_DOT) + ',' + CONVERT(varchar, @gii_pk_PM) + ',' + CONVERT(varchar, @fu_pk_DOT) + ',' + CONVERT(varchar, @fu_pk_PM) + ',' + CONVERT(varchar, @fm_tagNumber) + ',''' + CONVERT(varchar, @fu_description_DOT) + ''')')
	PRINT ('PRINT(''tagNumber=' + @fm_tagNumber + ';area=' + CONVERT(varchar, @fu_pk_DOT) + ''')')
	PRINT ('DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = ' + CONVERT(varchar, @fm_pk_DOT) + ' AND gii_PK = ' + CONVERT(varchar, @gii_pk_DOT))
	PRINT ('DELETE from f_statushistory where STH_FM_FK = ' + CONVERT(varchar, @fm_pk_DOT))
	PRINT ('DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = ' + CONVERT(varchar, @fm_pk_DOT))
	PRINT ('DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = ' + CONVERT(varchar, @fm_pk_DOT))
	PRINT ('DELETE FROM f_equipment where fm_pk = ' + CONVERT(varchar, @fm_pk_DOT))
	PRINT ('DELETE FROM f_area where fu_pk = ' + CONVERT(varchar, @fu_pk_DOT))
	PRINT ('UPDATE f_area set fu_wa_fk = 1011, fu_description = ''' + @fu_description_DOT + ''' where fu_wa_fk = 1012 and fu_pk = ' + CONVERT(varchar, @fu_pk_PM))
	PRINT ('DELETE from f_statushistory where STH_FM_FK = ' + CONVERT(varchar, @fm_pk_DOT))
	FETCH NEXT FROM g_cursor INTO  @fm_pk_DOT, @fm_pk_PM, @gii_pk_DOT, @gii_pk_PM, @fu_pk_DOT, @fu_pk_PM, @fm_tagNumber, @fu_description_DOT

END

CLOSE g_cursor
DEALLOCATE g_cursor

-- Here is the output that was executed. Status records got added late, so that's at the bottom.

BEGIN TRAN
set nocount on
PRINT('tagNumber=009965;area=456743')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505475 AND gii_PK = 4490
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505475
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505475
DELETE FROM f_equipment where fm_pk = 1505475
DELETE FROM f_area where fu_pk = 456743
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Manifold Valve - Conoco Delivery' where fu_wa_fk = 1012 and fu_pk = 441849
PRINT('tagNumber=009966;area=456744')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505477 AND gii_PK = 4492
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505477
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505477
DELETE FROM f_equipment where fm_pk = 1505477
DELETE FROM f_area where fu_pk = 456744
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Magellan 20" Oil Suction Valve ' where fu_wa_fk = 1012 and fu_pk = 441850
PRINT('tagNumber=009967;area=456745')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505479 AND gii_PK = 4494
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505479
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505479
DELETE FROM f_equipment where fm_pk = 1505479
DELETE FROM f_area where fu_pk = 456745
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Magellan Gasoline Suction Valve' where fu_wa_fk = 1012 and fu_pk = 441851
PRINT('tagNumber=009968;area=456746')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505481 AND gii_PK = 4496
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505481
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505481
DELETE FROM f_equipment where fm_pk = 1505481
DELETE FROM f_area where fu_pk = 456746
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Conoco Suction Valve' where fu_wa_fk = 1012 and fu_pk = 441852
PRINT('tagNumber=009973;area=456747')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505487 AND gii_PK = 4500
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505487
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505487
DELETE FROM f_equipment where fm_pk = 1505487
DELETE FROM f_area where fu_pk = 456747
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Inlet Valve - 28" Mainline' where fu_wa_fk = 1012 and fu_pk = 441876
PRINT('tagNumber=009974;area=456748')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505489 AND gii_PK = 4502
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505489
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505489
DELETE FROM f_equipment where fm_pk = 1505489
DELETE FROM f_area where fu_pk = 456748
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Bypass Valve - 28" Mainline' where fu_wa_fk = 1012 and fu_pk = 441877
PRINT('tagNumber=009975;area=456749')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505491 AND gii_PK = 4504
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505491
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505491
DELETE FROM f_equipment where fm_pk = 1505491
DELETE FROM f_area where fu_pk = 456749
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Outlet Valve - 28" Mainline' where fu_wa_fk = 1012 and fu_pk = 441878
PRINT('tagNumber=009976;area=456750')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505493 AND gii_PK = 4506
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505493
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505493
DELETE FROM f_equipment where fm_pk = 1505493
DELETE FROM f_area where fu_pk = 456750
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Launcher Outlet Valve - 28" West Tulsa Line' where fu_wa_fk = 1012 and fu_pk = 441879
PRINT('tagNumber=009977;area=456751')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505495 AND gii_PK = 4508
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505495
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505495
DELETE FROM f_equipment where fm_pk = 1505495
DELETE FROM f_area where fu_pk = 456751
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Launcher Bypass Valve - 28" West Tulsa Line' where fu_wa_fk = 1012 and fu_pk = 441880
PRINT('tagNumber=009978;area=456752')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505497 AND gii_PK = 4510
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505497
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505497
DELETE FROM f_equipment where fm_pk = 1505497
DELETE FROM f_area where fu_pk = 456752
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Launcher Inlet Valve - 28" West Tulsa Line' where fu_wa_fk = 1012 and fu_pk = 441881
PRINT('tagNumber=009979;area=456753')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505499 AND gii_PK = 4512
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505499
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505499
DELETE FROM f_equipment where fm_pk = 1505499
DELETE FROM f_area where fu_pk = 456753
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Launcher Outlet Valve - 24" Mainline' where fu_wa_fk = 1012 and fu_pk = 441882
PRINT('tagNumber=009980;area=456754')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505501 AND gii_PK = 4514
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505501
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505501
DELETE FROM f_equipment where fm_pk = 1505501
DELETE FROM f_area where fu_pk = 456754
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Launcher Bypass Valve - 24" Mainline' where fu_wa_fk = 1012 and fu_pk = 441883
PRINT('tagNumber=009981;area=456755')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505503 AND gii_PK = 4516
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505503
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505503
DELETE FROM f_equipment where fm_pk = 1505503
DELETE FROM f_area where fu_pk = 456755
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Launcher Inlet Valve - 24" Mainline' where fu_wa_fk = 1012 and fu_pk = 441884
PRINT('tagNumber=009982;area=456756')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505505 AND gii_PK = 4518
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505505
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505505
DELETE FROM f_equipment where fm_pk = 1505505
DELETE FROM f_area where fu_pk = 456756
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Block Valve to 20" Magellan Control Valve' where fu_wa_fk = 1012 and fu_pk = 441977
PRINT('tagNumber=010138;area=456834')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505721 AND gii_PK = 4685
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505721
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505721
DELETE FROM f_equipment where fm_pk = 1505721
DELETE FROM f_area where fu_pk = 456834
UPDATE f_area set fu_wa_fk = 1011, fu_description = '14" Launcher Block Valve' where fu_wa_fk = 1012 and fu_pk = 452319
PRINT('tagNumber=010139;area=456835')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505723 AND gii_PK = 4687
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505723
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505723
DELETE FROM f_equipment where fm_pk = 1505723
DELETE FROM f_area where fu_pk = 456835
UPDATE f_area set fu_wa_fk = 1011, fu_description = '14" Launcher Bypass Valve' where fu_wa_fk = 1012 and fu_pk = 452320
PRINT('tagNumber=010140;area=456836')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505725 AND gii_PK = 4689
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505725
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505725
DELETE FROM f_equipment where fm_pk = 1505725
DELETE FROM f_area where fu_pk = 456836
UPDATE f_area set fu_wa_fk = 1011, fu_description = '14" Launcher Inlet Valve' where fu_wa_fk = 1012 and fu_pk = 452321
PRINT('tagNumber=010135;area=456831')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505715 AND gii_PK = 4679
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505715
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505715
DELETE FROM f_equipment where fm_pk = 1505715
DELETE FROM f_area where fu_pk = 456831
UPDATE f_area set fu_wa_fk = 1011, fu_description = '24" Launcher Block Valve' where fu_wa_fk = 1012 and fu_pk = 452363
PRINT('tagNumber=010137;area=456833')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505719 AND gii_PK = 4683
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505719
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505719
DELETE FROM f_equipment where fm_pk = 1505719
DELETE FROM f_area where fu_pk = 456833
UPDATE f_area set fu_wa_fk = 1011, fu_description = '24" Launcher Bypass Valve' where fu_wa_fk = 1012 and fu_pk = 452364
PRINT('tagNumber=010136;area=456832')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505717 AND gii_PK = 4681
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505717
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505717
DELETE FROM f_equipment where fm_pk = 1505717
DELETE FROM f_area where fu_pk = 456832
UPDATE f_area set fu_wa_fk = 1011, fu_description = '24" Launcher Inlet Valve' where fu_wa_fk = 1012 and fu_pk = 452365
PRINT('tagNumber=010132;area=456828')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505709 AND gii_PK = 4673
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505709
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505709
DELETE FROM f_equipment where fm_pk = 1505709
DELETE FROM f_area where fu_pk = 456828
UPDATE f_area set fu_wa_fk = 1011, fu_description = '24" Receiver Block Valve' where fu_wa_fk = 1012 and fu_pk = 452389
PRINT('tagNumber=010133;area=456829')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505711 AND gii_PK = 4675
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505711
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505711
DELETE FROM f_equipment where fm_pk = 1505711
DELETE FROM f_area where fu_pk = 456829
UPDATE f_area set fu_wa_fk = 1011, fu_description = '24" Receiver Bypass Valve' where fu_wa_fk = 1012 and fu_pk = 452390
PRINT('tagNumber=010134;area=456830')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505713 AND gii_PK = 4677
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505713
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505713
DELETE FROM f_equipment where fm_pk = 1505713
DELETE FROM f_area where fu_pk = 456830
UPDATE f_area set fu_wa_fk = 1011, fu_description = '24" Receiver Outlet Valve' where fu_wa_fk = 1012 and fu_pk = 452391
PRINT('tagNumber=010040;area=456757')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505587 AND gii_PK = 4583
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505587
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505587
DELETE FROM f_equipment where fm_pk = 1505587
DELETE FROM f_area where fu_pk = 456757
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Block Valve (Delivery)' where fu_wa_fk = 1012 and fu_pk = 452518
PRINT('tagNumber=010042;area=456759')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505591 AND gii_PK = 4587
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505591
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505591
DELETE FROM f_equipment where fm_pk = 1505591
DELETE FROM f_area where fu_pk = 456759
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Delivery Valve (Gas)' where fu_wa_fk = 1012 and fu_pk = 452808
PRINT('tagNumber=010041;area=456758')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505589 AND gii_PK = 4585
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505589
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505589
DELETE FROM f_equipment where fm_pk = 1505589
DELETE FROM f_area where fu_pk = 456758
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Delivery Valve (Oil)' where fu_wa_fk = 1012 and fu_pk = 452809
PRINT('tagNumber=010125;area=456822')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505696 AND gii_PK = 4661
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505696
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505696
DELETE FROM f_equipment where fm_pk = 1505696
DELETE FROM f_area where fu_pk = 456822
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Delivery Valve to Conoco 12"' where fu_wa_fk = 1012 and fu_pk = 452811
PRINT('tagNumber=010123;area=456820')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505692 AND gii_PK = 4657
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505692
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505692
DELETE FROM f_equipment where fm_pk = 1505692
DELETE FROM f_area where fu_pk = 456820
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Delivery Valve to Marathon' where fu_wa_fk = 1012 and fu_pk = 452812
PRINT('tagNumber=010122;area=456819')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505690 AND gii_PK = 4655
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505690
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505690
DELETE FROM f_equipment where fm_pk = 1505690
DELETE FROM f_area where fu_pk = 456819
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Delivery Valve to Shell/Amoco' where fu_wa_fk = 1012 and fu_pk = 452814
PRINT('tagNumber=010094;area=456787')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505647 AND gii_PK = 4621
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505647
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505647
DELETE FROM f_equipment where fm_pk = 1505647
DELETE FROM f_area where fu_pk = 456787
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Griffith Header' where fu_wa_fk = 1012 and fu_pk = 453234
PRINT('tagNumber=010095;area=456787')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505649 AND gii_PK = 4896
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505649
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505649
DELETE FROM f_equipment where fm_pk = 1505649
DELETE FROM f_area where fu_pk = 456787
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Griffith Header' where fu_wa_fk = 1012 and fu_pk = 453234
PRINT('tagNumber=010028;area=456795')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505571 AND gii_PK = 4571
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505571
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505571
DELETE FROM f_equipment where fm_pk = 1505571
DELETE FROM f_area where fu_pk = 456795
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Header Valve From Pasadena To Galena Park/Fauna 10"' where fu_wa_fk = 1012 and fu_pk = 453240
PRINT('tagNumber=010031;area=456798')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505577 AND gii_PK = 4577
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505577
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505577
DELETE FROM f_equipment where fm_pk = 1505577
DELETE FROM f_area where fu_pk = 456798
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Launcher Inlet Valve to Galena Park' where fu_wa_fk = 1012 and fu_pk = 453358
PRINT('tagNumber=010030;area=456797')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505575 AND gii_PK = 4575
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505575
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505575
DELETE FROM f_equipment where fm_pk = 1505575
DELETE FROM f_area where fu_pk = 456797
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Launcher Outlet Valve to Galena Park' where fu_wa_fk = 1012 and fu_pk = 453360
PRINT('tagNumber=010126;area=456823')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505698 AND gii_PK = 4663
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505698
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505698
DELETE FROM f_equipment where fm_pk = 1505698
DELETE FROM f_area where fu_pk = 456823
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Local Delivery to Buckeye 20" (Marathon 2 Rivers)' where fu_wa_fk = 1012 and fu_pk = 453371
PRINT('tagNumber=010025;area=456794')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505567 AND gii_PK = 4568
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505567
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505567
DELETE FROM f_equipment where fm_pk = 1505567
DELETE FROM f_area where fu_pk = 456794
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Mainline Block Valve From Pasadena' where fu_wa_fk = 1012 and fu_pk = 453392
PRINT('tagNumber=010273;area=456735')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505867 AND gii_PK = 4764
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505867
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505867
DELETE FROM f_equipment where fm_pk = 1505867
DELETE FROM f_area where fu_pk = 456735
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Manifold Delivery Valve to Alon Gas' where fu_wa_fk = 1012 and fu_pk = 453456
PRINT('tagNumber=010272;area=456734')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505865 AND gii_PK = 4762
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505865
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505865
DELETE FROM f_equipment where fm_pk = 1505865
DELETE FROM f_area where fu_pk = 456734
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Manifold Delivery Valve to Alon Oil' where fu_wa_fk = 1012 and fu_pk = 453457
PRINT('tagNumber=010270;area=456731')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505861 AND gii_PK = 4758
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505861
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505861
DELETE FROM f_equipment where fm_pk = 1505861
DELETE FROM f_area where fu_pk = 456731
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Manifold Delivery Valve To Conoco Gas' where fu_wa_fk = 1012 and fu_pk = 453458
PRINT('tagNumber=010271;area=456732')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505863 AND gii_PK = 4760
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505863
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505863
DELETE FROM f_equipment where fm_pk = 1505863
DELETE FROM f_area where fu_pk = 456732
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Manifold Delivery Valve To Conoco Oil' where fu_wa_fk = 1012 and fu_pk = 453459
PRINT('tagNumber=010131;area=456827')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505707 AND gii_PK = 4671
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505707
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505707
DELETE FROM f_equipment where fm_pk = 1505707
DELETE FROM f_area where fu_pk = 456827
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Manifold Valve To and From Clark' where fu_wa_fk = 1012 and fu_pk = 453477
PRINT('tagNumber=010129;area=456825')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505703 AND gii_PK = 4667
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505703
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505703
DELETE FROM f_equipment where fm_pk = 1505703
DELETE FROM f_area where fu_pk = 456825
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Manifold Valve to and From Conoco Phillips' where fu_wa_fk = 1012 and fu_pk = 453478
PRINT('tagNumber=010130;area=456826')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505705 AND gii_PK = 4669
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505705
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505705
DELETE FROM f_equipment where fm_pk = 1505705
DELETE FROM f_area where fu_pk = 456826
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Manifold Valve To and From Conoco Phillips' where fu_wa_fk = 1012 and fu_pk = 453479
PRINT('tagNumber=009789;area=456724')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505289 AND gii_PK = 4391
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505289
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505289
DELETE FROM f_equipment where fm_pk = 1505289
DELETE FROM f_area where fu_pk = 456724
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Manifold Valve To Star' where fu_wa_fk = 1012 and fu_pk = 453482
PRINT('tagNumber=009788;area=456723')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505287 AND gii_PK = 4389
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505287
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505287
DELETE FROM f_equipment where fm_pk = 1505287
DELETE FROM f_area where fu_pk = 456723
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Manifold Valve To Williams' where fu_wa_fk = 1012 and fu_pk = 453483
PRINT('tagNumber=010112;area=456816')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505672 AND gii_PK = 4642
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505672
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505672
DELETE FROM f_equipment where fm_pk = 1505672
DELETE FROM f_area where fu_pk = 456816
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Prover Bypass Valve' where fu_wa_fk = 1012 and fu_pk = 453662
PRINT('tagNumber=010113;area=456817')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505674 AND gii_PK = 4644
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505674
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505674
DELETE FROM f_equipment where fm_pk = 1505674
DELETE FROM f_area where fu_pk = 456817
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Prover Inlet Valve' where fu_wa_fk = 1012 and fu_pk = 453673
PRINT('tagNumber=010114;area=456817')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505676 AND gii_PK = 4898
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505676
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505676
DELETE FROM f_equipment where fm_pk = 1505676
DELETE FROM f_area where fu_pk = 456817
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Prover Inlet Valve' where fu_wa_fk = 1012 and fu_pk = 453673
PRINT('tagNumber=010116;area=456818')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505680 AND gii_PK = 4900
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505680
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505680
DELETE FROM f_equipment where fm_pk = 1505680
DELETE FROM f_area where fu_pk = 456818
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Prover Outlet Valve' where fu_wa_fk = 1012 and fu_pk = 453680
PRINT('tagNumber=010115;area=456818')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505678 AND gii_PK = 4646
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505678
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505678
DELETE FROM f_equipment where fm_pk = 1505678
DELETE FROM f_area where fu_pk = 456818
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Prover Outlet Valve' where fu_wa_fk = 1012 and fu_pk = 453680
PRINT('tagNumber=010010;area=456777')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505545 AND gii_PK = 4550
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505545
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505545
DELETE FROM f_equipment where fm_pk = 1505545
DELETE FROM f_area where fu_pk = 456777
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'PU-1 Delivery Valve to BET' where fu_wa_fk = 1012 and fu_pk = 453705
PRINT('tagNumber=010008;area=456775')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505541 AND gii_PK = 4546
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505541
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505541
DELETE FROM f_equipment where fm_pk = 1505541
DELETE FROM f_area where fu_pk = 456775
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'PU-1 Delivery Valve to Phillips' where fu_wa_fk = 1012 and fu_pk = 453706
PRINT('tagNumber=010005;area=456772')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505535 AND gii_PK = 4540
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505535
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505535
DELETE FROM f_equipment where fm_pk = 1505535
DELETE FROM f_area where fu_pk = 456772
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'PU-1 Delivery Valve to Wolverine' where fu_wa_fk = 1012 and fu_pk = 453707
PRINT('tagNumber=010007;area=456774')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505539 AND gii_PK = 4544
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505539
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505539
DELETE FROM f_equipment where fm_pk = 1505539
DELETE FROM f_area where fu_pk = 456774
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'PU-1 Delivery Valve to WSP' where fu_wa_fk = 1012 and fu_pk = 453708
PRINT('tagNumber=010011;area=456778')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505547 AND gii_PK = 4552
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505547
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505547
DELETE FROM f_equipment where fm_pk = 1505547
DELETE FROM f_area where fu_pk = 456778
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'PU-2 Delivery Valve to BET' where fu_wa_fk = 1012 and fu_pk = 453853
PRINT('tagNumber=010006;area=456773')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505537 AND gii_PK = 4542
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505537
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505537
DELETE FROM f_equipment where fm_pk = 1505537
DELETE FROM f_area where fu_pk = 456773
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'PU-2 Delivery Valve to CIT' where fu_wa_fk = 1012 and fu_pk = 453854
PRINT('tagNumber=010013;area=456780')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505551 AND gii_PK = 4556
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505551
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505551
DELETE FROM f_equipment where fm_pk = 1505551
DELETE FROM f_area where fu_pk = 456780
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'PU-2 Delivery Valve to Phillips' where fu_wa_fk = 1012 and fu_pk = 453855
PRINT('tagNumber=010012;area=456779')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505549 AND gii_PK = 4554
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505549
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505549
DELETE FROM f_equipment where fm_pk = 1505549
DELETE FROM f_area where fu_pk = 456779
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'PU-2 Delivery Valve to Wolverine' where fu_wa_fk = 1012 and fu_pk = 453856
PRINT('tagNumber=010009;area=456776')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505543 AND gii_PK = 4548
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505543
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505543
DELETE FROM f_equipment where fm_pk = 1505543
DELETE FROM f_area where fu_pk = 456776
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'PU-2 Delivery Valve to WSP' where fu_wa_fk = 1012 and fu_pk = 453857
PRINT('tagNumber=010000;area=456767')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505525 AND gii_PK = 4530
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505525
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505525
DELETE FROM f_equipment where fm_pk = 1505525
DELETE FROM f_area where fu_pk = 456767
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'PU-3 Delivery Valve to BET' where fu_wa_fk = 1012 and fu_pk = 453977
PRINT('tagNumber=010001;area=456768')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505527 AND gii_PK = 4532
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505527
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505527
DELETE FROM f_equipment where fm_pk = 1505527
DELETE FROM f_area where fu_pk = 456768
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'PU-3 Delivery Valve to CIT' where fu_wa_fk = 1012 and fu_pk = 453978
PRINT('tagNumber=010002;area=456769')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505529 AND gii_PK = 4534
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505529
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505529
DELETE FROM f_equipment where fm_pk = 1505529
DELETE FROM f_area where fu_pk = 456769
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'PU-3 Delivery Valve to E. Chicago' where fu_wa_fk = 1012 and fu_pk = 453979
PRINT('tagNumber=010003;area=456770')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505531 AND gii_PK = 4536
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505531
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505531
DELETE FROM f_equipment where fm_pk = 1505531
DELETE FROM f_area where fu_pk = 456770
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'PU-3 Delivery Valve to Phillips' where fu_wa_fk = 1012 and fu_pk = 453980
PRINT('tagNumber=010004;area=456771')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505533 AND gii_PK = 4538
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505533
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505533
DELETE FROM f_equipment where fm_pk = 1505533
DELETE FROM f_area where fu_pk = 456771
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'PU-3 Delivery Valve to Wolverine' where fu_wa_fk = 1012 and fu_pk = 453981
PRINT('tagNumber=009999;area=456766')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505523 AND gii_PK = 4528
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505523
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505523
DELETE FROM f_equipment where fm_pk = 1505523
DELETE FROM f_area where fu_pk = 456766
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'PU-3 Delivery Valve to WSP' where fu_wa_fk = 1012 and fu_pk = 453982
PRINT('tagNumber=010119;area=456760')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505684 AND gii_PK = 4649
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505684
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505684
DELETE FROM f_equipment where fm_pk = 1505684
DELETE FROM f_area where fu_pk = 456760
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Block Valve' where fu_wa_fk = 1012 and fu_pk = 454097
PRINT('tagNumber=010269;area=456765')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505859 AND gii_PK = 4756
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505859
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505859
DELETE FROM f_equipment where fm_pk = 1505859
DELETE FROM f_area where fu_pk = 456765
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Inlet Valve' where fu_wa_fk = 1012 and fu_pk = 454098
PRINT('tagNumber=010239;area=456763')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505827 AND gii_PK = 4738
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505827
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505827
DELETE FROM f_equipment where fm_pk = 1505827
DELETE FROM f_area where fu_pk = 456763
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Bypass Valve' where fu_wa_fk = 1012 and fu_pk = 454099
PRINT('tagNumber=010109;area=456812')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505666 AND gii_PK = 4638
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505666
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505666
DELETE FROM f_equipment where fm_pk = 1505666
DELETE FROM f_area where fu_pk = 456812
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Bypass Valve' where fu_wa_fk = 1012 and fu_pk = 454100
PRINT('tagNumber=010020;area=456783')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505561 AND gii_PK = 4564
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505561
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505561
DELETE FROM f_equipment where fm_pk = 1505561
DELETE FROM f_area where fu_pk = 456783
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Bypass Valve' where fu_wa_fk = 1012 and fu_pk = 454102
PRINT('tagNumber=010120;area=456761')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505686 AND gii_PK = 4651
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505686
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505686
DELETE FROM f_equipment where fm_pk = 1505686
DELETE FROM f_area where fu_pk = 456761
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Bypass Valve' where fu_wa_fk = 1012 and fu_pk = 454103
PRINT('tagNumber=009868;area=456793')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505377 AND gii_PK = 4446
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505377
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505377
DELETE FROM f_equipment where fm_pk = 1505377
DELETE FROM f_area where fu_pk = 456793
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Bypass Valve' where fu_wa_fk = 1012 and fu_pk = 454104
PRINT('tagNumber=009867;area=456792')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505375 AND gii_PK = 4444
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505375
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505375
DELETE FROM f_equipment where fm_pk = 1505375
DELETE FROM f_area where fu_pk = 456792
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Discharge Valve' where fu_wa_fk = 1012 and fu_pk = 454106
PRINT('tagNumber=010018;area=456781')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505557 AND gii_PK = 4560
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505557
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505557
DELETE FROM f_equipment where fm_pk = 1505557
DELETE FROM f_area where fu_pk = 456781
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Inlet Valve' where fu_wa_fk = 1012 and fu_pk = 454113
PRINT('tagNumber=010107;area=456810')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505662 AND gii_PK = 4634
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505662
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505662
DELETE FROM f_equipment where fm_pk = 1505662
DELETE FROM f_area where fu_pk = 456810
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Inlet Valve' where fu_wa_fk = 1012 and fu_pk = 454114
PRINT('tagNumber=009866;area=456791')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505373 AND gii_PK = 4442
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505373
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505373
DELETE FROM f_equipment where fm_pk = 1505373
DELETE FROM f_area where fu_pk = 456791
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Inlet Valve' where fu_wa_fk = 1012 and fu_pk = 454115
PRINT('tagNumber=010029;area=456796')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505573 AND gii_PK = 4573
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505573
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505573
DELETE FROM f_equipment where fm_pk = 1505573
DELETE FROM f_area where fu_pk = 456796
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Inlet Valve From Port Arthur' where fu_wa_fk = 1012 and fu_pk = 454117
PRINT('tagNumber=010121;area=456762')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505688 AND gii_PK = 4653
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505688
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505688
DELETE FROM f_equipment where fm_pk = 1505688
DELETE FROM f_area where fu_pk = 456762
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Outlet Valve' where fu_wa_fk = 1012 and fu_pk = 454118
PRINT('tagNumber=010268;area=456764')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505857 AND gii_PK = 4754
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505857
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505857
DELETE FROM f_equipment where fm_pk = 1505857
DELETE FROM f_area where fu_pk = 456764
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Outlet Valve' where fu_wa_fk = 1012 and fu_pk = 454119
PRINT('tagNumber=010019;area=456782')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505559 AND gii_PK = 4562
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505559
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505559
DELETE FROM f_equipment where fm_pk = 1505559
DELETE FROM f_area where fu_pk = 456782
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Outlet Valve' where fu_wa_fk = 1012 and fu_pk = 454120
PRINT('tagNumber=010108;area=456811')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505664 AND gii_PK = 4636
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505664
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505664
DELETE FROM f_equipment where fm_pk = 1505664
DELETE FROM f_area where fu_pk = 456811
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Receiver Outlet Valve' where fu_wa_fk = 1012 and fu_pk = 454121
PRINT('tagNumber=010110;area=456815')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505668 AND gii_PK = 4640
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505668
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505668
DELETE FROM f_equipment where fm_pk = 1505668
DELETE FROM f_area where fu_pk = 456815
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Station Block Valve' where fu_wa_fk = 1012 and fu_pk = 454168
PRINT('tagNumber=010091;area=456785')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505641 AND gii_PK = 4617
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505641
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505641
DELETE FROM f_equipment where fm_pk = 1505641
DELETE FROM f_area where fu_pk = 456785
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Station Bypass' where fu_wa_fk = 1012 and fu_pk = 454170
PRINT('tagNumber=010092;area=456785')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505643 AND gii_PK = 4894
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505643
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505643
DELETE FROM f_equipment where fm_pk = 1505643
DELETE FROM f_area where fu_pk = 456785
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Station Bypass' where fu_wa_fk = 1012 and fu_pk = 454170
PRINT('tagNumber=010204;area=456730')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505791 AND gii_PK = 4716
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505791
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505791
DELETE FROM f_equipment where fm_pk = 1505791
DELETE FROM f_area where fu_pk = 456730
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Station Exxon Delivery Valve  ' where fu_wa_fk = 1012 and fu_pk = 454267
PRINT('tagNumber=010127;area=456824')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505700 AND gii_PK = 4665
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505700
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505700
DELETE FROM f_equipment where fm_pk = 1505700
DELETE FROM f_area where fu_pk = 456824
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Station Header Valve to I.P' where fu_wa_fk = 1012 and fu_pk = 454286
PRINT('tagNumber=010093;area=456786')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505645 AND gii_PK = 4619
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505645
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505645
DELETE FROM f_equipment where fm_pk = 1505645
DELETE FROM f_area where fu_pk = 456786
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Station Inlet Valve' where fu_wa_fk = 1012 and fu_pk = 454312
PRINT('tagNumber=010286;area=456742')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505887 AND gii_PK = 4781
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505887
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505887
DELETE FROM f_equipment where fm_pk = 1505887
DELETE FROM f_area where fu_pk = 456742
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Station Launcher Bypass Valve' where fu_wa_fk = 1012 and fu_pk = 454323
PRINT('tagNumber=010285;area=456741')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505885 AND gii_PK = 4779
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505885
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505885
DELETE FROM f_equipment where fm_pk = 1505885
DELETE FROM f_area where fu_pk = 456741
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Station Launcher Inlet Valve' where fu_wa_fk = 1012 and fu_pk = 454328
PRINT('tagNumber=010284;area=456740')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505883 AND gii_PK = 4777
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505883
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505883
DELETE FROM f_equipment where fm_pk = 1505883
DELETE FROM f_area where fu_pk = 456740
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Station Launcher Outlet Valve' where fu_wa_fk = 1012 and fu_pk = 454332
PRINT('tagNumber=010124;area=456821')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505694 AND gii_PK = 4659
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505694
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505694
DELETE FROM f_equipment where fm_pk = 1505694
DELETE FROM f_area where fu_pk = 456821
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Station Local/14" Cross' where fu_wa_fk = 1012 and fu_pk = 454336
PRINT('tagNumber=010283;area=456739')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505881 AND gii_PK = 4775
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505881
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505881
DELETE FROM f_equipment where fm_pk = 1505881
DELETE FROM f_area where fu_pk = 456739
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Mainline Block Valve - 12" from Carrolton' where fu_wa_fk = 1012 and fu_pk = 454358
PRINT('tagNumber=009790;area=456725')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505291 AND gii_PK = 4393
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505291
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505291
DELETE FROM f_equipment where fm_pk = 1505291
DELETE FROM f_area where fu_pk = 456725
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Station Receiver Block Valve' where fu_wa_fk = 1012 and fu_pk = 454451
PRINT('tagNumber=010280;area=456736')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505875 AND gii_PK = 4769
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505875
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505875
DELETE FROM f_equipment where fm_pk = 1505875
DELETE FROM f_area where fu_pk = 456736
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Station Receiver Block Valve' where fu_wa_fk = 1012 and fu_pk = 454452
PRINT('tagNumber=010282;area=456738')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505879 AND gii_PK = 4773
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505879
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505879
DELETE FROM f_equipment where fm_pk = 1505879
DELETE FROM f_area where fu_pk = 456738
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Station Receiver Bypass Valve' where fu_wa_fk = 1012 and fu_pk = 454454
PRINT('tagNumber=009792;area=456727')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505295 AND gii_PK = 4397
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505295
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505295
DELETE FROM f_equipment where fm_pk = 1505295
DELETE FROM f_area where fu_pk = 456727
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Station Receiver Bypass Valve' where fu_wa_fk = 1012 and fu_pk = 454457
PRINT('tagNumber=009791;area=456726')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505293 AND gii_PK = 4395
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505293
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505293
DELETE FROM f_equipment where fm_pk = 1505293
DELETE FROM f_area where fu_pk = 456726
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Station Receiver Outlet Valve' where fu_wa_fk = 1012 and fu_pk = 454464
PRINT('tagNumber=010281;area=456737')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505877 AND gii_PK = 4771
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505877
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505877
DELETE FROM f_equipment where fm_pk = 1505877
DELETE FROM f_area where fu_pk = 456737
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Station Receiver Outlet Valve' where fu_wa_fk = 1012 and fu_pk = 454466
PRINT('tagNumber=009865;area=456790')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505371 AND gii_PK = 4440
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505371
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505371
DELETE FROM f_equipment where fm_pk = 1505371
DELETE FROM f_area where fu_pk = 456790
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Block Valve - From Magellan' where fu_wa_fk = 1012 and fu_pk = 455419
PRINT('tagNumber=009864;area=456789')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505369 AND gii_PK = 4438
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505369
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505369
DELETE FROM f_equipment where fm_pk = 1505369
DELETE FROM f_area where fu_pk = 456789
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Block Valve - To EPL Houston or Magellan' where fu_wa_fk = 1012 and fu_pk = 455420
PRINT('tagNumber=009863;area=456788')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505367 AND gii_PK = 4436
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505367
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505367
DELETE FROM f_equipment where fm_pk = 1505367
DELETE FROM f_area where fu_pk = 456788
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Tankage Delivery Block Valve' where fu_wa_fk = 1012 and fu_pk = 455421
PRINT('tagNumber=010141;area=456837')
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505727 AND gii_PK = 4691
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505727
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505727
DELETE FROM f_equipment where fm_pk = 1505727
DELETE FROM f_area where fu_pk = 456837
UPDATE f_area set fu_wa_fk = 1011, fu_description = 'Valve from COP 20" to Mainline Meter 38' where fu_wa_fk = 1012 and fu_pk = 455480
commit tran

--Some of the slots had more than one piece of this equipment. Deleting slots gave errors on the delete of first piece of equipment, succeeds on second.
--So were good...
select * from f_area where fu_pk IN (456787,456817,456818,456815,456785)
--...except for one where the second piece of equipment wasn't in our list of duplicates. Looks like it should have been. Oh well. Just manually deleted it anyway.
select * from f_area where fu_unitID = 'STP-B102'
DELETE FROM f_genInspectionItem where GII_ItemType_fk = 0 and gii_item_fk = 1505670
DELETE FROM f_equipmentRepairCenterLink where fmrc_fm_fk = 1505670
DELETE FROM f_groupitem where pgl_itemType_fk = 0 and pgl_item_fk = 1505670
DELETE FROM f_equipment where fm_pk = 1505670
DELETE FROM f_area where fu_pk = 456815
DELETE FROM f_statushistory where sth_fm_fk = 1505670

-- needed to get rid of the status records for all these dups as well.
begin tran
PRINT('tagNumber=009965;area=456743')
DELETE from f_statushistory where STH_FM_FK = 1505475
PRINT('tagNumber=009966;area=456744')
DELETE from f_statushistory where STH_FM_FK = 1505477
PRINT('tagNumber=009967;area=456745')
DELETE from f_statushistory where STH_FM_FK = 1505479
PRINT('tagNumber=009968;area=456746')
DELETE from f_statushistory where STH_FM_FK = 1505481
PRINT('tagNumber=009973;area=456747')
DELETE from f_statushistory where STH_FM_FK = 1505487
PRINT('tagNumber=009974;area=456748')
DELETE from f_statushistory where STH_FM_FK = 1505489
PRINT('tagNumber=009975;area=456749')
DELETE from f_statushistory where STH_FM_FK = 1505491
PRINT('tagNumber=009976;area=456750')
DELETE from f_statushistory where STH_FM_FK = 1505493
PRINT('tagNumber=009977;area=456751')
DELETE from f_statushistory where STH_FM_FK = 1505495
PRINT('tagNumber=009978;area=456752')
DELETE from f_statushistory where STH_FM_FK = 1505497
PRINT('tagNumber=009979;area=456753')
DELETE from f_statushistory where STH_FM_FK = 1505499
PRINT('tagNumber=009980;area=456754')
DELETE from f_statushistory where STH_FM_FK = 1505501
PRINT('tagNumber=009981;area=456755')
DELETE from f_statushistory where STH_FM_FK = 1505503
PRINT('tagNumber=009982;area=456756')
DELETE from f_statushistory where STH_FM_FK = 1505505
PRINT('tagNumber=010138;area=456834')
DELETE from f_statushistory where STH_FM_FK = 1505721
PRINT('tagNumber=010139;area=456835')
DELETE from f_statushistory where STH_FM_FK = 1505723
PRINT('tagNumber=010140;area=456836')
DELETE from f_statushistory where STH_FM_FK = 1505725
PRINT('tagNumber=010135;area=456831')
DELETE from f_statushistory where STH_FM_FK = 1505715
PRINT('tagNumber=010137;area=456833')
DELETE from f_statushistory where STH_FM_FK = 1505719
PRINT('tagNumber=010136;area=456832')
DELETE from f_statushistory where STH_FM_FK = 1505717
PRINT('tagNumber=010132;area=456828')
DELETE from f_statushistory where STH_FM_FK = 1505709
PRINT('tagNumber=010133;area=456829')
DELETE from f_statushistory where STH_FM_FK = 1505711
PRINT('tagNumber=010134;area=456830')
DELETE from f_statushistory where STH_FM_FK = 1505713
PRINT('tagNumber=010040;area=456757')
DELETE from f_statushistory where STH_FM_FK = 1505587
PRINT('tagNumber=010042;area=456759')
DELETE from f_statushistory where STH_FM_FK = 1505591
PRINT('tagNumber=010041;area=456758')
DELETE from f_statushistory where STH_FM_FK = 1505589
PRINT('tagNumber=010125;area=456822')
DELETE from f_statushistory where STH_FM_FK = 1505696
PRINT('tagNumber=010123;area=456820')
DELETE from f_statushistory where STH_FM_FK = 1505692
PRINT('tagNumber=010122;area=456819')
DELETE from f_statushistory where STH_FM_FK = 1505690
PRINT('tagNumber=010094;area=456787')
DELETE from f_statushistory where STH_FM_FK = 1505647
PRINT('tagNumber=010095;area=456787')
DELETE from f_statushistory where STH_FM_FK = 1505649
PRINT('tagNumber=010028;area=456795')
DELETE from f_statushistory where STH_FM_FK = 1505571
PRINT('tagNumber=010031;area=456798')
DELETE from f_statushistory where STH_FM_FK = 1505577
PRINT('tagNumber=010030;area=456797')
DELETE from f_statushistory where STH_FM_FK = 1505575
PRINT('tagNumber=010126;area=456823')
DELETE from f_statushistory where STH_FM_FK = 1505698
PRINT('tagNumber=010025;area=456794')
DELETE from f_statushistory where STH_FM_FK = 1505567
PRINT('tagNumber=010273;area=456735')
DELETE from f_statushistory where STH_FM_FK = 1505867
PRINT('tagNumber=010272;area=456734')
DELETE from f_statushistory where STH_FM_FK = 1505865
PRINT('tagNumber=010270;area=456731')
DELETE from f_statushistory where STH_FM_FK = 1505861
PRINT('tagNumber=010271;area=456732')
DELETE from f_statushistory where STH_FM_FK = 1505863
PRINT('tagNumber=010131;area=456827')
DELETE from f_statushistory where STH_FM_FK = 1505707
PRINT('tagNumber=010129;area=456825')
DELETE from f_statushistory where STH_FM_FK = 1505703
PRINT('tagNumber=010130;area=456826')
DELETE from f_statushistory where STH_FM_FK = 1505705
PRINT('tagNumber=009789;area=456724')
DELETE from f_statushistory where STH_FM_FK = 1505289
PRINT('tagNumber=009788;area=456723')
DELETE from f_statushistory where STH_FM_FK = 1505287
PRINT('tagNumber=010112;area=456816')
DELETE from f_statushistory where STH_FM_FK = 1505672
PRINT('tagNumber=010113;area=456817')
DELETE from f_statushistory where STH_FM_FK = 1505674
PRINT('tagNumber=010114;area=456817')
DELETE from f_statushistory where STH_FM_FK = 1505676
PRINT('tagNumber=010116;area=456818')
DELETE from f_statushistory where STH_FM_FK = 1505680
PRINT('tagNumber=010115;area=456818')
DELETE from f_statushistory where STH_FM_FK = 1505678
PRINT('tagNumber=010010;area=456777')
DELETE from f_statushistory where STH_FM_FK = 1505545
PRINT('tagNumber=010008;area=456775')
DELETE from f_statushistory where STH_FM_FK = 1505541
PRINT('tagNumber=010005;area=456772')
DELETE from f_statushistory where STH_FM_FK = 1505535
PRINT('tagNumber=010007;area=456774')
DELETE from f_statushistory where STH_FM_FK = 1505539
PRINT('tagNumber=010011;area=456778')
DELETE from f_statushistory where STH_FM_FK = 1505547
PRINT('tagNumber=010006;area=456773')
DELETE from f_statushistory where STH_FM_FK = 1505537
PRINT('tagNumber=010013;area=456780')
DELETE from f_statushistory where STH_FM_FK = 1505551
PRINT('tagNumber=010012;area=456779')
DELETE from f_statushistory where STH_FM_FK = 1505549
PRINT('tagNumber=010009;area=456776')
DELETE from f_statushistory where STH_FM_FK = 1505543
PRINT('tagNumber=010000;area=456767')
DELETE from f_statushistory where STH_FM_FK = 1505525
PRINT('tagNumber=010001;area=456768')
DELETE from f_statushistory where STH_FM_FK = 1505527
PRINT('tagNumber=010002;area=456769')
DELETE from f_statushistory where STH_FM_FK = 1505529
PRINT('tagNumber=010003;area=456770')
DELETE from f_statushistory where STH_FM_FK = 1505531
PRINT('tagNumber=010004;area=456771')
DELETE from f_statushistory where STH_FM_FK = 1505533
PRINT('tagNumber=009999;area=456766')
DELETE from f_statushistory where STH_FM_FK = 1505523
PRINT('tagNumber=010119;area=456760')
DELETE from f_statushistory where STH_FM_FK = 1505684
PRINT('tagNumber=010269;area=456765')
DELETE from f_statushistory where STH_FM_FK = 1505859
PRINT('tagNumber=010239;area=456763')
DELETE from f_statushistory where STH_FM_FK = 1505827
PRINT('tagNumber=010109;area=456812')
DELETE from f_statushistory where STH_FM_FK = 1505666
PRINT('tagNumber=010020;area=456783')
DELETE from f_statushistory where STH_FM_FK = 1505561
PRINT('tagNumber=010120;area=456761')
DELETE from f_statushistory where STH_FM_FK = 1505686
PRINT('tagNumber=009868;area=456793')
DELETE from f_statushistory where STH_FM_FK = 1505377
PRINT('tagNumber=009867;area=456792')
DELETE from f_statushistory where STH_FM_FK = 1505375
PRINT('tagNumber=010018;area=456781')
DELETE from f_statushistory where STH_FM_FK = 1505557
PRINT('tagNumber=010107;area=456810')
DELETE from f_statushistory where STH_FM_FK = 1505662
PRINT('tagNumber=009866;area=456791')
DELETE from f_statushistory where STH_FM_FK = 1505373
PRINT('tagNumber=010029;area=456796')
DELETE from f_statushistory where STH_FM_FK = 1505573
PRINT('tagNumber=010121;area=456762')
DELETE from f_statushistory where STH_FM_FK = 1505688
PRINT('tagNumber=010268;area=456764')
DELETE from f_statushistory where STH_FM_FK = 1505857
PRINT('tagNumber=010019;area=456782')
DELETE from f_statushistory where STH_FM_FK = 1505559
PRINT('tagNumber=010108;area=456811')
DELETE from f_statushistory where STH_FM_FK = 1505664
PRINT('tagNumber=010110;area=456815')
DELETE from f_statushistory where STH_FM_FK = 1505668
PRINT('tagNumber=010091;area=456785')
DELETE from f_statushistory where STH_FM_FK = 1505641
PRINT('tagNumber=010092;area=456785')
DELETE from f_statushistory where STH_FM_FK = 1505643
PRINT('tagNumber=010204;area=456730')
DELETE from f_statushistory where STH_FM_FK = 1505791
PRINT('tagNumber=010127;area=456824')
DELETE from f_statushistory where STH_FM_FK = 1505700
PRINT('tagNumber=010093;area=456786')
DELETE from f_statushistory where STH_FM_FK = 1505645
PRINT('tagNumber=010286;area=456742')
DELETE from f_statushistory where STH_FM_FK = 1505887
PRINT('tagNumber=010285;area=456741')
DELETE from f_statushistory where STH_FM_FK = 1505885
PRINT('tagNumber=010284;area=456740')
DELETE from f_statushistory where STH_FM_FK = 1505883
PRINT('tagNumber=010124;area=456821')
DELETE from f_statushistory where STH_FM_FK = 1505694
PRINT('tagNumber=010283;area=456739')
DELETE from f_statushistory where STH_FM_FK = 1505881
PRINT('tagNumber=009790;area=456725')
DELETE from f_statushistory where STH_FM_FK = 1505291
PRINT('tagNumber=010280;area=456736')
DELETE from f_statushistory where STH_FM_FK = 1505875
PRINT('tagNumber=010282;area=456738')
DELETE from f_statushistory where STH_FM_FK = 1505879
PRINT('tagNumber=009792;area=456727')
DELETE from f_statushistory where STH_FM_FK = 1505295
PRINT('tagNumber=009791;area=456726')
DELETE from f_statushistory where STH_FM_FK = 1505293
PRINT('tagNumber=010281;area=456737')
DELETE from f_statushistory where STH_FM_FK = 1505877
PRINT('tagNumber=009865;area=456790')
DELETE from f_statushistory where STH_FM_FK = 1505371
PRINT('tagNumber=009864;area=456789')
DELETE from f_statushistory where STH_FM_FK = 1505369
PRINT('tagNumber=009863;area=456788')
DELETE from f_statushistory where STH_FM_FK = 1505367
PRINT('tagNumber=010141;area=456837')
DELETE from f_statushistory where STH_FM_FK = 1505727
commit tran
