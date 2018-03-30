
use [I Progra]

/*
primero crearé las tablas que no poseen ninguna FK
y luego iré satisfaciendo dependencias
*/
create table EstadoEstudiante(
	id int identity primary key,
	nombre nvarchar(20) not null
)

create table Rubro(
	id int identity primary key,
	nombre nvarchar(20) not null
)

create table EstadoGrupo(
	id int identity primary key,
	nombre nvarchar(20) not null
)

create table Estudiante(
	id int identity primary key,
	nombre nvarchar(50) not null,
	email nvarchar(50) not null,
	contraseña nvarchar(8) not null
)

create table Profesor(
	id int identity primary key,
	nombre nvarchar(50) not null,
	email nvarchar(50) not null,
	contraseña nvarchar(8) not null
)

create table Periodo(
	id int identity primary key,
	fechaInicio date not null,
	fechaFinalizacion date not null,
	activo bit not null
)

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
create table Grupo(
	id int identity primary key,
	FKPeriodo int constraint FKGrupo_Periodo foreign key references Periodo(id) not null,
	FKProfesor int constraint FKGrupo_Profesor foreign key references Profesor(id) not null,
	FKEstadoGrupo int constraint FKGrupo_EstadoGrupo foreign key references EstadoGrupo(id) not null,
	nombre nvarchar(50) not null,
	codigoGrupo nvarchar(10) not null
)

create table GrupoXEstudiante(
	id int identity primary key,
	FKEstudiante int constraint FKGrupoXEstudiante_Estudiante foreign key references Estudiante(id) not null,
	FKGrupo int constraint FKGrupoXEstudiante_Grupo foreign key references Grupo(id) not null,
	FKEstadoEstudiante int constraint FKGrupoXEstudiante_EstadoEstudiante foreign key references EstadoEstudiante(id) not null,
	notaAcumulada smallint not null check (notaAcumulada > 0 and notaAcumulada <= 100) --entre 0 y 100
)

create table GrupoXRubro(
	id int identity primary key,
	FKRubro int constraint FKGrupoXRubro_Rubro foreign key references Rubro(id) not null,
	FKGrupo int constraint FKGrupoXRubro_Grupo foreign key references Grupo(id) not null,
	valor smallint not null check (valor > 0),
	esFijo bit not null,
	contador int not null check (contador > 0)
)

create table Evaluacion(
	id int identity primary key,
	FKGrupoXRubro int constraint FKEvaluacion_GrupoXRubro foreign key references GrupoXRubro(id) not null,
	nombre nvarchar(20) not null,
	fecha date not null,
	valorPorcentual smallint not null check (valorPorcentual > 0),
	descripcion nvarchar(100) not null,
)

create table EvaluacionXEstudiante(
	id int identity primary key,
	FKEvaluacion int constraint FKEvaluacionXEstudiante_Evaluacion foreign key references Evaluacion(id) not null,
	FKGrupoXEstudiante int constraint FKEvaluacionXEstudiante_GrupoXEstudiante foreign key references GrupoXEstudiante(id) not null,
	nota smallint not null check (nota > 0)
)