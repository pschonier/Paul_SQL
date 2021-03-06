/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [AFENum]
      ,[GLAccount]
      ,[AccountDescription]
      ,[AcctCategory]
      ,[JournalEntry]
      ,[GLPOSTDT]
      ,[TrnAmt]
      ,[REFRENCE]
      ,[VCHRNMBR]
      ,[DOCNUMBR]
      ,[BACHNUMB]
      ,[TRXSORCE]
      ,[ORCTRNUM]
      ,[ORMSTRNM]
      ,[ORDOCNUM]
      ,[DSCRIPTN]
      ,[ME_Originating_Mstr_Name]
  FROM [EPCO].[dbo].[vw_AFE_Journal_Template_Rhonda] t
  --join gl00105 g on g.ACTNUMST = t.GLAccount
  --join gl00100 g2 on g2.ACTINDX = g.ACTINDX
  --join gl00102 a on a.ACCATNUM = g2.ACCATNUM
  where GLPOSTDT < '2015-4-1'
  and left(glaccount,2) in ('82', '86','87' )


  select * from gl20000 g where g.DEBITAMT - g.CRDTAMNT = 337.35

    select * from pm30200 g where g.DOCAMNT = 337.35


	select * from ME97705 where TRXAMNT = 337.35