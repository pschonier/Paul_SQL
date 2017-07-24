declare @pathname varchar(100)
declare @servername nvarchar(50)
declare loopdb cursor for


SELECT
    NAME
FROM
     [DEVSVR-PCC].master.sys.servers dms
WHERE 
	 dms.product = 'Access' and dms.name not in (select name from master.sys.servers)

open loopdb
FETCH NEXT from loopdb into @servername



WHILE @@FETCH_STATUS = 0   
BEGIN   
select @pathname = '\\fileprint-pcc\drafting\Assets\DrawingIndex\'+ rtrim(@servername) +'.mdb'
EXEC master.dbo.sp_addlinkedserver @server = @servername, @srvproduct=N'Access', @provider=N'Microsoft.ACE.OLEDB.12.0', @datasrc=@pathname
EXEC master.dbo.sp_serveroption @server= @servername, @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@servername, @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=@servername, @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@servername, @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@servername, @optname=N'rpc', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@servername, @optname=N'rpc out', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@servername, @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@servername, @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=@servername, @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=@servername, @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@servername, @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=@servername, @optname=N'use remote collation', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=@servername, @optname=N'remote proc transaction promotion', @optvalue=N'true'


Fetch next from loopdb into @servername
END
close loopdb
deallocate loopdb
GO

