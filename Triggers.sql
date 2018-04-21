if not exists(select * from sysdatabases where name = 'I_Progra') 
	create database [I_Progra];--si no existe, la crea
go

use I_Progra
go

create trigger TR_Grupos_Insert on dbo.Grupo for insert
as begin
	return;
end