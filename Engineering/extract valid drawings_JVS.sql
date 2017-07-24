use assets
DROP TABLE Jenks_State_Champions
GO
--===== Create a holding table for the file names
 CREATE TABLE Jenks_State_Champions
        (
        FileName    varchar(255),
        )
;
--===== Capture the names in the desired directory
     -- (Change "C:\Temp" to the directory of your choice)
 INSERT INTO Jenks_State_Champions
 EXEC xp_cmdshell 'dir /b /s \\fileprint-pcc\Drafting\Assets\Facilities\*.dwg'
 ;
 INSERT INTO Jenks_State_Champions
 EXEC xp_cmdshell 'dir /b /s \\fileprint-pcc\Drafting\Assets\Facilities\*.lnk'
 ;
 INSERT INTO Jenks_State_Champions
 EXEC xp_cmdshell 'dir /b /s \\fileprint-pcc\Drafting\Assets\Pipelines\*.dwg'
 ;
 INSERT INTO Jenks_State_Champions
 EXEC xp_cmdshell 'dir /b /s \\fileprint-pcc\Drafting\Assets\Pipelines\*.jpg'
 ;
 INSERT INTO Jenks_State_Champions
 EXEC xp_cmdshell 'dir /b /s \\fileprint-pcc\Drafting\Assets\Pipelines\*.lnk'
;
--===== Find the latest file using the "constant" characters
     -- in the file name and the ISO style date.
delete from Jenks_State_Champions where filename not in (SELECT filename
   FROM Jenks_State_Champions
where substring(filename,len(filename)-charindex('\',reverse(filename))-4,6) = '\Elec\' and filename not like '%\Projects\%' and filename not like '%\Old_Revisions\%' and filename not like '%\Working\%'

UNION

 SELECT filename
   FROM Jenks_State_Champions
where substring(filename,len(filename)-charindex('\',reverse(filename))-9,11) = '\MechCivil\' and filename not like '%\Projects\%' and filename not like '%\Old_Revisions\%' and filename not like '%\Working\%' 

UNION

 SELECT filename
   FROM Jenks_State_Champions
where substring(filename,len(filename)-charindex('\',reverse(filename))-3,5) = '\PID\' and filename not like '%\Projects\%' and filename not like '%\Old_Revisions\%' and filename not like '%\Working\%'

UNION

 SELECT filename
   FROM Jenks_State_Champions
where substring(filename,len(filename)-charindex('\',reverse(filename))-16,18) = '\Alignment_Sheets\' and filename not like '%\Projects\%' and filename not like '%\Old_Revisions\%' and filename not like '%\Working\%')
