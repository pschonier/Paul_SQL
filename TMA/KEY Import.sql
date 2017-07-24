
  delete FROM [WebTma_Test].[dbo].[f_workorder]
  where left(wo_number,1) = 'K'

  begin transaction
delete from f_workordertask  
  where wotask_wo_fk in (select wo_pk from f_workorder  where left(wo_number,1) = 'K')
  rollback transaction
  delete  from f_key

SELECT * FROM dbo.f_key
  
SELECT * FROM f_keySerialized s 
JOIN tempdb.dbo.keyImport k ON s.kser_serialNumber = k.serial
JOIN f_keyCabinet c ON c.kc_description = k.KeyCabinet
JOIN f_key ky ON ky.ky_pk = s.kser_ky_fk

INSERT INTO dbo.f_keySerialized
        ( kser_serialNumber ,
          kser_ky_fk ,
          kser_clnt_fk ,
          kser_inStock ,
          kser_modifiedDate ,
          kser_modifier_fk ,
          kser_createDate ,
          kser_creator_fk
        )
VALUES  ( N'' , -- kser_serialNumber - nvarchar(50)
          161134 , -- kser_ky_fk - int
          0 , -- kser_clnt_fk - int
          0 , -- kser_inStock - bit
          GETDATE() , -- kser_modifiedDate - datetime
          0 , -- kser_modifier_fk - int
          GETDATE() , -- kser_createDate - datetime
          0  -- kser_creator_fk - int
        ) (SELECT * FROM webtma.dbo.f_keySerialized)

SELECT * FROM dbo.f_keyCabinet




--**Delete Script
BEGIN TRANSACTION
		DELETE FROM dbo.f_keyQueueLog
		DELETE FROM dbo.f_keyQueue
		DELETE FROM dbo.f_keyTransaction
		DELETE from webtma_test.dbo.f_keyHistory
		DELETE from webtma_test.dbo.f_keyHolder
		DELETE from f_workordertask  WHERE wotask_wo_fk in (select wo_pk from f_workorder  where left(wo_number,1) = 'K')
		DELETE FROM [dbo].[f_workorder] WHERE left(wo_number,1) = 'K'
		DELETE FROM dbo.f_keySerialized
		DELETE FROM dbo.f_keyAdjustment

ROLLBACK TRANSACTION


UPDATE tempdb.dbo.KeyImport SET [Key Cabinet] = REPLACE([Key Cabinet], '-', ' ')