USE Dynamics;
SELECT  S.USERID UserID ,
        S.CMPANYID CompanyID ,
        C.CMPNYNAM CompanyName ,
        S.SECURITYROLEID ,
        COALESCE(T.SECURITYTASKID, '') SecurityTaskID ,
        COALESCE(TM.SECURITYTASKNAME, '') SecurityTaskName ,
        COALESCE(TM.SECURITYTASKDESC, '') SecurityTaskDescription
FROM    SY10500 S -- security assignment user role
        LEFT OUTER JOIN SY01500 C -- company master
        ON S.CMPANYID = C.CMPANYID
        LEFT OUTER JOIN SY10600 T -- tasks in roles
        ON S.SECURITYROLEID = T.SECURITYROLEID
        LEFT OUTER JOIN SY09000 TM -- tasks master
        ON T.SECURITYTASKID = TM.SECURITYTASKID
WHERE   S.USERID IN ( 'plasiter2', 'DYNSA', 'terry', 'mary', 'rhonda', 'sa',
                      'Jean', 'tschatz', 'molly', 'meganm', 'tbaca', 'nicole',
                      'debbie' )
ORDER BY UserID;

