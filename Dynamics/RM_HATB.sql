DECLARE @EMPTYDATE AS DATETIME
DECLARE @ASOFDATE AS DATETIME
 
SET @EMPTYDATE = '1900-01-01'
SET @ASOFDATE = '2016-07-31' 
 
SELECT  W.CUSTNMBR AS CUSTOMERNO ,
        W1.DOCDESCR AS DOCTYPE ,
        W.DOCNUMBR ,
        W.DOCDATE ,
        W.TRXSORCE ,
        W.GLPOSTDT AS POSTINGDATE ,
        W.DUEDATE ,
        W.AGINGBUCKET ,
        W.DOCUMENTAMT ,
        W.CURTRXAMT
FROM    ( SELECT    X.CUSTNMBR ,
                    X.RMDTYPAL ,
                    X.DOCNUMBR ,
                    X.DOCDATE ,
                    X.TRXSORCE ,
                    X.VOIDED ,
                    X.GLPOSTDT ,
                    X.DUEDATE ,
                    X.DAYSDUE ,
                    CASE WHEN X.DAYSDUE > 999 THEN ( SELECT TOP 1
                                                            RMPERDSC
                                                     FROM   dbo.RM40201
                                                     ORDER BY RMPEREND DESC
                                                   )
                         WHEN X.DAYSDUE < 0 THEN 'Not Due'
                         ELSE ISNULL(( SELECT TOP 1
                                                RMPERDSC
                                       FROM     dbo.RM40201 AG
                                       WHERE    X.DAYSDUE <= AG.RMPEREND
                                       ORDER BY RMPEREND
                                     ), '')
                    END AS AGINGBUCKET ,
                    X.VOIDPDATE ,
                    X.DOCUMENTAMT ,
                    X.APPLIEDAMT ,
                    X.WRITEOFFAMT ,
                    X.DISCTAKENAMT ,
                    X.REALGAINLOSSAMT ,
                    CASE WHEN X.RMDTYPAL < 6
                         THEN ( X.DOCUMENTAMT - X.APPLIEDAMT - X.WRITEOFFAMT - X.DISCTAKENAMT - X.REALGAINLOSSAMT )
                         ELSE ( X.DOCUMENTAMT - X.APPLIEDAMT - X.WRITEOFFAMT - X.DISCTAKENAMT - X.REALGAINLOSSAMT ) * -1
                    END AS CURTRXAMT
          FROM      ( SELECT    Z.CUSTNMBR ,
                                Z.RMDTYPAL ,
                                Z.DOCDATE ,
                                Z.DOCNUMBR ,
                                Z.ORTRXAMT AS DOCUMENTAMT ,
                                CASE WHEN RMDTYPAL < 6 THEN ISNULL(( SELECT SUM(Y.APPLDAMT)
                                                                     FROM   ( SELECT    CUSTNMBR ,
                                                                                        ApplyFromGLPostDate ,
                                                                                        GLPOSTDT ,
                                                                                        APTODCNM ,
                                                                                        APTODCTY ,
                                                                                        APFRDCNM ,
                                                                                        APFRDCTY ,
                                                                                        APPTOAMT AS APPLDAMT
                                                                              FROM      dbo.RM20201
                                                                              WHERE     POSTED = 1
                                                                                        AND APTODCTY <> 6
                                                                              UNION
                                                                              SELECT    CUSTNMBR ,
                                                                                        ApplyFromGLPostDate ,
                                                                                        GLPOSTDT ,
                                                                                        APTODCNM ,
                                                                                        APTODCTY ,
                                                                                        APFRDCNM ,
                                                                                        APFRDCTY ,
                                                                                        APPTOAMT AS APPLDAMT
                                                                              FROM      dbo.RM30201
                                                                              WHERE     APTODCTY <> 6
                                                                            ) Y
                                                                     WHERE  Y.GLPOSTDT <= @ASOFDATE
                                                                            AND Y.ApplyFromGLPostDate <= @ASOFDATE
                                                                            AND Y.ApplyFromGLPostDate <> @EMPTYDATE
                                                                            AND Y.CUSTNMBR = Z.CUSTNMBR
                                                                            AND Y.APTODCNM = Z.DOCNUMBR
                                                                            AND Y.APTODCTY = Z.RMDTYPAL
                                                                   ), 0)
                                     WHEN RMDTYPAL > 6
                                          AND RMDTYPAL <= 9
                                     THEN ISNULL(( SELECT   SUM(Y.APPLDAMT)
                                                   FROM     ( SELECT    CUSTNMBR ,
                                                                        GLPOSTDT ,
                                                                        APPTOAMT AS APPLDAMT ,
                                                                        APFRDCNM ,
                                                                        APFRDCTY ,
                                                                        APTODCNM ,
                                                                        APTODCTY ,
                                                                        ApplyToGLPostDate
                                                              FROM      dbo.RM20201
                                                              WHERE     POSTED = 1
                                                                        AND APTODCTY <> 6
                                                              UNION
                                                              SELECT    CUSTNMBR ,
                                                                        GLPOSTDT ,
                                                                        APPTOAMT ,
                                                                        APFRDCNM ,
                                                                        APFRDCTY ,
                                                                        APTODCNM ,
                                                                        APTODCTY ,
                                                                        ApplyToGLPostDate
                                                              FROM      dbo.RM30201
                                                              WHERE     APTODCTY <> 6
                                                            ) Y
                                                   WHERE    Y.GLPOSTDT <= @ASOFDATE
                                                            AND Y.ApplyToGLPostDate <= @ASOFDATE
                                                            AND Y.ApplyToGLPostDate <> @EMPTYDATE
                                                            AND Y.CUSTNMBR = Z.CUSTNMBR
                                                            AND Y.APFRDCNM = Z.DOCNUMBR
                                                            AND Y.APFRDCTY = Z.RMDTYPAL
                                                 ), 0)
                                     ELSE 0
                                END AS APPLIEDAMT ,
                                CASE WHEN RMDTYPAL < 6 THEN ISNULL(( SELECT SUM(Y.WROFAMNT)
                                                                     FROM   ( SELECT    CUSTNMBR ,
                                                                                        ApplyFromGLPostDate ,
                                                                                        GLPOSTDT ,
                                                                                        APTODCNM ,
                                                                                        APTODCTY ,
                                                                                        APFRDCNM ,
                                                                                        APFRDCTY ,
                                                                                        WROFAMNT
                                                                              FROM      dbo.RM20201
                                                                              WHERE     POSTED = 1
                                                                                        AND APTODCTY <> 6
                                                                              UNION
                                                                              SELECT    CUSTNMBR ,
                                                                                        ApplyFromGLPostDate ,
                                                                                        GLPOSTDT ,
                                                                                        APTODCNM ,
                                                                                        APTODCTY ,
                                                                                        APFRDCNM ,
                                                                                        APFRDCTY ,
                                                                                        WROFAMNT
                                                                              FROM      dbo.RM30201
                                                                              WHERE     APTODCTY <> 6
                                                                            ) Y
                                                                     WHERE  Y.GLPOSTDT <= @ASOFDATE
                                                                            AND Y.ApplyFromGLPostDate <= @ASOFDATE
                                                                            AND Y.ApplyFromGLPostDate <> @EMPTYDATE
                                                                            AND Y.CUSTNMBR = Z.CUSTNMBR
                                                                            AND Y.APTODCNM = Z.DOCNUMBR
                                                                            AND Y.APTODCTY = Z.RMDTYPAL
                                                                   ), 0)
                                     ELSE 0
                                END AS WRITEOFFAMT ,
                                CASE WHEN RMDTYPAL < 6 THEN ISNULL(( SELECT SUM(Y.DISTKNAM)
                                                                     FROM   ( SELECT    CUSTNMBR ,
                                                                                        ApplyFromGLPostDate ,
                                                                                        GLPOSTDT ,
                                                                                        APTODCNM ,
                                                                                        APTODCTY ,
                                                                                        APFRDCNM ,
                                                                                        APFRDCTY ,
                                                                                        DISTKNAM
                                                                              FROM      dbo.RM20201
                                                                              WHERE     POSTED = 1
                                                                                        AND APTODCTY <> 6
                                                                              UNION
                                                                              SELECT    CUSTNMBR ,
                                                                                        ApplyFromGLPostDate ,
                                                                                        GLPOSTDT ,
                                                                                        APTODCNM ,
                                                                                        APTODCTY ,
                                                                                        APFRDCNM ,
                                                                                        APFRDCTY ,
                                                                                        DISTKNAM
                                                                              FROM      dbo.RM30201
                                                                              WHERE     APTODCTY <> 6
                                                                            ) Y
                                                                     WHERE  Y.GLPOSTDT <= @ASOFDATE
                                                                            AND Y.ApplyFromGLPostDate <= @ASOFDATE
                                                                            AND Y.ApplyFromGLPostDate <> @EMPTYDATE
                                                                            AND Y.CUSTNMBR = Z.CUSTNMBR
                                                                            AND Y.APTODCNM = Z.DOCNUMBR
                                                                            AND Y.APTODCTY = Z.RMDTYPAL
                                                                   ), 0)
                                     ELSE 0
                                END AS DISCTAKENAMT ,
                                CASE WHEN RMDTYPAL > 6 THEN ISNULL(( SELECT SUM(Y.RLGANLOS)
                                                                     FROM   ( SELECT    CUSTNMBR ,
                                                                                        GLPOSTDT ,
                                                                                        APFRDCNM ,
                                                                                        APFRDCTY ,
                                                                                        APTODCNM ,
                                                                                        APTODCTY ,
                                                                                        ApplyToGLPostDate ,
                                                                                        RLGANLOS
                                                                              FROM      dbo.RM20201
                                                                              WHERE     POSTED = 1
                                                                                        AND APTODCTY <> 6
                                                                              UNION
                                                                              SELECT    CUSTNMBR ,
                                                                                        GLPOSTDT ,
                                                                                        APFRDCNM ,
                                                                                        APFRDCTY ,
                                                                                        APTODCNM ,
                                                                                        APTODCTY ,
                                                                                        ApplyToGLPostDate ,
                                                                                        RLGANLOS
                                                                              FROM      dbo.RM30201
                                                                              WHERE     APTODCTY <> 6
                                                                            ) Y
                                                                     WHERE  Y.GLPOSTDT <= @ASOFDATE
                                                                            AND Y.ApplyToGLPostDate <= @ASOFDATE
                                                                            AND Y.ApplyToGLPostDate <> @EMPTYDATE
                                                                            AND Y.CUSTNMBR = Z.CUSTNMBR
                                                                            AND Y.APFRDCNM = Z.DOCNUMBR
                                                                            AND Y.APFRDCTY = Z.RMDTYPAL
                                                                   ), 0)
                                     ELSE 0
                                END AS REALGAINLOSSAMT ,
                                Z.TRXSORCE ,
                                Z.VOIDED ,
                                Z.GLPOSTDT ,
                                Z.DUEDATE ,
                                DATEDIFF(dd, Z.DUEDATE, @ASOFDATE) AS DAYSDUE ,
                                Z.VOIDPDATE
                      FROM      ( SELECT    CUSTNMBR ,
                                            RMDTYPAL ,
                                            DOCDATE ,
                                            DOCNUMBR ,
                                            ORTRXAMT ,
                                            BACHNUMB ,
                                            TRXSORCE ,
                                            BCHSOURC ,
                                            DISCDATE ,
                                            VOIDSTTS AS VOIDED ,
                                            GLPOSTDT ,
                                            CASE WHEN DUEDATE = @EMPTYDATE THEN DOCDATE
                                                 ELSE [DUEDATE]
                                            END AS DUEDATE ,
                                            VOIDDATE AS VOIDPDATE
                                  FROM      dbo.RM20101
                                  UNION
                                  SELECT    CUSTNMBR ,
                                            RMDTYPAL ,
                                            DOCDATE ,
                                            DOCNUMBR ,
                                            ORTRXAMT ,
                                            BACHNUMB ,
                                            TRXSORCE ,
                                            BCHSOURC ,
                                            DISCDATE ,
                                            VOIDSTTS AS VOIDED ,
                                            GLPOSTDT ,
                                            CASE WHEN DUEDATE = @EMPTYDATE THEN DOCDATE
                                                 ELSE [DUEDATE]
                                            END AS DUEDATE ,
                                            VOIDDATE AS VOIDPDATE
                                  FROM      dbo.RM30101
                                ) Z
                      WHERE     Z.GLPOSTDT <= @ASOFDATE
                                AND Z.VOIDED = 0
                                AND Z.RMDTYPAL <> 6
                    ) X
          UNION ALL
          SELECT    X.CUSTNMBR ,
                    X.RMDTYPAL ,
                    X.DOCNUMBR ,
                    X.DOCDATE ,
                    X.TRXSORCE ,
                    X.VOIDED ,
                    X.PSTGDATE ,
                    X.DUEDATE ,
                    X.DAYSDUE ,
                    CASE WHEN X.DAYSDUE > 999 THEN ( SELECT TOP 1
                                                            RMPERDSC
                                                     FROM   dbo.RM40201
                                                     ORDER BY RMPEREND DESC
                                                   )
                         WHEN X.DAYSDUE < 0 THEN 'Not Due'
                         ELSE ISNULL(( SELECT TOP 1
                                                RMPERDSC
                                       FROM     dbo.RM40201 AG
                                       WHERE    X.DAYSDUE <= AG.RMPEREND
                                       ORDER BY RMPEREND
                                     ), '')
                    END AS AGINGBUCKET ,
                    X.VOIDPDATE ,
                    X.DOCUMENTAMT ,
                    X.APPLIEDAMT ,
                    X.WRITEOFFAMT ,
                    X.DISCTAKENAMT ,
                    X.REALGAINLOSSAMT ,
                    CASE WHEN X.RMDTYPAL < 6
                         THEN ( X.DOCUMENTAMT - X.APPLIEDAMT - X.WRITEOFFAMT - X.DISCTAKENAMT - X.REALGAINLOSSAMT )
                         ELSE ( X.DOCUMENTAMT - X.APPLIEDAMT - X.WRITEOFFAMT - X.DISCTAKENAMT - X.REALGAINLOSSAMT ) * -1
                    END AS CURTRXAMT
          FROM      ( SELECT    Z.CUSTNMBR ,
                                Z.RMDTYPAL ,
                                Z.DOCDATE ,
                                Z.DOCNUMBR ,
                                Z.ORTRXAMT AS DOCUMENTAMT ,
                                CASE WHEN RMDTYPAL < 6 THEN ISNULL(( SELECT SUM(Y.APPLDAMT)
                                                                     FROM   ( SELECT    CUSTNMBR ,
                                                                                        ApplyFromGLPostDate ,
                                                                                        GLPOSTDT ,
                                                                                        APTODCNM ,
                                                                                        APTODCTY ,
                                                                                        APFRDCNM ,
                                                                                        APFRDCTY ,
                                                                                        APPTOAMT AS APPLDAMT
                                                                              FROM      dbo.RM20201
                                                                              WHERE     POSTED = 1
                                                                                        AND APTODCTY <> 6
                                                                              UNION
                                                                              SELECT    CUSTNMBR ,
                                                                                        ApplyFromGLPostDate ,
                                                                                        GLPOSTDT ,
                                                                                        APTODCNM ,
                                                                                        APTODCTY ,
                                                                                        APFRDCNM ,
                                                                                        APFRDCTY ,
                                                                                        APPTOAMT AS APPLDAMT
                                                                              FROM      dbo.RM30201
                                                                              WHERE     APTODCTY <> 6
                                                                            ) Y
                                                                     WHERE  Y.GLPOSTDT <= @ASOFDATE
                                                                            AND Y.ApplyFromGLPostDate <= @ASOFDATE
                                                                            AND Y.ApplyFromGLPostDate <> @EMPTYDATE
                                                                            AND Y.CUSTNMBR = Z.CUSTNMBR
                                                                            AND Y.APTODCNM = Z.DOCNUMBR
                                                                            AND Y.APTODCTY = Z.RMDTYPAL
                                                                   ), 0)
                                     WHEN RMDTYPAL > 6
                                          AND RMDTYPAL <= 9
                                     THEN ISNULL(( SELECT   SUM(Y.APPLDAMT)
                                                   FROM     ( SELECT    CUSTNMBR ,
                                                                        GLPOSTDT ,
                                                                        APPTOAMT AS APPLDAMT ,
                                                                        APFRDCNM ,
                                                                        APFRDCTY ,
                                                                        APTODCNM ,
                                                                        APTODCTY ,
                                                                        ApplyToGLPostDate
                                                              FROM      dbo.RM20201
                                                              WHERE     POSTED = 1
                                                                        AND APTODCTY <> 6
                                                              UNION
                                                              SELECT    CUSTNMBR ,
                                                                        GLPOSTDT ,
                                                                        APPTOAMT ,
                                                                        APFRDCNM ,
                                                                        APFRDCTY ,
                                                                        APTODCNM ,
                                                                        APTODCTY ,
                                                                        ApplyToGLPostDate
                                                              FROM      dbo.RM30201
                                                              WHERE     APTODCTY <> 6
                                                            ) Y
                                                   WHERE    Y.GLPOSTDT <= @ASOFDATE
                                                            AND Y.ApplyToGLPostDate <= @ASOFDATE
                                                            AND Y.ApplyToGLPostDate <> @EMPTYDATE
                                                            AND Y.CUSTNMBR = Z.CUSTNMBR
                                                            AND Y.APFRDCNM = Z.DOCNUMBR
                                                            AND Y.APFRDCTY = Z.RMDTYPAL
                                                 ), 0)
                                     ELSE 0
                                END AS APPLIEDAMT ,
                                CASE WHEN RMDTYPAL < 6 THEN ISNULL(( SELECT SUM(Y.WROFAMNT)
                                                                     FROM   ( SELECT    CUSTNMBR ,
                                                                                        ApplyFromGLPostDate ,
                                                                                        GLPOSTDT ,
                                                                                        APTODCNM ,
                                                                                        APTODCTY ,
                                                                                        APFRDCNM ,
                                                                                        APFRDCTY ,
                                                                                        WROFAMNT
                                                                              FROM      dbo.RM20201
                                                                              WHERE     POSTED = 1
                                                                                        AND APTODCTY <> 6
                                                                              UNION
                                                                              SELECT    CUSTNMBR ,
                                                                                        ApplyFromGLPostDate ,
                                                                                        GLPOSTDT ,
                                                                                        APTODCNM ,
                                                                                        APTODCTY ,
                                                                                        APFRDCNM ,
                                                                                        APFRDCTY ,
                                                                                        WROFAMNT
                                                                              FROM      dbo.RM30201
                                                                              WHERE     APTODCTY <> 6
                                                                            ) Y
                                                                     WHERE  Y.GLPOSTDT <= @ASOFDATE
                                                                            AND Y.ApplyFromGLPostDate <= @ASOFDATE
                                                                            AND Y.ApplyFromGLPostDate <> @EMPTYDATE
                                                                            AND Y.CUSTNMBR = Z.CUSTNMBR
                                                                            AND Y.APTODCNM = Z.DOCNUMBR
                                                                            AND Y.APTODCTY = Z.RMDTYPAL
                                                                   ), 0)
                                     ELSE 0
                                END AS WRITEOFFAMT ,
                                CASE WHEN RMDTYPAL < 6 THEN ISNULL(( SELECT SUM(Y.DISTKNAM)
                                                                     FROM   ( SELECT    CUSTNMBR ,
                                                                                        ApplyFromGLPostDate ,
                                                                                        GLPOSTDT ,
                                                                                        APTODCNM ,
                                                                                        APTODCTY ,
                                                                                        APFRDCNM ,
                                                                                        APFRDCTY ,
                                                                                        DISTKNAM
                                                                              FROM      dbo.RM20201
                                                                              WHERE     POSTED = 1
                                                                                        AND APTODCTY <> 6
                                                                              UNION
                                                                              SELECT    CUSTNMBR ,
                                                                                        ApplyFromGLPostDate ,
                                                                                        GLPOSTDT ,
                                                                                        APTODCNM ,
                                                                                        APTODCTY ,
                                                                                        APFRDCNM ,
                                                                                        APFRDCTY ,
                                                                                        DISTKNAM
                                                                              FROM      dbo.RM30201
                                                                              WHERE     APTODCTY <> 6
                                                                            ) Y
                                                                     WHERE  Y.GLPOSTDT <= @ASOFDATE
                                                                            AND Y.ApplyFromGLPostDate <= @ASOFDATE
                                                                            AND Y.ApplyFromGLPostDate <> @EMPTYDATE
                                                                            AND Y.CUSTNMBR = Z.CUSTNMBR
                                                                            AND Y.APTODCNM = Z.DOCNUMBR
                                                                            AND Y.APTODCTY = Z.RMDTYPAL
                                                                   ), 0)
                                     ELSE 0
                                END AS DISCTAKENAMT ,
                                CASE WHEN RMDTYPAL > 6 THEN ISNULL(( SELECT SUM(Y.RLGANLOS)
                                                                     FROM   ( SELECT    CUSTNMBR ,
                                                                                        GLPOSTDT ,
                                                                                        APFRDCNM ,
                                                                                        APFRDCTY ,
                                                                                        APTODCNM ,
                                                                                        APTODCTY ,
                                                                                        ApplyToGLPostDate ,
                                                                                        RLGANLOS
                                                                              FROM      dbo.RM20201
                                                                              WHERE     POSTED = 1
                                                                                        AND APTODCTY <> 6
                                                                              UNION
                                                                              SELECT    CUSTNMBR ,
                                                                                        GLPOSTDT ,
                                                                                        APFRDCNM ,
                                                                                        APFRDCTY ,
                                                                                        APTODCNM ,
                                                                                        APTODCTY ,
                                                                                        ApplyToGLPostDate ,
                                                                                        RLGANLOS
                                                                              FROM      dbo.RM30201
                                                                              WHERE     APTODCTY <> 6
                                                                            ) Y
                                                                     WHERE  Y.GLPOSTDT <= @ASOFDATE
                                                                            AND Y.ApplyToGLPostDate <= @ASOFDATE
                                                                            AND Y.ApplyToGLPostDate <> @EMPTYDATE
                                                                            AND Y.CUSTNMBR = Z.CUSTNMBR
                                                                            AND Y.APFRDCNM = Z.DOCNUMBR
                                                                            AND Y.APFRDCTY = Z.RMDTYPAL
                                                                   ), 0)
                                     ELSE 0
                                END AS REALGAINLOSSAMT ,
                                Z.TRXSORCE ,
                                Z.VOIDED ,
                                Z.PSTGDATE ,
                                Z.DUEDATE ,
                                DATEDIFF(dd, Z.DUEDATE, @ASOFDATE) AS DAYSDUE ,
                                Z.VOIDPDATE
                      FROM      ( SELECT    CUSTNMBR ,
                                            RMDTYPAL ,
                                            DOCDATE ,
                                            DOCNUMBR ,
                                            ORTRXAMT ,
                                            BACHNUMB ,
                                            TRXSORCE ,
                                            BCHSOURC ,
                                            DISCDATE ,
                                            VOIDSTTS AS VOIDED ,
                                            GLPOSTDT AS PSTGDATE ,
                                            CASE WHEN DUEDATE = @EMPTYDATE THEN DOCDATE
                                                 ELSE [DUEDATE]
                                            END AS DUEDATE ,
                                            VOIDDATE AS VOIDPDATE
                                  FROM      dbo.RM20101
                                  UNION
                                  SELECT    CUSTNMBR ,
                                            RMDTYPAL ,
                                            DOCDATE ,
                                            DOCNUMBR ,
                                            ORTRXAMT ,
                                            BACHNUMB ,
                                            TRXSORCE ,
                                            BCHSOURC ,
                                            DISCDATE ,
                                            VOIDSTTS AS VOIDED ,
                                            GLPOSTDT ,
                                            CASE WHEN DUEDATE = @EMPTYDATE THEN DOCDATE
                                                 ELSE [DUEDATE]
                                            END AS DUEDATE ,
                                            VOIDDATE AS VOIDPDATE
                                  FROM      dbo.RM30101
                                ) Z
                      WHERE     Z.PSTGDATE <= @ASOFDATE
                                AND Z.VOIDED = 1
                                AND Z.RMDTYPAL <> 6
                                AND Z.VOIDPDATE > @ASOFDATE
                    ) X
        ) W
        INNER JOIN dbo.RM40401 W1 ON W.RMDTYPAL = W1.RMDTYPAL
WHERE   W.CURTRXAMT <> 0 ORDER BY CUSTOMERNO