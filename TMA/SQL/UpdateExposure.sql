

  BEGIN TRANSACTION
  UPDATE webtma.dbo.f_area SET fu_phoneMain = ex.Vaulted,
  fu_mailStop = ex.exposure
  FROM webtma.dbo.f_area a
  JOIN webtma.dbo.f_building b ON b.fb_pk = a.fu_fb_fk
  JOIN tempdb.dbo.BlockValveExposure ex ON (ex.Latitude = b.fb_y_coordinate AND ex.Longitude = b.fb_x_coordinate) AND ex.[Valve Description] = a.fu_description
  WHERE ex.Exposure IS NOT NULL OR ex.Vaulted IS NOT NULL
  ROLLBACK TRANSACTION



