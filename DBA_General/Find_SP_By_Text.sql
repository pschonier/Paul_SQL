SELECT Object_definition(object_id), *
FROM   sys.procedures
WHERE  Object_definition(object_id) LIKE '%email%'


