/****** Script for SelectTopNRows command from SSMS  ******/
SELECT * INTO dbo.asiexp86_backup FROM [Dynamics].[dbo].[ASIEXP86]
DELETE FROM [Dynamics].[dbo].[ASIEXP86]

SELECT * INTO dbo.sy07240_backup FROM dynamics.dbo.sy07240 
DELETE FROM dynamics.dbo.sy07240 

Create trigger ctrig_SY07240_ii on [DYNAMICS].[dbo].[SY07240] instead of insert as
begin

insert [DYNAMICS].[dbo].[SY07240] (ListDictID, ListID, ViewID, CmdParentDictID, CmdParentFormID, CmdParentCmdID, CmdSequence, CmdDictID, CmdFormID, CmdID, Priority, ButtonSize, CmdCaption, Visible)
 select ListDictID, ListID, ViewID, CmdParentDictID, CmdParentFormID, CmdParentCmdID, isnull(CmdSequence, 1), CmdDictID, CmdFormID, CmdID, Priority, ButtonSize, CmdCaption, Visible 
 from inserted

end


--Drop when done
--DROP TRIGGER [ctrig_SY07240_ii] ON [DYNAMICS].[dbo].[SY07240]

                     

		  