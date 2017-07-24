declare @pathname varchar(100)
declare @servername nvarchar(50)
declare loopdb cursor for


SELECT
    NAME
FROM
     [DBSVR-PCC].master.sys.servers dms
WHERE 
	 dms.product = 'Access' 

open loopdb
FETCH NEXT from loopdb into @servername



WHILE @@FETCH_STATUS = 0   
BEGIN   

EXEC master.dbo.sp_dropserver @server=@servername, @droplogins='droplogins'



Fetch next from loopdb into @servername
END
close loopdb
deallocate loopdb
GO

