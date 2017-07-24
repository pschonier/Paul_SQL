SELECT BudgetID, rtrim(gl.ACTNUMBR_1) + '-' + rtrim(gl.ACTNUMBR_2) + '-' + rtrim(gl.ACTNUMBR_3) + '-' + rtrim(gl.ACTNUMBR_4) + '-' + rtrim(gl.ACTNUMBR_5) Account
, PeriodID, DATENAME(month,gl.PERIODDT) AS [Month], *
FROM dbo.GL00201 gl
WHERE gl.PERIODDT BETWEEN '2015-1-1' AND '2016-1-1'