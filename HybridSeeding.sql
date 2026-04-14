/************************
Hybrid seeding method
************************/

--Step 1: Set seeding mode to manual on primary
alter availability group AGmig
modify replica on N'SQL19'
with (seeding_mode = manual)
go

--ensure secondary configured for manual seeding
alter availability group AGmig
modify replica on N'SQL25'
with (seeding_mode = manual)
go

--confirm
select ar.replica_server_name
	, ar.seeding_mode_desc
	, ar.availability_mode_desc
	, ar.failover_mode_desc
from sys.availability_replicas AS ar

--Step 2: Grant create any database on secondary
alter availability group AGmig
grant create any database

--Step 3: Backup database on primary

--Step 4: Restore database on secondary
USE [master]
RESTORE DATABASE [AdventureWorks2019] 
FROM  DISK = N'C:\SQLbackups\AdventureWorks2019_full.bak' 
WITH  NoRecovery,
	FILE = 1,  MOVE N'AdventureWorks2017' TO N'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\AdventureWorks2019.mdf',  
	MOVE N'AdventureWorks2017_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\AdventureWorks2019_log.ldf',  
	NOUNLOAD,  REPLACE,  STATS = 5
GO

--confirm restoring
select name, state_desc
from sys.databases
where name = 'AdventureWorks2019'

--Step 5: Take backup log on primary and restore to secondary norecovery

--Step 6: Join database to AG on PRIMARY
alter availability group AGmig
add database AdventureWorks2019

--Step 7: alter seeding mode to automatic
alter availability group AGmig
modify replica on 'SQL19'
with (seeding_mode = Automatic)

--Step 8: Join database to AG on SECONDARY
alter database AdventureWorks2019
set hadr availability group = AGmig

