USE [EPCO]
GO

/****** Object:  View [dbo].[vw_VoucherNumber_Scanning]    Script Date: 2/10/2015 2:53:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*where DOCNUMBR like '%268868%'*/
alter VIEW [dbo].[vw_VoucherNumber_JE]
AS
SELECT   distinct   isnull(A.VCHRNMBR, g.orctrnum) AS VoucherNumber, A.DOCTYPE, A.VENDORID, C.VENDNAME AS VendorName, A.INVOICENUMBER, A.INVOICEDATE, A.INVOICEAMT AS InvoiceAmount, D.APFRDCNM AS CheckNumber, 
                         D.DOCDATE AS CheckDate, D.APPLDAMT AS CheckAmount, B.ME_Job_ID AS AFE, NULL AS SUPPLEMENT, A.BACHNUMB AS BatchNumber, isnull(g.jrnentry, g2.jrnentry) as JRNEntry
						 			
						
FROM            (SELECT VCHRNMBR, DOCTYPE, VENDORID, DOCNUMBR AS INVOICENUMBER, DOCDATE AS INVOICEDATE, DOCAMNT AS INVOICEAMT, BACHNUMB, 'OPEN' AS STATUS, 'INVOICE' AS Expr1, 
                        CASE WHEN VOIDED = 1 THEN 'VOID' ELSE NULL END AS IsVoid
                          FROM            dbo.PM20000
                          UNION
                          SELECT        VCHRNMBR, DOCTYPE, VENDORID, DOCNUMBR AS INVOICENUMBER, DOCDATE AS INVOICEDATE, DOCAMNT AS INVOICEAMT, BACHNUMB, 'CLOSED' AS STATUS, 'INVOICE' AS Expr1
						                ,CASE WHEN VOIDED = 1 THEN 'VOID' ELSE NULL END AS IsVoid
                          FROM          dbo.PM30200 p) AS A LEFT OUTER JOIN
                             (SELECT        VENDORID, DOCDATE, VCHRNMBR, APTVCHNM, APFRDCNM, APTODCNM, APTODCDT, APPLDAMT
                               FROM            dbo.PM30300
                               GROUP BY VENDORID, DOCDATE, VCHRNMBR, APTVCHNM, APFRDCNM, APTODCNM, APPLDAMT, APTODCDT) AS D ON A.INVOICENUMBER = D.APTODCNM AND A.INVOICEDATE = D.APTODCDT AND 
                         A.VENDORID = D.VENDORID LEFT OUTER JOIN
                         dbo.PM00200 AS C ON A.VENDORID = C.VENDORID LEFT OUTER JOIN
                             (SELECT        ME_Job_ID, DOCNUMBR, DOCDATE, DOCTYPE,JRNENTRY, SQNCLINE
                               FROM            dbo.ME97705 m
                               GROUP BY ME_Job_ID, DOCNUMBR, DOCDATE, DOCTYPE, JRNENTRY,SQNCLINE) AS B ON A.VCHRNMBR = B.DOCNUMBR AND A.INVOICEDATE = B.DOCDATE
					    left outer join pm30600 p1 on d.vchrnmbr = p1.vchrnmbr and p1.doctype = a.doctype 
						left outer join GL20000 g on d.VCHRNMBR = g.ORCTRNUM and p1.DSTSQNUM = (case when g.OrigSeqNum ='0' then g.SEQNUMBR else g.origseqnum end) AND p1.DOCTYPE = g.ORTRXTYP    
						left outer join GL30000 g2 on p1.VCHRNMBR = g2.ORCTRNUM and p1.DSTSQNUM = (case when g2.OrigSeqNum ='0' then g2.SEQNUMBR else g2.origseqnum end) AND p1.DOCTYPE = g2.ORTRXTYP    
		where g2.jrnentry = 451757
GO

select top 1000 * from gl20000 g1 where g1.jrnentry = 451757
select top 1000* from pm30200 where docamnt = 4736.13
--select top 1000 (case jrnentry when '0' then 'true' else 'false' end), * from me97705 m where m.ORIGAMT = 4038.05
select top 1000 * from pm30300 where apfrmaplyamt = 4736.13
--select * from me97705 where JRNENTRY = '0'

select top 1000 * from pm30600 p where crdtamnt = 4736.13
