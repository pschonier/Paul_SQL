SELECT * FROM dbo.f_keySerialized

--393. 394

--106 - 118

--120-130

--199

DELETE FROM dbo.f_keySerialized WHERE CAST(kser_serialNumber AS INT) BETWEEN 120 AND 130


DELETE FROM dbo.f_keyQueue WHERE kqueue_kser_fk IN (SELECT s.kser_pk FROM dbo.f_keySerialized s WHERE CAST(kser_serialNumber AS INT) BETWEEN 120 AND 130)


DELETE FROM dbo.f_keyTransaction WHERE ktr_kser_fk IN (SELECT s.kser_pk FROM dbo.f_keySerialized s WHERE CAST(kser_serialNumber AS INT) BETWEEN 120 AND 130)


SELECT * FROM dbo.f_keyTransaction