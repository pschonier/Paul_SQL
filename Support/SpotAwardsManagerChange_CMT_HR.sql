--change Angel to Committee spot awarder
update SpotDepartment set ManagerId = 'rdudley', ManagerName = 'unavailable' where DepartmentId = 27 and DepartmentCode = 'HR'
UPDATE SpotDepartment set ManagerId = 'astacy', ManagerName = 'Angel Stacy' where DepartmentId = 32 and DepartmentCode = 'CMT'

--change back
update SpotDepartment set ManagerId = 'astacy', ManagerName = 'Angel Stacy' where DepartmentId = 27 and DepartmentCode = 'HR'
update SpotDepartment set ManagerId = 'kmoss', ManagerName = 'Katrina Moss' where DepartmentId = 32 and DepartmentCode = 'CMT'
