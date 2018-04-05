
if OBJECT_ID('I_Progra', 'D') is null
	create database [I_Progra];
go
use [I_Progra]
go

if object_id('SPeliminarProfesor','P') is not null drop procedure SPeliminarProfesor;
go
create procedure SPeliminarProfesor @email nvarchar(50) not null, @contrase�a nvarchar(8) not null
as begin
	set nocount on;
	begin transaction
		update dbo.Profesor 
		set habilitado = 0
		where email = @email and contrase�a = @contrase�a;--asegurarme que la contrase�a s� sea la misma
	commit
end
go

/*
declare @idProfesorAInsertar int;--una variable temporal que
	select @idProfesorAInsertar = P.id from Profesor P where P.email = @email;--contendr�a un supuesto profesor, es para evitar repetidos (mismo email = ya exist�a)
	if OBJECT_ID(@idProfesorAInsertar) is null throw 51000, 'El profesor ya exist�a previamente', 1;--ya exist�a, as� que lanza una excepci�n
insert into Profesor(nombre, email, contrase�a) values(@nombre, @email, @contrase�a);
*/

if object_id('SPinsertarProfesor','P') is not null drop procedure SPinsertarProfesor;
go
create procedure SPinsertarProfesor @nombre nvarchar(50) not null, @email nvarchar(50) not null, @contrase�a nvarchar(8) not null
as begin
	set nocount on;
	insert into Profesor(nombre, email, contrase�a) values(@nombre, @email, @contrase�a);
end
go

if object_id('SPinsertarEstudiante','P') is not null drop procedure SPinsertarEstudiante;
go
create procedure SPinsertarEstudiante @nombre nvarchar(50) not null, @email nvarchar(50) not null, @contrase�a nvarchar(8) not null
as begin
	set nocount on;
	insert into Profesor(nombre, email, contrase�a) values(@nombre, @email, @contrase�a);
end
go

