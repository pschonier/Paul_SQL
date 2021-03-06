
 SELECT a.Description ,
        ACCT_AFE AS AFE ,
        at.ServiceYear ,
        ServiceMonth ,
        at.Descrip AS AssetDescription ,
        t.Description AS TranDescription ,
		a.Description AS SubDescription,
        DeprRate ,
        at.AMNT ,
        s.DeprRate * at.AMNT AS DeprAmnt ,
        *
 FROM   [Explorer].[dbo].[PrimaryAccounts] a
        LEFT OUTER JOIN Explorer.dbo.SubAccounts s ON s.PRID = a.PRID
        LEFT OUTER JOIN Explorer.dbo.Assets at ON at.ACCT_PR = s.PRID
                                                  AND at.ACCT_SUB = s.SubID
        LEFT OUTER JOIN [Explorer].[dbo].[TransactionCodes] t ON t.TranID = at.TranID
 WHERE  at.ServiceYear * 100 + at.ServiceMonth >= 5001
        AND ISNUMERIC(at.ServiceYear) = 1
        AND ISNUMERIC(at.ServiceMonth) = 1
 ORDER BY s.DeprRate * at.AMNT DESC, at.EntryTS DESC;