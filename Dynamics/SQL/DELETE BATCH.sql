USE EPCO
--SELECT * FROM [EPCO].[dbo].[SY00500]
--UPDATE [EPCO].[dbo].[SY00500] SET bchsttus = 0
--SELECT * FROM EPCO.dbo.PM00400 where CNTRLNUM  = '00000000000247841'

--select * from Dynamics.dbo.ACTIVITY

--select * from dynamics.dbo.SY00800

--select * from epco.dbo.gl10000

delete from pm10100 where vchrnmbr in (select DOCNUMBR from pm10000 where BACHNUMB IN ('123115 PDL-38') )    

delete from PM00400 where CNTRLNUM in (select DOCNUMBR from pm10000 where BACHNUMB IN ('123115 PDL-38')  )   --for payables only

delete from PM00400 where CNTRLNUM in (select DOCNUMBR from GL10000 where BACHNUMB IN ('123115 PDL-38')  )   -- for JEs

delete from dynamics.dbo.sy00800 where bachnumb IN ('123115 PDL-38')    

   

delete from epco.dbo.gl10000 where bachnumb IN ('123115 PDL-38')    

delete from epco.dbo.gl20000 where ORDOCNUM IN ('123115 PDL-38') 


delete from epco.dbo.gl10001 where bachnumb IN ('123115 PDL-38')    

delete from pm20000 where BACHNUMB IN ('123115 PDL-38')    

delete from pm10000 where  BACHNUMB IN ('123115 PDL-38')    

DELETE FROM pm30200 WHERE DOCNUMBR IN ('123115 PDL-38')  


delete from [EPCO].[dbo].[SY00500] where bachnumb IN ('123115 PDL-38') 

