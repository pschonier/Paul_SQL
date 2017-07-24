use assets
DROP TABLE Temp_Txt_File_Dir
GO
--===== Create a holding table for the file names
 CREATE TABLE Temp_Txt_File_Dir
        (
        FileName    varchar(255),
        )
;
--===== Capture the names in the desired directory
     -- (Change "C:\Temp" to the directory of your choice)
 INSERT INTO Temp_Txt_File_Dir
 EXEC xp_cmdshell 'dir /b /s \\fileprint-pcc\Drafting\Assets\DrawingIndex\*.txt'
 ;

delete from Temp_Txt_File_Dir where FileName is null or right(filename,7) = 'dir.txt'

select * from Temp_Txt_File_Dir