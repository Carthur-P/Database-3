use Cars

--Part 1 (Task 1)
	SELECT 
	 [Current LSN],
	 [Transaction ID],
	 [Operation],
	  [Transaction Name],
	 [CONTEXT],
	 [AllocUnitName],
	 [Page ID],
	 [Slot ID],
	 [Begin Time],
	 [End Time],
	 [Number of Locks],
	 [Lock Information]
	FROM sys.fn_dblog(NULL,NULL)
	WHERE [Transaction Name]='SplitPage' 
	GO

-- Part 1 (Task 3)
	DBCC CheckDB();
	go

--Part 2 (Task 1)
delete from dbo.employee where emp_id = 'PTC11962M'
select * from Cars.dbo.employee

USE [master]
GO
BACKUP LOG [Cars] TO  DISK = N'/var/opt/mssql/data/Cars_LogBackup_2019-11-13_21-55-24.bak' WITH NOFORMAT, NOINIT,  NAME = N'Cars_LogBackup_2019-11-13_21-55-24', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY ,  STATS = 5
RESTORE DATABASE [Cars_Restored] FROM  DISK = N'/var/opt/mssql/data/Cars.bak' WITH  FILE = 1,  MOVE N'Cars' TO N'/var/opt/mssql/data/Cars_Restored.mdf',  MOVE N'Cars_log' TO N'/var/opt/mssql/data/Cars_Restored.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [Cars_Restored] FROM  DISK = N'/var/opt/mssql/data/Cars.bak' WITH  FILE = 3,  NOUNLOAD,  STATS = 5
GO

USE Cars
GO
INSERT INTO Cars.dbo.employee
SELECT ca.emp_id, ca.fname, ca.minit, ca.lname, ca.job_id, ca.job_lvl, ca.pub_id, ca.hire_date FROM Cars_Restored.dbo.employee ca
left join Cars.dbo.employee c
on ca.emp_id = c.emp_id
where c.emp_id is null  
DBCC CHECKTABLE('dbo.employee')
select * from Cars.dbo.employee

--Part 2 (Task 2)
USE Cars
GO
drop table Cars.dbo.employee
SELECT * INTO Cars.dbo.employee
FROM Cars_Restored.dbo.employee
select * from Cars.dbo.employee