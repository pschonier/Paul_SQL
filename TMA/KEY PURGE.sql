
  delete FROM [WebTma_Test].[dbo].[f_workorder]
  where left(wo_number,1) = 'K'

  begin transaction
delete from f_workordertask  
  where wotask_wo_fk in (select wo_pk from f_workorder  where left(wo_number,1) = 'K')
  rollback transaction
  delete  from f_key

delete from f_keyLock
  
  delete from f_keySerialized

  delete FROM [WebTma_Test].[dbo].[f_keyQueue]

  delete from webtma_test.dbo.f_keyHistory