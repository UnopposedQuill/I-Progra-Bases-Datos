use master
if not exists(select * from sysdatabases where name = 'I_Progra') 
	create database [I_Progra];--si no existe, la crea
go

use [I_Progra]
go
if object_id('SPeliminarProfesor','P') is not null drop procedure SPeliminarProfesor;
go
create procedure SPeliminarProfesor @email nvarchar(50), @contraseña nvarchar(8)
as begin
	set nocount on;
	begin transaction
		begin try
			update dbo.Profesor
			set habilitado = 0
			where email = @email and contraseña = @contraseña;--asegurarme que la contraseña sí sea la misma
			commit
			return (select P.id from Profesor P where @email = P.email);
		end try
		begin catch
			rollback
			return -50001;
		end catch
	
end
go

if object_id('SPinsertarProfesor','P') is not null drop procedure SPinsertarProfesor;
go
create procedure SPinsertarProfesor @nombre nvarchar(50), @apellido nvarchar(50), @email nvarchar(50), @contraseña nvarchar(8)
as begin
	set nocount on;
	insert into Profesor(nombre, apellido, email, contraseña) values(@nombre, @apellido, @email, @contraseña);
end
go

if object_id('SPinsertarEstudiante','P') is not null drop procedure SPinsertarEstudiante;
go
create procedure SPinsertarEstudiante @nombre nvarchar(50), @apellido nvarchar(50), @email nvarchar(50), @carnet nvarchar(15), @telefono nvarchar(8)
as begin
	set nocount on;
	insert into Estudiante(nombre, apellido, email, carnet, telefono) values (@nombre, @apellido, @email, @carnet, @telefono);
end
go

if object_id('SPeliminarEstudiante','P') is not null drop procedure SPeliminarEstudiante;
go
create procedure SPeliminarEstudiante @email nvarchar(50), @carnet nvarchar(15)
as begin
	set nocount on;
	begin transaction
		begin try
			update dbo.Estudiante
			set habilitado = 0
			where email = @email and carnet = @carnet;--asegurarme que la contraseña sí sea la misma
			commit
			return (select E.id from Estudiante E where @email = E.email);
		end try
		begin catch
			rollback
			return -50001;
		end catch
end
go

if object_id('SPiniciarSesion','P') is not null drop procedure SPiniciarSesion;
go
/*
Este procedimiento almacenado recibe un email y una contraseña. Verifica si existe una combinación que 
coincida con ambos.
Si no existe una combinación, entonces retorna -1
Si existe una combinación dentro de los profesores, retorna 1
Si existe una combinación dentro de los estudiantes, retorna 2
*/
create procedure SPiniciarSesion @email nvarchar(50), @contraseña nvarchar(15)
as begin
	set nocount on;
	if exists(select id from Profesor P where P.email = @email and P.contraseña = @contraseña)
		return 1;
	else if exists(select id from Estudiante E where E.email = @email and E.carnet = @contraseña)
		return 2;
	return -1
end
go

if object_id('SPmodificarDatosLogin','P') is not null drop procedure SPmodificarDatosLogin;
go
/*
Este procedimiento almacenado recibe un email y una contraseña. Verifica si existe una combinación que 
coincida con ambos.
Si no existe una combinación, entonces retorna -1
Si existe una combinación dentro de los profesores, retorna 1
Si existe una combinación dentro de los estudiantes, retorna 2
*/
create procedure SPmodificarDatosLogin @email nvarchar(50), @contraseña nvarchar(15), @nuevoEmail nvarchar(50), @nuevaContraseña nvarchar(15)
as begin
	set nocount on;
	if exists(select id from Profesor P where P.email = @email and P.contraseña = @contraseña)
		begin
		begin transaction
			begin try
				update dbo.Profesor
				set email = @nuevoEmail, contraseña = @nuevaContraseña
				where email = @email and contraseña = @contraseña
				commit;
			end try
			begin catch
				rollback;
				return -50001;
			end catch;
		end
	else if exists(select id from Estudiante E where E.email = @email and E.carnet = @contraseña)
		return 2;
	return -1
end
go

if object_id('SPinsertarPeriodo','P') is not null drop procedure SPinsertarPeriodo;
go
create procedure SPinsertarPeriodo @fechaInicio date, @fechaFinalizacion date
as begin
	set nocount on;
	insert into Periodo(fechaInicio, fechaFinalizacion) values (@fechaInicio, @fechaFinalizacion);
end
go

if object_id('SPeliminarPeriodo','P') is not null drop procedure SPeliminarPeriodo;
go
create procedure SPeliminarPeriodo @fechaInicio date, @fechaFinalizacion date
as begin
	set nocount on;
	begin transaction
		begin try
			update dbo.Periodo
			set habilitado = 0
			where @fechaInicio = fechaInicio and @fechaFinalizacion = fechaFinalizacion;
			commit
			return (select P.id from Periodo P where @fechaInicio = fechaInicio and @fechaFinalizacion = fechaFinalizacion);
		end try
		begin catch
			rollback
			return -50001;
		end catch
end
go

if object_id('SPinsertarGrupo','P') is not null drop procedure SPinsertarGrupo;
go
create procedure SPinsertarGrupo @nombre nvarchar(50), @codigoGrupo nvarchar(10), @idProfesor int, @idPeriodo int
as begin
	set nocount on;
	insert into Grupo(nombre, codigoGrupo, FKProfesor, FKPeriodo) values (@nombre, @codigoGrupo, @idProfesor, @idPeriodo);
end
go

if object_id('SPeliminarGrupo','P') is not null drop procedure SPeliminarGrupo;
go
create procedure SPeliminarGrupo @codigoGrupo nvarchar(10)
as begin
	set nocount on;
	declare @idGrupo int = (select G.id from Grupo G where G.codigoGrupo = @codigoGrupo);
	begin transaction
		begin try
			update dbo.Grupo
			set habilitado = 0
			where @idGrupo = id;
			update dbo.GrupoXEstudiante
			set habilitado = 0
			where GrupoXEstudiante.FKGrupo = @idGrupo;
			update dbo.GrupoXRubro
			set habilitado = 0
			where GrupoXRubro.FKGrupo = @idGrupo;
			update dbo.Evaluacion
			set habilitado = 0
			where Evaluacion.FKGrupoXRubro = (select GxR.id from GrupoXRubro GxR where GxR.FKGrupo = @idGrupo);
			update dbo.EvaluacionXEstudiante
			set habilitado = 0
			where EvaluacionXEstudiante.FKGrupoXEstudiante = (select GxE.id from GrupoXEstudiante GxE where GxE.FKGrupo = @idGrupo);
			commit
			return @idGrupo
		end try
		begin catch
			rollback
			return -50001;
		end catch
end
go

if object_id('SPinsertarEstadoEstudiante','P') is not null drop procedure SPinsertarEstadoEstudiante;
go
create procedure SPinsertarEstadoEstudiante @nombre nvarchar(20)
as begin
	set nocount on;
	insert into EstadoEstudiante(nombre) values (@nombre)
end
go

if object_id('SPeliminarEstadoEstudiante','P') is not null drop procedure SPeliminarEstadoEstudiante;
go
create procedure SPeliminarEstadoEstudiante @nombre nvarchar(20)
as begin
	set nocount on;
	begin transaction
		begin try
			update dbo.EstadoEstudiante
			set habilitado = 0
			where nombre = @nombre
			commit
			return (select E.id from EstadoEstudiante E where @nombre = nombre and habilitado = 0);
		end try
		begin catch
			rollback
			return -50001;
		end catch
end
go

--este SP se encarga de unir la información de un estudiante con un grupo determinado, hace que "el estudiante empiece a estar en el curso"
if object_id('SPinsertarGrupoXEstudiante','P') is not null drop procedure SPinsertarGrupoXEstudiante;
go
create procedure SPinsertarGrupoXEstudiante @idEstudiante int, @idGrupo int, @idEstadoEstudiante int, @notaAcumulada float = -1
as begin
	set nocount on;
	insert into GrupoXEstudiante(FKEstudiante, FKGrupo, FKEstadoEstudiante, notaAcumulada) values (@idEstudiante, @idGrupo, @idEstadoEstudiante, @notaAcumulada);
end
go

--SP No usado-------------------------------------------------------------------------------------------
if object_id('SPeliminarGrupoXEstudiante','P') is not null drop procedure SPeliminarGrupoXEstudiante;
go
create procedure SPeliminarGrupoXEstudiante @codigoEstudiante int, @codigoGrupo int
as begin
	set nocount on;
	begin transaction
		update dbo.GrupoXEstudiante
		set habilitado = 0
		where @codigoGrupo = GrupoXEstudiante.FKGrupo and @codigoEstudiante = GrupoXEstudiante.FKEstudiante;
	commit
end
go
--SP No usado-------------------------------------------------------------------------------------------

if object_id('SPinsertarRubro','P') is not null drop procedure SPinsertarRubro;
go
create procedure SPinsertarRubro @nombreRubro varchar(20)
as begin
	set nocount on;
	insert into Rubro(nombre) values (@nombreRubro);
end
go

if object_id('SPeliminarRubro','P') is not null drop procedure SPeliminarRubro;
go
create procedure SPeliminarRubro @nombreRubro nvarchar(20)
as begin
	set nocount on;
	begin transaction
		update dbo.Rubro
		set habilitado = 0
		where @nombreRubro = nombre;
	commit
end
go

if object_id('SPinsertarGrupoXRubro','P') is not null drop procedure SPinsertarGrupoXRubro;
go
create procedure SPinsertarGrupoXRubro @idRubro int, @idGrupo int, @valorPorcentual float, @cantidad int, @esFijo bit
as begin
	set nocount on;
	insert into GrupoXRubro(FKRubro, FKGrupo, valorPorcentual, contador, esFijo) values (@idRubro, @idGrupo, @valorPorcentual, @cantidad, @esFijo);
end
go

--SP No usado-------------------------------------------------------------------------------------------
if object_id('SPeliminarGrupoXRubro','P') is not null drop procedure SPeliminarGrupoXRubro;
go
create procedure SPeliminarGrupoXRubro @idRubro int, @idGrupo int
as begin
	set nocount on;
	begin transaction
		update dbo.GrupoXRubro
		set habilitado = 0
		where @idGrupo = FKGrupo and @idRubro = FKRubro and not exists(select * from Evaluacion E where E.FKGrupoXRubro = id and habilitado = 1);
	commit
end
go
--SP No usado-------------------------------------------------------------------------------------------

if object_id('SPinsertarEvaluacion','P') is not null drop procedure SPinsertarEvaluacion;
go
create procedure SPinsertarEvaluacion @idGrupoXRubro int, @nombre nvarchar(20), @fecha datetime, @valorPorcentual float, @descripcion nvarchar(100)
as begin
	set nocount on;
	insert into Evaluacion(FKGrupoXRubro, nombre, fecha, valorPorcentual, descripcion) values (@idGrupoXRubro, @nombre, @fecha, @valorPorcentual, @descripcion);
end
go

if object_id('SPeliminarEvaluacion','P') is not null drop procedure SPeliminarEvaluacion;
go
create procedure SPeliminarEvaluacion @idEvaluacion int
as begin
	set nocount on;
	begin transaction
		update dbo.Evaluacion
		set habilitado = 0
		where @idEvaluacion = id and not exists(select * from EvaluacionXEstudiante ExE where ExE.FKEvaluacion = id and ExE.habilitado = 1);
	commit
end
go

if object_id('SPinsertarEvaluacionXEstudiante','P') is not null drop procedure SPinsertarEvaluacionXEstudiante;
go
create procedure SPinsertarEvaluacionXEstudiante @idEvaluacion int, @idGrupoXEstudiante int, @nota float
as begin
	set nocount on;
	insert into EvaluacionXEstudiante(FKEvaluacion, FKGrupoXEstudiante, nota) values (@idEvaluacion, @idGrupoXEstudiante, @nota);
end
go

if object_id('SPeliminarEvaluacionXEstudiante','P') is not null drop procedure SPeliminarEvaluacionXEstudiante;
go
create procedure SPeliminarEvaluacionXEstudiante @idEvaluacion int, @idGrupoXEstudiante int
as begin
	set nocount on;
	begin transaction
		update dbo.EvaluacionXEstudiante
		set habilitado = 0
		where @idEvaluacion = FKEvaluacion and @idGrupoXEstudiante = FKGrupoXEstudiante;
	commit
end
go

--prototipo------------------------------------------------------------------------------------
if object_id('SPcalcularPonderadoGrupoXEstudiante','P') is not null drop procedure SPcalcularPonderadoGrupoXEstudiante;
go
create procedure SPcalcularPonderadoGrupoXEstudiante @carnetEstudiante nvarchar(15), @codigoGrupo nvarchar(10)
as begin
	set nocount on;
	/*
	update dbo.GrupoXEstudiante
	set notaAcumulada = sum((select ExE.nota*Ev.valorPorcentual from dbo.EvaluacionXEstudiante ExE
							inner join dbo.Evaluacion Ev on ExE.FKEvaluacion = Ev.id
							inner join dbo.GrupoXEstudiante GxE on ExE.FKGrupoXEstudiante = GxE.id
							inner join dbo.Estudiante E on GxE.FKEstudiante = E.id
							inner join dbo.Grupo G on GxE.FKGrupo = G.id
							where E.carnet = @carnetEstudiante and G.codigoGrupo = @codigoGrupo
							))
	where isnull((select E.id from Estudiante E where E.carnet = @carnetEstudiante),0) = FKEstudiante and @codigoGrupo = FKGrupo;
	*/
end
go
--prototipo------------------------------------------------------------------------------------