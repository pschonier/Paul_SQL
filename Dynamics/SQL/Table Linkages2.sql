--/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP 1000 *
--  FROM [EPCO].[dbo].[vw_AFE_Detail] afe
--  join epco.dbo.PM30200 trn on trn.DOCNUMBR = afe.docnum


select top 100 * from epco.dbo.PM00400 order by docdate desc
select top 100 voided, * from epco.dbo.PM30200 hist where hist.docnumbr = '273235' order by docdate desc
select top 100 * from epco.dbo.PM30300 order by glpostdt desc

select top 1000 * from epco.dbo.ME97705 afe --order by ME_Job_ID desc --Project (AFE) 
left join epco.dbo.pm20000 trn  on trn.VCHRNMBR = afe.ME_Document_Number_WORK
order by afe.DOCDATE desc

select top 1000 * from epco.dbo.ME97707 order by ME_Job_ID desc -- Project (AFE)
select top 1000 * from epco.dbo.ME97706 -- Project (AFE)
select top 1000 * from epco.dbo.ME97708 order by ME_Job_ID -- Project (AFE)

SELECT
    serv.NAME,
    serv.product,
    serv.provider,
    serv.data_source,
    serv.catalog,
    prin.name,
    ls_logins.uses_self_credential,
    ls_logins.remote_name
FROM
    sys.servers AS serv
    LEFT JOIN sys.linked_logins AS ls_logins
    ON serv.server_id = ls_logins.server_id
    LEFT JOIN sys.server_principals AS prin
    ON ls_logins.local_principal_id = prin.principal_id


