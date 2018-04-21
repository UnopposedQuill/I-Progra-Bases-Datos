use master
if exists(select * from sysdatabases where name = 'I_Progra')--si existe, la borra y luego la crea de nuevo
begin
	drop database [I_Progra];
end
create database [I_Progra]
go

use [I_Progra]
go
/*
primero crearé las tablas que no poseen ninguna FK
y luego iré satisfaciendo dependencias
*/
create table DatosControlBase(
	datosSimulacionListos bit not null
);

create table EstadoEstudiante(
	id int identity primary key,
	nombre nvarchar(20) unique not null,
	habilitado bit not null default 1
);

create table Rubro(
	id int identity primary key,
	nombre nvarchar(20) not null,
	habilitado bit not null default 1
);

/*
create table EstadoGrupo(
	id int identity primary key,
	nombre nvarchar(20) not null,
	habilitado bit not null default 1
)
*/

create table Estudiante(
	id int identity primary key,
	nombre nvarchar(50) not null,
	apellido nvarchar(50) not null,
	email nvarchar(50) unique not null,
	carnet nvarchar(15) unique not null,
	habilitado bit not null default 1,
	telefono nvarchar(8) not null default '00000000'
);

create table Profesor(
	id int identity primary key,
	nombre nvarchar(50) not null,
	apellido nvarchar(50) not null,
	email nvarchar(50) unique not null,
	contraseña nvarchar(8) not null,
	habilitado bit not null default 1
);

create table Periodo(
	id int identity primary key,
	fechaInicio date not null,
	fechaFinalizacion date not null,
	habilitado bit not null default 1
	--activo bit not null
);

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
create table Grupo(
	id int identity primary key,
	FKPeriodo int constraint FKGrupo_Periodo foreign key references Periodo(id) not null,
	FKProfesor int constraint FKGrupo_Profesor foreign key references Profesor(id) not null,
	--FKEstadoGrupo int constraint FKGrupo_EstadoGrupo foreign key references EstadoGrupo(id) not null,
	nombre nvarchar(50) not null,
	codigoGrupo nvarchar(10) not null,
	habilitado bit not null default 1
);

create table GrupoXEstudiante(
	id int identity primary key,
	FKEstudiante int constraint FKGrupoXEstudiante_Estudiante foreign key references Estudiante(id) not null,
	FKGrupo int constraint FKGrupoXEstudiante_Grupo foreign key references Grupo(id) not null,
	FKEstadoEstudiante int constraint FKGrupoXEstudiante_EstadoEstudiante foreign key references EstadoEstudiante(id) not null,
	notaAcumulada float not null check (notaAcumulada > 0 and notaAcumulada <= 100), --entre 0 y 100
	habilitado bit not null default 1
);

create table GrupoXRubro(
	id int identity primary key,
	FKRubro int constraint FKGrupoXRubro_Rubro foreign key references Rubro(id) not null,
	FKGrupo int constraint FKGrupoXRubro_Grupo foreign key references Grupo(id) not null,
	valorPorcentual float not null check (valorPorcentual > 0),
	esFijo bit not null,
	contador int not null check (contador >= 0),-- or (contador >= 0 and esFijo = 0)),
	habilitado bit not null default 1
);

create table Evaluacion(
	id int identity primary key,
	FKGrupoXRubro int constraint FKEvaluacion_GrupoXRubro foreign key references GrupoXRubro(id) not null,
	nombre nvarchar(20) not null,
	fecha datetime not null,
	valorPorcentual float not null check (valorPorcentual > 0), --dato redundante, pero se deja por si acaso
	descripcion nvarchar(100) not null,
	habilitado bit not null default 1
);

create table EvaluacionXEstudiante(
	id int identity primary key,
	FKEvaluacion int constraint FKEvaluacionXEstudiante_Evaluacion foreign key references Evaluacion(id) not null,
	FKGrupoXEstudiante int constraint FKEvaluacionXEstudiante_GrupoXEstudiante foreign key references GrupoXEstudiante(id) not null,
	nota float not null check (nota > 0),
	habilitado bit not null default 1
);