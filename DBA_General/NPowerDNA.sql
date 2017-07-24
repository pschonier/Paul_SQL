--SELECT *s
--  FROM [NPowerDNA].[dbo].[Keycards] k
--JOIN NPowerDNA.dbo.Personnel p ON p.UserID = k.UserID



SELECT p.TenantID ,
       p.UserID ,
       p.LastName ,
       p.FirstName ,
       p.Company ,
       p.Address1 ,
       p.Address2 ,
       p.City ,
       p.State ,
       p.ZIP ,
       p.Department ,
       p.HomePhone ,
       p.WorkPhone ,
       p.Location ,
       p.EMailAddress ,
       p.Title ,
       p.Site ,
       p.Country ,
       p.Other ,
       p.Flags ,
       p.DLNumber ,
       p.SSN ,
       p.EmpID ,
       p.DOH ,
       p.DNAText1 ,
       p.DNAText2 ,
       p.DNAText3 ,
       p.DNAVal1 ,
       p.DNAVal2 ,
       p.DNAVal3 ,
       p.MiddleName ,
       p.PersonnelType ,
       p.DNAText4 ,
       p.DNAText5 ,
       p.DNAText6 ,
       p.DNAText7 ,
       p.DNAText8 ,
       p.DNAUSN ,
       p.BadgeTemplateID ,
       p.AssignedVisitor ,
       p.DNAText9 ,
       p.DNAText10 ,
       p.DNAText11 ,
       p.DNAText12 ,
       p.DNAText13 ,
       p.DNAText14 ,
       p.DNAText15 ,
       p.DNAText16 ,
       p.CreateDate ,
       p.LastChangeDate ,
       p.LastBadgeTemplate ,
       p.Sponsor ,
       p.Token ,
       p.ReasonForVisit ,
       p.Gender ,
       k.KeycardID ,
       k.TenantID ,
       k.KeyNumber ,
       k.Site ,
       k.HotStamp ,
       k.FacilityCode ,
       k.IssueCode ,
       k.PIN ,
       k.Cardtype ,
       k.StartDate ,
       k.StopDate ,
       k.UserID ,
       k.APBMode ,
       k.ADAMode ,
       k.DisabledReason ,
       k.DisabledDescription ,
       k.UseCount ,
       k.VacationDate ,
       k.UpgradeDate ,
       k.VacationDuration ,
       k.UpgradeDuration ,
       k.Active ,
       k.FreePass ,
       k.VIP ,
       k.DisableAPB ,
       k.DisableUseCount ,
       k.PinExempt ,
       k.AssetGroup ,
       k.TriggerCode ,
       k.Flags ,
       k.RightsMask ,
       k.FCMode ,
       k.HostMacro ,
       k.PIN2 ,
       k.ThreatManager ,
       k.LastUsedAddress ,
       k.LastUsedTime ,
       k.DNAUSN ,
       k.EscortCode ,
       k.AutoFlags ,
       k.DNAReserved1 ,
       k.DNAReserved2 ,
       k.CreateDate ,
       k.LastChangeDate ,
       k.LastAccessDate ,
       k.LastAccessEvent ,
       k.LastAccessAddr ,
       k.LastPrintDate ,
       k.CardNumber ,
       k.Token ,
       k.ASSAFacCode ,
       k.ASSACredentialFormat ,
       k.AgencyCode ,
       k.SystemCode FROM NPowerDNA.dbo.Personnel p 
LEFT OUTER JOIN NPowerDNA.dbo.Keycards k ON k.UserID = p.UserID
ORDER BY p.LastName