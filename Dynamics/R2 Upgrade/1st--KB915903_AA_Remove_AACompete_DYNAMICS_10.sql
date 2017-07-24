SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*Delete earlier version of AA_Remove_AAComplete*/
if exists (select * from sysobjects where name = 'AA_Remove_AAComplete_DYNAMICS' and type = 'P')
drop proc AA_Remove_AAComplete_DYNAMICS
GO

/*Start procedure AA_Remove_AAComplete_DYNAMICS*/
create  procedure AA_Remove_AAComplete_DYNAMICS
as 
/*This procedure will remove the entire Analytical Accounting product from the database - v-villaw*/
begin	
	declare @name char(500),
		@xtype char(2),
		@CmpID smallint

	declare AASYS cursor for
	select name,xtype 
		from sysobjects where
		(name like ( 'aag%')or  name like ('AAG%')or 
		name like ('zDP_AAG%'))
		order by name 
	open AASYS 
	fetch next from  AASYS into @name,@xtype
	while @@fetch_status = 0
	begin
		if @xtype = 'U' /*Table*/ 
			exec('drop table '+@name)
		else if @xtype = 'P' /*Procedure*/ 
			exec('drop procedure '+@name )
		else if @xtype = 'FN' /*Procedure*/
			exec('drop function '+@name )
		else if @xtype = 'V' /*View*/
			exec('drop view '+@name )
		else if @xtype = 'TR' /*trigger*/
			exec('drop trigger '+@name )		
		fetch next from  AASYS into @name,@xtype
	end 	
	close 	AASYS 
	deallocate AASYS
	
	print '----------------------------------------------------------'
	print 'Analytical Accounting removed from <' + @@SERVERNAME + '>'
	print '----------------------------------------------------------'
end
GO
/*Execute the Stored Proc*/
execute AA_Remove_AAComplete_DYNAMICS
GO
/*Drop the Stored Proc*/
drop proc AA_Remove_AAComplete_DYNAMICS
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
