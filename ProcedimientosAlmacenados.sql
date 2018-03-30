
use [I Progra]
go

create procedure SPinsertarProfesor @nombre nvarchar(50) not null, @email nvarchar(50) not null, @contrase�a nvarchar(8) not null
as begin
	set nocount on;
	return insert into Profesor(nombre, email, contrase�a) values(@nombre, @email, @contrase�a);
end

create procedure SPeliminarProfesor @nombre nvarchar(50) not null, @email nvarchar(50) not null, @contrase�a nvarchar(8) not null
as begin
	set nocount on;
	declare @idProfesorAEliminar as int =  select P.id from Profesor P where P.email = @email;
	insert into Profesor(nombre, email, contrase�a) values(@nombre, @email, @contrase�a);
end