DECLARE @QuizTakerName varchar(250)
DECLARE @QuizQuestionGroupName varchar(50)
DECLARE @QuestionText varchar(500)
DECLARE @PresortedAnswerIds varchar(50)
DECLARE @PreviousQuizTakerName varchar(250) = 'First Pass'
DECLARE @delimiter varchar(10) = ','
DECLARE @AnswerId int
DECLARE @AnswerText varchar(500)
DECLARE @QuestionID int
DECLARE @AnswerChar INT
--DECLARE @QuestionNum INT

DECLARE cQuestions CURSOR FOR 
       SELECT DISTINCT qt.QuizTakerName, qqg.groupName, qq.QuestionText, qtq.PresortedAnswerIds, qtq.QuizQuestionId FROM QuizTaker qt
       INNER JOIN QuizTakerQuestion qtq ON qt.QuizTakerId = qtq.QuizTakerID
       INNER JOIN QuizQuestion qq ON qtq.QuizQuestionID = qq.QuizQuestionId
       INNER JOIN QuizQuestionGroup qqg ON qq.QuizQuestionGroupID = qqg.QuizQuestionGroupID
       WHERE IsPaperTest = 1
       ORDER BY qt.QuizTakerName

--SET @PreviousQuizTakerName = 'First Pass'
OPEN cQuestions
--SET @QuestionNum = 1
FETCH NEXT FROM cQuestions INTO @QuizTakerName, @QuizQuestionGroupName, @QuestionText, @PresortedAnswerIds, @QuestionID
WHILE @@FETCH_STATUS = 0 BEGIN

       IF @QuizTakerName <> @PreviousQuizTakerName BEGIN
              -- Create test header per Joshua's instructions
              PRINT @QuizTakerName
                        SET @PreviousQuizTakerName = @QuizTakerName
       END

       --Print the question
       PRINT  @QuestionText --CAST(@QuestionNum AS NVARCHAR) +') '+ @QuestionText

       --Getting the answers is tougher. We have to parse the presorted answers
       DECLARE @xml AS XML = CAST(('<X>'+REPLACE(@PresortedAnswerIds,@delimiter ,'</X><X>')+'</X>') AS XML)
       DECLARE cAnswers CURSOR FOR 
       SELECT C.value('.', 'varchar(10)') AS value
       FROM @xml.nodes('X') as X(C)
       OPEN cAnswers

          SET @AnswerChar = 6
		  
       FETCH NEXT FROM cAnswers INTO @AnswerId
       WHILE @@FETCH_STATUS = 0 BEGIN
             select  @AnswerText = AnswerText from QuizAnswer where QuizAnswerId = @AnswerId 
                      print CHAR(9) + CHAR(@AnswerChar) + '.' + CHAR(9) + @AnswerText
                     FETCH NEXT FROM cAnswers INTO @AnswerId
                     SET @AnswerChar = @AnswerChar + 1
       END  
       CLOSE cAnswers
       DEALLOCATE cAnswers
	 
          FETCH NEXT FROM cQuestions INTO @QuizTakerName, @QuizQuestionGroupName, @QuestionText, @PresortedAnswerIds, @QuestionID
		  --  SET @QuestionNum = @QuestionNum + 1
END

CLOSE cQuestions
DEALLOCATE cQuestions
