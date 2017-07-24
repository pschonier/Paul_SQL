USE [Assets]

SELECT     
						dbo.FAC_Pipe.Facility_Id, dbo.SYS_Asset.Asset_Name, dbo.FAC_Pipe.Series, dbo.FAC_Pipe.Station_Begin, dbo.FAC_Pipe.Station_End
					  ,(dbo.FAC_Pipe.Station_End - dbo.FAC_Pipe.Station_Begin) + isnull(riser_length, 0) as 'Length'
					  , round((.1781*power(((Outside_Diameter-(2*Wall_Thickness))/12),2)*(pi()*((dbo.FAC_Pipe.Station_End - dbo.FAC_Pipe.Station_Begin) + isnull(riser_length, 0))))/4 , 5) as Barrels 
                      ,dbo.GCL_Manufacturer.Manufacturer_Name, dbo.CL_Pipe_Dimension.Outside_Diameter, dbo.CL_Pipe_Dimension.Wall_Thickness, dbo.CL_Pipe_Grade.Grade, 
                       dbo.CL_Pipe_Seam_Process.Alternate_Name as Seam_Process, isnull(cast(install_date as varchar),dbo.FAC_Pipe.Year_built) as InstallDate
					  , REPLACE(REPLACE(REPLACE(REPLACE(cast(isnull(dbo.FAC_Pipe.Comments, '')  as nvarchar(max)), CHAR(13) + CHAR(10), ' ... '), 
						CHAR(10) + CHAR(13), ' ... '), CHAR(13), ' '), CHAR(10), ' ... ') as Comments
					  , dbo.SYS_Status.Status_Name, isnull(fac_pipe.Riser_Length, 0) as Riser_Length
					
FROM         dbo.GCL_Status RIGHT OUTER JOIN
                      dbo.FAC_Pipe ON dbo.GCL_Status.Status_Id = dbo.FAC_Pipe.Status_Id LEFT OUTER JOIN
                      dbo.CL_Pipe_Grade ON dbo.FAC_Pipe.Grade_Id = dbo.CL_Pipe_Grade.Grade_Id LEFT OUTER JOIN
                      dbo.GCL_Manufacturer ON dbo.FAC_Pipe.Manufacturer_Id = dbo.GCL_Manufacturer.Manufacturer_Id LEFT OUTER JOIN
                      dbo.CL_Pipe_Seam_Process ON dbo.FAC_Pipe.Seam_Process_Id = dbo.CL_Pipe_Seam_Process.Seam_Process_Id LEFT OUTER JOIN
                      dbo.CL_Pipe_Dimension ON dbo.FAC_Pipe.Dimension_Id = dbo.CL_Pipe_Dimension.Dimension_Id LEFT OUTER JOIN
                      dbo.CL_Series on dbo.FAC_Pipe.Series = dbo.CL_Series.Series LEFT OUTER JOIN
                      dbo.SYS_Asset ON dbo.CL_Series.Asset_Id = dbo.SYS_Asset.Asset_Id LEFT OUTER JOIN 
					  dbo.SYS_Status on CL_Series.Status_Id = SYS_Status.Status_Id
					  where CL_Series.Status_Id in (3,4)

ORDER BY dbo.FAC_Pipe.Series, dbo.FAC_Pipe.Station_Begin



--select * from FAC_Pipe

