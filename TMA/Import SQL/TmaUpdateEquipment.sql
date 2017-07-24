--Check for duplicate tag numbers
select eq.fm_tagnumber from f_equipment eq inner join f_equipment e2 on eq.fm_tagNumber = e2.fm_tagNumber where eq.fm_pk <> e2.fm_pk

--Make sure we can match every piece of equipment to be updated
SELECT tagnumber, count(tagnumber) from IT..TmaEquipmentForUpdate e INNER JOIN f_equipment eq on e.tagnumber = eq.fm_tagNumber 
where e.imported = 0 group by tagnumber having count(tagnumber) <> 1

update f_equipment set fm_modelNumber = CASE LEN(e.ModelNumber) WHEN 0 THEN eq.fm_modelNumber ELSE e.ModelNumber END, 
	fm_serialNumber = CASE LEN(e.SerialNumber) WHEN 0 THEN eq.fm_serialNumber ELSE e.SerialNumber END, 
	fm_mfg_fk = ISNULL(ven.ven_pk, eq.fm_mfg_fk)
from IT..TmaEquipmentForUpdate e INNER JOIN f_equipment eq on e.tagnumber = eq.fm_tagNumber
	LEFT OUTER JOIN f_vendor ven ON ven.ven_name = e.Manufacturer -- 1010
WHERE Imported = 0

--update IT..TmaEquipmentForUpdate set imported = 1 where imported = 0
--select fm_modelNumber, fm_serialNumber, fm_mfg_fk from f_equipment where fm_tagNumber = '009489'
--select * from f_vendor where ven_pk = 323932
