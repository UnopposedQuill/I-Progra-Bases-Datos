
if OBJECT_ID('I_Progra', 'D') is null
	create database [I_Progra];
go
use [I_Progra]
go

if object_id('SPeliminarProfesor','P') is not null drop procedure SPeliminarProfesor;
go
create procedure SPeliminarProfesor @email nvarchar(50) not null, @contraseña nvarchar(8) not null
as begin
	set nocount on;
	begin transaction
		update dbo.Profesor 
		set habilitado = 0
		where email = @email and contraseña = @contraseña;--asegurarme que la contraseña sí sea la misma
	commit
end
go

/*
declare @idProfesorAInsertar int;--una variable temporal que
	select @idProfesorAInsertar = P.id from Profesor P where P.email = @email;--contendría un supuesto profesor, es para evitar repetidos (mismo email = ya existía)
	if OBJECT_ID(@idProfesorAInsertar) is null throw 51000, 'El profesor ya existía previamente', 1;--ya existía, así que lanza una excepción
insert into Profesor(nombre, email, contraseña) values(@nombre, @email, @contraseña);
*/

if object_id('SPinsertarProfesor','P') is not null drop procedure SPinsertarProfesor;
go
create procedure SPinsertarProfesor @nombre nvarchar(50) not null, @email nvarchar(50) not null, @contraseña nvarchar(8) not null
as begin
	set nocount on;
	insert into Profesor(nombre, email, contraseña) values(@nombre, @email, @contraseña);
end
go

if object_id('SPinsertarEstudiante','P') is not null drop procedure SPinsertarEstudiante;
go
create procedure SPinsertarEstudiante @nombre nvarchar(50) not null, @email nvarchar(50) not null, @contraseña nvarchar(8) not null
as begin
	set nocount on;
	insert into Profesor(nombre, email, contraseña) values(@nombre, @email, @contraseña);
end
go

