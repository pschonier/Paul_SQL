SELECT DISTINCT ar.Area_Name, us.Asset_name, ass.Accounting_Code, us.Mnemonic, us.Latitude, us.Longitude, us.Physical_Address, us.Physical_City, us.Physical_State, us.Physical_ZIP, us.Physical_Phone , 
 us.USPS_Mailing_Address_1, us.USPS_Mailing_Address_2, us.USPS_Mailing_City, us.USPS_Mailing_State, us.USPS_Mailing_ZIP
FROM dbo.Unity_Stations us 
JOIN dbo.SYS_Asset ass ON ass.Mnemonic = us.Mnemonic-- AND ass.status = 'active'
JOIN dbo.SYS_Area ar ON ar.Area_Id = ass.Area_id

