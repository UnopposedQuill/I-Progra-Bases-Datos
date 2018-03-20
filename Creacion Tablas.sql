
/*
primero crearé las tablas que no poseen ninguna FK
y luego iré satisfaciendo dependencias
*/
create table EstadoEstudiante(
	id int identity primary key,
	nombre nvarchar(20)
)

create table Rubro(
	id int identity primary key,
	nombre nvarchar(20)
)

create table EstadoGrupo(
	id int identity primary key,
	nombre nvarchar(20)
)

create table Estudiante(
	id int identity primary key,
	nombre nvarchar(50),
	email nvarchar(30),
	contraseña nvarchar(8)
)

create table Profesor(
	id int identity primary key,
	nombre nvarchar(50),
	email nvarchar(50),
	contraseña nvarchar(8)
)

create table Periodo(
	id int identity primary key,
	fechaInicio date,
	fechaFinalizacion date,
	activo bit
)

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
create table Grupo(
	id int identity primary key,
	FKPeriodo int constraint FKPeriodo foreign key references Periodo(id),
	FKProfesor int constraint FKProfesor foreign key references Profesor(id),
	FKEstadoGrupo int constraint FKEstadoGrupo foreign key references EstadoGrupo(id),
	nombre nvarchar(50),
	codigoGrupo nvarchar(10)
)

create table GrupoXEstudiante(
	id int identity primary key,
	FKEstudiante int constraint FKEstudiante foreign key references Estudiante(id),
	FKGrupo int constraint FKGrupo foreign key references Grupo(id),
	FKEstadoEstudiante int constraint FKEstadoEstudiante foreign key references EstadoEstudiante(id),
	notaAcumulada smallint
)

create table GrupoXRubro(
	id int identity primary key,
	FKRubro int constraint FKRubro foreign key references Rubro(id),
	FKGrupo int constraint FKGrupo foreign key references Grupo(id),
	valor smallint,
	esFijo bit,
	contador int
)

create table Evaluacion(
	id int identity primary key,
	FKGrupoXRubro int constraint FKGrupoXRubro foreign key references GrupoXRubro(id),
	nombre nvarchar(20),
	fecha date,
	valorPorcentual smallint,
	descripcion nvarchar(100),
)

create table EvaluacionXEstudiante(
	id int identity primary key,
	FKEvaluacion int constraint FKEvaluacion foreign key references Evaluacion(id),
	FKGrupoXEstudiante int constraint FKGrupoXEstudiante foreign key references GrupoXEstudiante(id),
	nota smallint
)