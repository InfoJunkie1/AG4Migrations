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
 