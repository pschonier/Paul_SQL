SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*Delete earlier version of AA_Remove_AAComplete*/
if exists (select * from sysobjects where name = 'AA_Remove_AAComplete' and type = 'P')
drop proc AA_Remove_AAComplete
GO
/*Delete earlier version of AA_Remove_AAComplete*/

/*Start procedure AA_Remove_AAComplete*/
create  procedure AA_Remove_AAComplete
as 
/*This procedure will remove the entire Analytical Accounting product from the database - v-villaw*/
begin	
	declare @name char(500),
		@xtype char(2),
		@CmpID smallint

	declare AASYS cursor for
	select name,xtype 
		from sysobjects where
		(name like ( 'aag%') and name <> 'aagCreateSubWorkDist' and name <> 'aagIsInitialiseSubWork'
		and name <> 'aagRenumberAASubDistsALL' and name <> 'aagSubAssignUpdate' and name <> 'aagSubLedgerDistDelete'
		and name <> 'aagSubWorkCodeUpdate' and name <> 'aagSubWorkDistUpdate' and name <> 'aagSubWorkHdrUpdate')
		or  (name like ('AAG%') and name <> 'aagCreateSubWorkDist' and name <> 'aagIsInitialiseSubWork'
		and name <> 'aagRenumberAASubDistsALL' and name <> 'aagSubAssignUpdate' and name <> 'aagSubLedgerDistDelete'
		and name <> 'aagSubWorkCodeUpdate' and name <> 'aagSubWorkDistUpdate' and name <> 'aagSubWorkHdrUpdate')
		or 
		name like ('zDP_AAG%') 
		or name like ('aaActualBudgetInquiryView') 
		or name like ('AAMultilevelQueries') 
		or name like ('AATrees') 
		or name like ('AATrxDimensionCodes') 
		or name like ('AATrxDimensions') 
		or name like ('aaClosedYearTransaction') 
		or name like ('AALATAMActivateApply') 
		or name like ('AALATAMActivateApply2') 
		or name like ('AALATAMCreateGLWorkSLRealTimePost') 
		or name like ('aaMisc_Void') 
		or name like ('aaMoveGLtoHist') 
		or name like ('aaPortfolio_AAPosting') 
		or name like ('aaPortfolio_AAPostingDebit') 
		or name like ('aaPortfolio_Debitmemo') 
		or name like ('aaRemoveHistory') 
		or name like ('GL00105V')  
		or name like ('AAAccountingClasses') 
		or name like ('aaActualBudgetInquiryViewAlt') 
		or name like ('AADistributionQueries') 
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
		else if @xtype = 'TF' /*table function*/
			exec('drop function '+@name )	
		fetch next from  AASYS into @name,@xtype
	end 	
	close 	AASYS 
	deallocate AASYS

	
	print '--------------------------------------------------------------'
	select @CmpID = (select CMPANYID from DYNAMICS..SY01500 where INTERID=DB_Name())
	print 'Printer Settings...'
	delete from DYNAMICS..STN41300 where PRNTASK like '3180%' AND CMPANYID = @CmpID
	print 'Smartlist Entries...'
	delete from DYNAMICS..ASIEXP81 where ASI_Favorite_Dict_ID = 3180 AND (CMPANYID = @CmpID or CMPANYID = 0)
	delete from DYNAMICS..ASIEXP83 where ASI_Favorite_Dict_ID = 3180 or ASI_Field_Number_Dict_ID = 3180 AND CMPANYID = @CmpID
	delete from DYNAMICS..ASIEXP86 where ASI_Favorite_Dict_ID = 3180 or ASI_Field_Number_Dict_ID = 3180 AND (CMPANYID = @CmpID or CMPANYID = 0)
	delete from DYNAMICS..ASIEXP98 where ASI_Favorite_Dict_ID = 3180 AND CMPANYID = @CmpID
	delete from DYNAMICS..AAG00102 where CMPANYID = @CmpID
	print ''
	print 'Resetting the Company <' + db_name() + '> to AA Company Install Option'
	update DYNAMICS..AAG00104 set aaCompanyStatus=0 where CMPANYID=@CmpID
	print ''
	print '--------------------------------------------------------------'
	print 'Analytical Accounting removed from <' + @@SERVERNAME + '> For Company : ' + db_name()
	print '--------------------------------------------------------------'
end
GO

/*Execute the Stored Proc*/
execute AA_Remove_AAComplete
GO

/*Drop the Stored Proc*/
drop proc AA_Remove_AAComplete
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
