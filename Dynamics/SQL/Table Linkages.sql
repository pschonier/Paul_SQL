/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP 1000 *
--  FROM [EPCO].[dbo].[PM10000] trn -- unposted transactions
--  right outer join [EPCO].[dbo].[SY00500] btch on trn.BACHNUMB = btch.bachnumb -- open batches
--  --join [EPCO].[dbo].[PM10100] pos on pos.VCHRNMBR = trn.VCHNUMWK

select top 1000 * from epco.dbo.pm10000 trn --unposted
select top 1000 * from epco.dbo.pm20000 --posted, but no check or EFT generated yet
select top 1000 * from epco.dbo.PM30200 -- historical and paid
select top 1000 * from epco.dbo.ME97705 order by ME_Job_ID desc --Project (AFE) 
select top 1000 * from epco.dbo.ME97707 order by ME_Job_ID desc -- Project (AFE)
select top 1000 * from epco.dbo.ME97706 -- Project (AFE)
select top 1000 * from epco.dbo.ME97708 order by ME_Job_ID -- Project (AFE)
select top 1000 * from [EPCO].[dbo].[GL00105] -- Account Number String concatenated 
select top 1000 * from [EPCO].[dbo].[GL00100] -- All GL Accounts w/ Description

select top 1000 * from epco.dbo.pm20000 trn
join epco.dbo.ME97705 afe on afe.DOCNUMBR = trn.VCHRNMBR

