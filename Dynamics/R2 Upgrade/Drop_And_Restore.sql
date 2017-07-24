USE [master]
drop database dynamics
drop database epco
drop database epsco

RESTORE DATABASE [Dynamics] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\Backup_Restore\DynamicsFull14.bak' 
WITH  FILE = 1,  
MOVE N'DYNAMICS_Data' TO N'C:\Program Files\Microsoft SQL Server\MSSQL11.PAUL_LOCAL\MSSQL\DATA\Dynamics.MDF',  
MOVE N'DYNAMICS_Log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL11.PAUL_LOCAL\MSSQL\DATA\Dynamics.LDF',  NOUNLOAD,  STATS = 5

GO

RESTORE DATABASE [EPCO] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\Backup_Restore\EPCOFull14.bak'
 WITH  FILE = 1,  
 MOVE N'EPCO_Data' TO N'C:\Program Files\Microsoft SQL Server\MSSQL11.PAUL_LOCAL\MSSQL\DATA\EPCO.MDF',  
 MOVE N'EPCO_Log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL11.PAUL_LOCAL\MSSQL\DATA\EPCO.LDF',  NOUNLOAD,  STATS = 5

GO

RESTORE DATABASE [EPSCO] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\Backup_Restore\EPSCOFull14.bak' 
WITH  FILE = 1,  
MOVE N'EPSCO_Data' TO N'C:\Program Files\Microsoft SQL Server\MSSQL11.PAUL_LOCAL\MSSQL\DATA\EPSCO.MDF',  
MOVE N'EPSCO_Log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL11.PAUL_LOCAL\MSSQL\DATA\EPSCO.LDF',  NOUNLOAD,  STATS = 5

GO



