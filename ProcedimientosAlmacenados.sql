
use [I Progra]
go

create procedure SPinsertarProfesor @nombre nvarchar(50) not null, @email nvarchar(50) not null, @contraseņa nvarchar(8) not null
as begin
	set nocount on;
	return insert into Profesor(nombre, email, contraseņa) values(@nombre, @email, @contraseņa);
end

create procedure SPeliminarProfesor @nombre nvarchar(50) not null, @email nvarchar(50) not null, @contraseņa nvarchar(8) not null
as begin
	set nocount on;
	declare @idProfesorAEliminar as int =  select P.id from Profesor P where P.email = @email;
	insert into Profesor(nombre, email, contraseņa) values(@nombre, @email, @contraseņa);
end