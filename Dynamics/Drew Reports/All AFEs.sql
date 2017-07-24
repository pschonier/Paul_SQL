
SELECT ME_Job_ID AS 'AFE', ME_Actual_Start_Date AS 'Start Date', ME_Actual_End_Date AS EstCompletion, CAST(ME_Orig_Est_Cost_MATE AS MONEY) AS 'EST_Cost'
, CAST(ME_Actual_Cost_Material AS MONEY) AS 'ActualCost', ME_Work_Scope AS 'ProjectDescription', MEUserDefined3 AS LocationSegment, MEuserdefined1 AS LocName, *
  FROM [EPCO].[dbo].[ME97708] WHERE ISNUMERIC(me_job_id) = 1 AND ME_Job_Status = 1 AND ME_Actual_End_Date > '1995-1-1'
  ORDER BY MEuserdefined3


  SELECT * FROM gl00100 WHERE ACTNUMBR_3 = 351