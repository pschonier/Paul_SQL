SELECT sysa.[Asset_Name]
      ,vlv.[Milepost]
      ,vlv.[Tag_Number]
      ,vlv.[Shape].STX As Longitude
         ,vlv.[Shape].STY As Latitude
         ,'Manual' As Control
  FROM [Assets].[dbo].[VALVE] vlv
  INNER JOIN [dbo].[SYS_Asset] sysa ON
sysa.[Asset_Id] = vlv.[Assets_Id]
where vlv.[Valve_Control_CL] = 1 or vlv.[Valve_Control_CL] is null
UNION
SELECT sysa.[Asset_Name]
      ,vlv.[Milepost]
      ,vlv.[Tag_Number]
      ,vlv.[Shape].STX As Longitude
         ,vlv.[Shape].STY As Latitude
         ,'Remote' As Control
  FROM [Assets].[dbo].[VALVE] vlv
  INNER JOIN [dbo].[SYS_Asset] sysa ON
sysa.[Asset_Id] = vlv.[Assets_Id]
where vlv.[Valve_Control_CL] > 1

--\\gisapp-pcc\sqlexpress
--latitude is y and longitude is x in f_building