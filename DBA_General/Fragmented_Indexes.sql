USE EPCO;
SELECT  OBJECT_NAME(i.object_id) AS TableName ,
        i.name AS TableIndexName ,
        phystat.avg_fragmentation_in_percent
FROM    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED') phystat
        INNER JOIN sys.indexes i ON i.object_id = phystat.object_id
                                    AND i.index_id = phystat.index_id
WHERE   phystat.avg_fragmentation_in_percent > 10
        AND phystat.avg_fragmentation_in_percent < 40;


SELECT  OBJECT_NAME(i.object_id) AS TableName ,
        i.name AS TableIndexName ,
        phystat.avg_fragmentation_in_percent
FROM    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED') phystat
        INNER JOIN sys.indexes i ON i.object_id = phystat.object_id
                                    AND i.index_id = phystat.index_id
WHERE   phystat.avg_fragmentation_in_percent > 10
        AND phystat.avg_fragmentation_in_percent < 40;


