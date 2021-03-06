use assets
declare @pathname varchar(100)


drop table TempTableDesc

create table TempTableDesc (DrawingNo varchar(255), FileLoc varchar(255), FileNam varchar(75), RevNo varchar(50), SheetNo varchar(50), Title1 varchar(255), Title2 varchar(255),
						  Title3 varchar(255), Title4 varchar(255))

declare loopdb cursor for
SELECT
    FileName
FROM
     assets.dbo.Temp_Txt_File_Dir dms


open loopdb
FETCH NEXT from loopdb into @pathname

WHILE @@FETCH_STATUS = 0   
BEGIN   
    bulk insert TempTableDesc from @pathname
	WITH (FIELDTERMINATOR = '\t',
	      ROWTERMINATOR = '\n')
Fetch next from loopdb into @pathname
END
close loopdb
deallocate loopdb
GO




--drop table Temp_Txt_File_Dir



--