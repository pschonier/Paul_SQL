declare @servername nvarchar(50)
declare loopdb cursor for

SELECT
    NAME
FROM
    master.sys.servers 
WHERE 
	master.sys.servers.product = 'Access'

open loopdb
FETCH NEXT from loopdb into @servername

WHILE @@FETCH_STATUS = 0   
BEGIN   
print rtrim(@servername)
EXEC master.dbo.sp_addlinkedserver @server = rtrim(@servername), @srvproduct=N'Access', @provider=N'Microsoft.ACE.OLEDB.12.0', @datasrc=N'\\fileprint-pcc\drafting\Assets\DrawingIndex\' + rtrim(@servername) +'.mdb'

GO

EXEC master.dbo.sp_serveroption @server=rtrim(@servername), @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=rtrim(@servername), @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=rtrim(@servername), @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=rtrim(@servername), @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=rtrim(@servername), @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=rtrim(@servername), @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=rtrim(@servername), @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=rtrim(@servername), @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=rtrim(@servername), @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=rtrim(@servername), @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=rtrim(@servername), @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=rtrim(@servername), @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=rtrim(@servername), @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

Fetch next from loopdb
END
close loopdb
deallocate loopdb


