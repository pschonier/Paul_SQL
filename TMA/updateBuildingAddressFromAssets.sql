

        BEGIN TRAN;
        update WebTMA.dbo.f_building set
                 fb_address1 =left(s.Physical_Address, 35),
                  fb_city =left(s.Physical_City, 25) ,
                  fb_emergencyInformation = RTRIM(s.Physical_Phone) ,
                  fb_zip =  RTRIM(s.Physical_ZIP)
              
                FROM     WebTMA.dbo.f_building b
                JOIN  Assets.dbo.Unity_Stations s ON   s.Mnemonic = b.fb_code;
        ROLLBACK TRAN;


		SELECT * FROM webtma.dbo.f_building