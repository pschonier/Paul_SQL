Update [WebTMA].[dbo].[f_group] 
Set grp_tagnumber = 'INS-'+grp_tagNumber
  FROM [WebTMA].[dbo].[f_group] 
  where left(grp_tagNumber,3) != 'INS'

Update [WebTMA].[dbo].[f_group] 
Set grp_description = 'INS-'+rtrim(ltrim(grp_description))
FROM [WebTMA].[dbo].[f_group] 
where left(ltrim(grp_description),3) != 'INS'



