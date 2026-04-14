/*
Migration! 
Run on SQL19
*/

--confirm currently in async
Select replica_server_name
	, availability_mode_desc
From sys.availability_replicas

--set to sync commit
alter availability group AGmig
modify replica on N'SQL19'
with (availability_mode = synchronous_commit)

alter availability group AGmig
modify replica on N'SQL25'
with (availability_mode = synchronous_commit)

--confirm now in sync
Select replica_server_name
	, availability_mode_desc
From sys.availability_replicas

--confirm all databases synchronized
select ag.name AS AGname
	, db.name AS DatabaseName
	, ar.replica_server_name AS Replica
	, drs.synchronization_state_desc AS SyncState
	, drs.synchronization_health_desc AS SyncHeath
from sys.availability_groups AS ag
join sys.availability_replicas AS ar
	on ar.group_id = ag.group_id
join sys.dm_hadr_database_replica_states AS drs
	on drs.replica_id = ar.replica_id
join sys.databases AS db
	on db.database_id = drs.database_id
 