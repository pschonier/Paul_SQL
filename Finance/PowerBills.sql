SELECT a.VendorCode, a.UtilityName, a.AccountNumber, a.Location, a.MeterNumber, ps.ServiceType, a.Address, a.city, a.state, a.ZipCode, a.MainPhone, gl.GLAccount
 -- FROM [Accounting].[dbo].[PowerBillPayments] p
  FROM accounting.dbo.powerAccounts a 
  JOIN [Accounting].[dbo].[PowerGLAccounts] gl ON gl.AccountNo = a.AccountNumber
  JOIN accounting.dbo.PowerServiceTypes ps ON ps.ServiceTypeID = a.ServiceTypeID