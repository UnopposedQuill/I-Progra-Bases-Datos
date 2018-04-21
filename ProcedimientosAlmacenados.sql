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
	begin try
		update dbo.Profesor
		set habilitado = 0
		where email = @email and contraseña = @contraseña;--asegurarme que la contraseña sí sea la misma
		if(@@ROWCOUNT > 0) return (select id from Profesor where @email = email);
		else return -50001;
	end try
	begin catch
		return -50002;
	end catch
end
go

if object_id('SPinsertarProfesor','P') is not null drop procedure SPinsertarProfesor;
go
create procedure SPinsertarProfesor @nombre nvarchar(50), @apellido nvarchar(50), @email nvarchar(50), @contraseña nvarchar(8)
as begin
	set nocount on;
	begin try
		insert into Profesor(nombre, apellido, email, contraseña) values(@nombre, @apellido, @email, @contraseña);
		return @@identity;
	end try
	begin catch
		return -50001;
	end catch
end
go

if object_id('SPinsertarEstudiante','P') is not null drop procedure SPinsertarEstudiante;
go
create procedure SPinsertarEstudiante @nombre nvarchar(50), @apellido nvarchar(50), @email nvarchar(50), @carnet nvarchar(15), @telefono nvarchar(8)
as begin
	set nocount on;
	begin try
		insert into Estudiante(nombre, apellido, email, carnet, telefono) values (@nombre, @apellido, @email, @carnet, @telefono);
		return @@identity;
	end try
	begin catch
		return -50001;
	end catch
end
go

if object_id('SPeliminarEstudiante','P') is not null drop procedure SPeliminarEstudiante;
go
create procedure SPeliminarEstudiante @email nvarchar(50), @carnet nvarchar(15)
as begin
	set nocount on;
	begin try
		update dbo.Estudiante
		set habilitado = 0
		where email = @email and carnet = @carnet;--asegurarme que la contraseña sí sea la misma
		if(@@ROWCOUNT > 0) return (select E.id from Estudiante E where @email = E.email);
		else return -50001;
	end try
	begin catch
		return -50002;
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
	return -50001
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
				return (select id from Profesor P where P.email = @email)
			end try
			begin catch
				rollback;
				return -50001;
			end catch;
		end
	else if exists(select id from Estudiante E where E.email = @email and E.carnet = @contraseña)
		begin
		begin transaction
			begin try
				update dbo.Estudiante
				set email = @nuevoEmail
				where email = @email
				commit;
				return (select id from Estudiante E where E.email = @email)
			end try
			begin catch
				rollback;
				return -50002;
			end catch;
		end
	return -50003;
end
go

if object_id('SPinsertarPeriodo','P') is not null drop procedure SPinsertarPeriodo;
go
create procedure SPinsertarPeriodo @fechaInicio date, @fechaFinalizacion date
as begin
	set nocount on;
	begin try
		insert into Periodo(fechaInicio, fechaFinalizacion) values (@fechaInicio, @fechaFinalizacion);
		return @@identity
	end try
	begin catch
		return -50001;
	end catch
end
go

if object_id('SPeliminarPeriodo','P') is not null drop procedure SPeliminarPeriodo;
go
create procedure SPeliminarPeriodo @fechaInicio date, @fechaFinalizacion date
as begin
	set nocount on;
	begin try
		update dbo.Periodo
		set habilitado = 0
		where @fechaInicio = fechaInicio and @fechaFinalizacion = fechaFinalizacion;
		if(@@ROWCOUNT > 0) return (select P.id from Periodo P where @fechaInicio = fechaInicio and @fechaFinalizacion = fechaFinalizacion);
		else return -50001;
	end try
	begin catch
		return -50002;
	end catch
end
go

if object_id('SPinsertarGrupo','P') is not null drop procedure SPinsertarGrupo;
go
create procedure SPinsertarGrupo @nombre nvarchar(50), @codigoGrupo nvarchar(10), @idProfesor int, @idPeriodo int
as begin
	set nocount on;
	begin try
		insert into Grupo(nombre, codigoGrupo, FKProfesor, FKPeriodo) values (@nombre, @codigoGrupo, @idProfesor, @idPeriodo);
		return @@identity;
	end try
	begin catch
		return -50001;
	end catch
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
	begin try
		insert into EstadoEstudiante(nombre) values (@nombre)
		return @@identity
	end try
	begin catch
		return -50001;
	end catch
end
go

if object_id('SPeliminarEstadoEstudiante','P') is not null drop procedure SPeliminarEstadoEstudiante;
go
create procedure SPeliminarEstadoEstudiante @nombre nvarchar(20)
as begin
	set nocount on;
	begin try
		update dbo.EstadoEstudiante
		set habilitado = 0
		where nombre = @nombre
		if(@@ROWCOUNT > 0) return (select E.id from EstadoEstudiante E where @nombre = nombre);
		else return -50001;
	end try
	begin catch
		return -50002;
	end catch
end
go

--este SP se encarga de unir la información de un estudiante con un grupo determinado, hace que "el estudiante empiece a estar en el curso"
if object_id('SPinsertarGrupoXEstudiante','P') is not null drop procedure SPinsertarGrupoXEstudiante;
go
create procedure SPinsertarGrupoXEstudiante @idEstudiante int, @idGrupo int, @idEstadoEstudiante int, @notaAcumulada float = -1
as begin
	set nocount on;
	begin try
		insert into GrupoXEstudiante(FKEstudiante, FKGrupo, FKEstadoEstudiante, notaAcumulada) values (@idEstudiante, @idGrupo, @idEstadoEstudiante, @notaAcumulada);
		return @@identity;
	end try
	begin catch
		return -50001;
	end catch
end
go

if object_id('SPeliminarGrupoXEstudiante','P') is not null drop procedure SPeliminarGrupoXEstudiante;
go
create procedure SPeliminarGrupoXEstudiante @codigoEstudiante int, @codigoGrupo int
as begin
	set nocount on;
	begin try
		update dbo.GrupoXEstudiante
		set habilitado = 0
		where @codigoGrupo = GrupoXEstudiante.FKGrupo and @codigoEstudiante = GrupoXEstudiante.FKEstudiante;
		if(@@ROWCOUNT > 0) return (select GxE.id from GrupoXEstudiante GxE where @codigoGrupo = GxE.FKGrupo and @codigoEstudiante = GxE.FKEstudiante);
		else return -50001;
	end try
	begin catch
		return -50002;
	end catch
end
go

if object_id('SPinsertarRubro','P') is not null drop procedure SPinsertarRubro;
go
create procedure SPinsertarRubro @nombreRubro varchar(20)
as begin
	set nocount on;
	begin try
		insert into Rubro(nombre) values (@nombreRubro);
		return @@identity
	end try
	begin catch
		return -50001;
	end catch
end
go

if object_id('SPeliminarRubro','P') is not null drop procedure SPeliminarRubro;
go
create procedure SPeliminarRubro @nombreRubro nvarchar(20)
as begin
	set nocount on;
	begin try
		update dbo.Rubro
		set habilitado = 0
		where @nombreRubro = nombre;
		if(@@ROWCOUNT > 0) return (select R.id from Rubro R where R.nombre = @nombreRubro);
		else return -50001;
	end try
	begin catch
		return -50002;
	end catch
end
go

if object_id('SPinsertarGrupoXRubro','P') is not null drop procedure SPinsertarGrupoXRubro;
go
create procedure SPinsertarGrupoXRubro @idRubro int, @idGrupo int, @valorPorcentual float, @cantidad int, @esFijo bit
as begin
	set nocount on;
	begin try
		insert into GrupoXRubro(FKRubro, FKGrupo, valorPorcentual, contador, esFijo) values (@idRubro, @idGrupo, @valorPorcentual, @cantidad, @esFijo);
		return @@identity
	end try
	begin catch
		return -50001;
	end catch
end
go

if object_id('SPeliminarGrupoXRubro','P') is not null drop procedure SPeliminarGrupoXRubro;
go
create procedure SPeliminarGrupoXRubro @idRubro int, @idGrupo int
as begin
	set nocount on;
	begin try
		update dbo.GrupoXRubro
		set habilitado = 0
		where @idGrupo = FKGrupo and @idRubro = FKRubro and not exists(select * from Evaluacion E where E.FKGrupoXRubro = id and habilitado = 1);
		if(@@ROWCOUNT > 0) return (select GxR.id from GrupoXRubro GxR where @idGrupo = FKGrupo and @idRubro = FKRubro)
		else return -50001;
	end try
	begin catch
		return -50002;
	end catch
end
go

if object_id('SPinsertarEvaluacion','P') is not null drop procedure SPinsertarEvaluacion;
go
create procedure SPinsertarEvaluacion @idGrupoXRubro int, @nombre nvarchar(20), @fecha datetime, @valorPorcentual float, @descripcion nvarchar(100)
as begin
	set nocount on;
	begin transaction
		begin try
			update dbo.GrupoXRubro
			set contador = contador + 1
			where dbo.GrupoXRubro.id = @idGrupoXRubro;
			if(select esFijo from dbo.GrupoXRubro where id = @idGrupoXRubro) = 1--si es fijo, se coloca el valor porcentual de entrada
				insert into Evaluacion(FKGrupoXRubro, nombre, fecha, valorPorcentual, descripcion) values (@idGrupoXRubro, @nombre, @fecha, @valorPorcentual, @descripcion);
			else--sino, entonces tiene que dividirse equitativamente entre la cantidad actual de ese tipo de evaluaciones
				insert into Evaluacion(FKGrupoXRubro, nombre, fecha, valorPorcentual, descripcion) values (@idGrupoXRubro, @nombre, @fecha, (select valorPorcentual from GrupoXRubro where id = @idGrupoXRubro)/(select contador from GrupoXRubro where id = @idGrupoXRubro), @descripcion);
			commit
			return @@identity
		end try
		begin catch
			rollback;
			return -50001;
		end catch
end
go

if object_id('SPeliminarEvaluacion','P') is not null drop procedure SPeliminarEvaluacion;
go
create procedure SPeliminarEvaluacion @idEvaluacion int
as begin
	set nocount on;
	begin try
		update dbo.Evaluacion
		set habilitado = 0
		where @idEvaluacion = id and not exists(select * from EvaluacionXEstudiante ExE where ExE.FKEvaluacion = id and ExE.habilitado = 1);
		if(@@ROWCOUNT > 0) return @idEvaluacion
		else return -50001;
	end try
	begin catch
		return -50002;
	end catch
end
go

if object_id('SPinsertarEvaluacionXEstudiante','P') is not null drop procedure SPinsertarEvaluacionXEstudiante;
go
create procedure SPinsertarEvaluacionXEstudiante @idEvaluacion int, @idGrupoXEstudiante int, @nota float
as begin
	set nocount on;
	begin transaction
		begin try
			insert into EvaluacionXEstudiante(FKEvaluacion, FKGrupoXEstudiante, nota) values (@idEvaluacion, @idGrupoXEstudiante, @nota);
			update dbo.GrupoXEstudiante
			set notaAcumulada = notaAcumulada+@nota*(select valorPorcentual from dbo.Evaluacion where id = @idEvaluacion)
			where id = @idGrupoXEstudiante;
			commit
			return @@identity
		end try
		begin catch
			rollback;
			return -50001;
		end catch
end
go

if object_id('SPeliminarEvaluacionXEstudiante','P') is not null drop procedure SPeliminarEvaluacionXEstudiante;
go
create procedure SPeliminarEvaluacionXEstudiante @idEvaluacion int, @idGrupoXEstudiante int
as begin
	set nocount on;
	begin try
		update dbo.EvaluacionXEstudiante
		set habilitado = 0
		where @idEvaluacion = FKEvaluacion and @idGrupoXEstudiante = FKGrupoXEstudiante;
		if(@@ROWCOUNT > 0) return @idEvaluacion
		else return -50001;
	end try
	begin catch
		return -50002;
	end catch
end
go

--prototipos-
--(fueron sustituidos por mejoras en los procedimientos de inserción de evaluacion y evaluacionxestudiante)-------------
/*
if object_id('SPcalcularPonderadoGrupoXEstudiante','P') is not null drop procedure SPcalcularPonderadoGrupoXEstudiante;
go
create procedure SPcalcularPonderadoGrupoXEstudiante @carnetEstudiante nvarchar(15), @codigoGrupo nvarchar(10)
as begin
	set nocount on;

	update dbo.GrupoXEstudiante
	set notaAcumulada = sum((select ExE.nota*Ev.valorPorcentual from dbo.EvaluacionXEstudiante ExE
							inner join dbo.Evaluacion Ev on ExE.FKEvaluacion = Ev.id
							inner join dbo.GrupoXEstudiante GxE on ExE.FKGrupoXEstudiante = GxE.id
							inner join dbo.Estudiante E on GxE.FKEstudiante = E.id
							inner join dbo.Grupo G on GxE.FKGrupo = G.id
							where E.carnet = @carnetEstudiante and G.codigoGrupo = @codigoGrupo
							))
	where isnull((select E.id from Estudiante E where E.carnet = @carnetEstudiante),0) = FKEstudiante and @codigoGrupo = FKGrupo;

end
go

if object_id('SPcalcularPonderados','P') is not null drop procedure SPcalcularPonderados;
go
create procedure SPcalcularPonderados @carnetEstudiante nvarchar(15), @codigoGrupo nvarchar(10)
as begin
	set nocount on;
	update dbo.GrupoXEstudiante
	set notaAcumulada = sum((select ExE.nota*Ev.valorPorcentual from dbo.EvaluacionXEstudiante ExE
							inner join dbo.Evaluacion Ev on ExE.FKEvaluacion = Ev.id
							inner join dbo.GrupoXEstudiante GxE on ExE.FKGrupoXEstudiante = GxE.id
							inner join dbo.Estudiante E on GxE.FKEstudiante = E.id
							inner join dbo.Grupo G on GxE.FKGrupo = G.id
							where E.carnet = @carnetEstudiante and G.codigoGrupo = @codigoGrupo
							))
	where isnull((select E.id from Estudiante E where E.carnet = @carnetEstudiante),0) = FKEstudiante and @codigoGrupo = FKGrupo;
end
go
*/
--prototipos------------------------------------------------------------------------------------