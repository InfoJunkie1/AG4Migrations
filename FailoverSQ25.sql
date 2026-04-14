/*
Migration! 
Run on SQL25
*/

--wheeeeee!!!!!!!!!!!!!!!!! failover
alter availability group AGmig failover

--remove databases from AG
alter availability group AGmig
remove database AdventureWorks2019
go 

alter availability group AGmig
remove database GuardingTheKeys
go 

alter availability group AGmig
remove database PostItReplacement
go 

alter availability group AGmig
remove database PythonPractice
go 

alter availability group AGmig
remove database SignThoseSprocs
go 

--drop AG
drop availability group AGmig
