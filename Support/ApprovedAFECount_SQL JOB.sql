declare @counter int
with query as ( SELECT finalID FROM AuthorityRequestFinals arf
       INNER JOIN AuthorityRequests ar ON arf.AuthorityRequestID = ar.AuthorityRequestID
WHERE ApprovedDAte >= DateAdd(d, -2, GETDATE()) AND arf.SupplementNumber = 0 	
)
select @counter = count(*) from query

IF @counter > 0
BEGIN
SELECT 'Rows exist, proceed to e-mail step'
END
ELSE
BEGIN
    RAISERROR('No rows exist, quit job', 16, 1)
END