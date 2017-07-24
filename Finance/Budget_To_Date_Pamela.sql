SELECT  bud.BUDGETID ,
        bud.BUDGETAMT ,
        bud.PERIODID ,
        bud.YEAR1 ,
        GL.TRXDATE AS TransactionDate ,
        GL.JRNENTRY AS JournalEntry ,
        act.ACTNUMST AS GLAccount ,
        ac.ACTDESCR AS AccountDescription ,
        GL.ORCTRNUM AS Originating_Control_Number ,
        GL.ORMSTRNM AS Originating_Master_Name ,
        GL.DSCRIPTN AS [Description] ,
        GL.ORDOCNUM AS Originating_Document_Number ,
        GL.DEBITAMT - GL.CRDTAMNT AS [Amount] ,
        CASE ac.ACTNUMBR_2
          WHEN 1 THEN 'Houston'
          WHEN 2 THEN 'Greenville'
          WHEN 3 THEN 'Glenpool'
          WHEN 4 THEN 'Wood River'
          WHEN 5 THEN 'Hammond'
          WHEN 6 THEN 'Port Arthur'
          WHEN 7 THEN 'Arlington'
          WHEN 9 THEN 'Special'
        END AS 'Area'
FROM    GL00201 bud
        JOIN dbo.GL00100 ac ON ac.ACTINDX = bud.ACTINDX
        JOIN GL20000 GL ON GL.ACTINDX = bud.ACTINDX
        JOIN GL00105 act ON act.ACTINDX = bud.ACTINDX
WHERE   bud.BUDGETID = '2017 Budget'
        AND bud.PERIODID <= 1
        AND MONTH(GL.TRXDATE) <= 1
        AND YEAR(GL.TRXDATE) = bud.YEAR1
        AND LEFT(ACTNUMST, 2) = '82'
ORDER BY ABS(GL.DEBITAMT - GL.CRDTAMNT) ,
        GLAccount ,
        JournalEntry

 --SELECT * FROM gl00100
 --SELECT * FROM gl00200

SELECT * FROM gl00100 WHERE ACTNUMBR_1 like '825110'


--create procedure gprv_actual_vs_budget
--@year int, @month int, @budget varchar(15)
--as
 
---- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
----created May 25, 2016 by Victoria Yudin
----Flexible Solutions, Inc. 212-254-4112
----For updates see https://victoriayudin.com/
----shows monthly and YTD actuals vs.budgets w/variance
----includes unit accounts
----shows open and historical years
----uses net changes, not ending balances for balance sheet accts
---- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
 
--set nocount on
 
--select
--rtrim(an.ACTNUMST) Account,
--rtrim(m.ACTDESCR) [Account Description],
--coalesce(a.Monthly,ah.Monthly,0) [Monthly Actual],
--coalesce(b.Monthly,0) [Monthly Budget],
--coalesce(a.Monthly,ah.Monthly,0)
--  - coalesce(b.Monthly,0) [Monthly Variance],
--coalesce(a.YTD,ah.YTD,0) [YTD Actual],
--coalesce(b.YTD,0) [YTD Budget],
--coalesce(a.YTD,ah.YTD,0)
--  - coalesce(b.YTD,0) [YTD Variance]
--from GL00105 an -- account numbers
 
--left outer join --actuals from open year
--(select a.ACTNUMST,
-- sum(case when g.PERIODID = @month
--    then g.DEBITAMT - g.CRDTAMNT
--    else 0
--    end) Monthly,
-- sum(case when g.PERIODID <= @month
--    then g.DEBITAMT - g.CRDTAMNT
--    else 0
--    end) YTD
-- from GL11110 g
-- inner join GL00105 a
--    on g.ACTINDX = a.ACTINDX
-- where g.YEAR1 = @year and g.PERIODID <= @month
-- group by a.ACTNUMST) a --actuals open year
--    on an.ACTNUMST = a.ACTNUMST
 
--left outer join --actuals from historical year
--(select a.ACTNUMST,
-- sum(case when g.PERIODID = @month
--    then g.DEBITAMT - g.CRDTAMNT
--    else 0
--    end) Monthly,
-- sum(case when g.PERIODID <= @month
--    then g.DEBITAMT - g.CRDTAMNT
--    else 0
--    end) YTD
-- from GL11111 g
-- inner join GL00105 a
--    on g.ACTINDX = a.ACTINDX
-- where g.YEAR1 = @year and g.PERIODID <= @month
-- group by a.ACTNUMST) ah --actuals historical year
--    on an.ACTNUMST = ah.ACTNUMST
 
--left outer join --budgets
--(select a.ACTNUMST,
-- sum(case when b.PERIODID = @month
--    then b.BUDGETAMT
--    else 0
--    end) Monthly,
-- sum(case when b.PERIODID <=@month
--    then b.BUDGETAMT
--    else 0
--    end) YTD
-- from GL00201 b
-- inner join GL00105 a
--    on b.ACTINDX = a.ACTINDX
-- where b.BUDGETID = @budget and b.YEAR1 = @year
-- group by a.ACTNUMST) b --budgets
--    on an.ACTNUMST = b.ACTNUMST
 
--left outer join GL00100 m --account master
--on an.ACTINDX = m.ACTINDX
 
----only show rows that are not all zeros,
----if you want to see all accounts,
----remove the where clause below
--where a.Monthly <> 0
--   or a.YTD <> 0
--   or b.Monthly <> 0
--   or b.YTD <> 0
--   or ah.Monthly <> 0
--   or ah.YTD <> 0
 
--order by an.ACTNUMST
 
--set nocount off
 
--go
--grant exec on gprv_actual_vs_budget to DYNGRP




