use master
if exists(select * from sysdatabases where name = 'I_Progra') 
begin
	use [I_Progra];
	set nocount on;
	begin transaction
		begin try
			declare @datosXML xml;
			set @datosXML = (select * from openrowset(bulk 'C:\BaseDatos\randomData.xml',single_blob) as x);
			--select @datosXML; --visualizarlo
			declare @elementoActual xml;--método un poco sucio, pero no quedó de otra
			declare @nombre nvarchar(50), @apellido nvarchar(50), @email nvarchar(50), @contraseña nvarchar(8);--realmente desearía no necesitar estas variables

			declare @contador int = 1;--los id empiezan en 1, si no encuentra a algo con el id 1, significa que no hay
			--luego recorreré todo usando este contador, de tal manera de que si el siguiente id no existe, ya terminé de recorrer esos datos
			--<teacher ID="1" name="Fucaila" lastName="Vusailai" email="FucailaVusailai61@hotmail.com" password="8797582436" />
			while (@datosXML.exist('(/XML/teacherData/teacher[@ID=sql:variable("@contador")])') = 1)
			begin
				set @elementoActual = @datosXML.query('(/XML/teacherData/teacher[@ID=sql:variable("@contador")])');
				--select @contador, @elementoActual; --impresiones de control
				--ahora sí, hago la inserción
				set @nombre = @elementoActual.value('(/teacher/@name)[1]','nvarchar(50)');
				set @apellido = @elementoActual.value('(/teacher/@lastName)[1]','nvarchar(50)');
				set @email = @elementoActual.value('(/teacher/@email)[1]','nvarchar(50)');
				set @contraseña = @elementoActual.value('(/teacher/@password)[1]','nvarchar(8)');
				exec SPinsertarProfesor @nombre, @apellido, @email, @contraseña;
				--para mantener el invariante del while
				set @contador = @contador + 1;
			end;

			set @contador = 1;--reinicio el contador para ahora insertar los estudiantes
			declare @telefono nvarchar(8), @carnet nvarchar(15);--me faltan esas variable, pues los profesores son diferentes en ciertos aspectos
			--ahora otro while para insertar los estudiantes
			--<student ID="1" name="Cadeqe" lastName="Doapuofuvouko" email="CadeqeDoapuofuvouko93@edger.ik" carnet="2015989801" phone="24446966" />
			while (@datosXML.exist('(/XML/studentData/student[@ID=sql:variable("@contador")])') = 1)
			begin
				set @elementoActual = @datosXML.query('(/XML/studentData/student[@ID=sql:variable("@contador")])');
				--select @contador, @elementoActual; --impresiones de control
				--ahora sí, hago la inserción
				set @nombre = @elementoActual.value('(/student/@name)[1]','nvarchar(50)');
				set @apellido = @elementoActual.value('(/student/@lastName)[1]','nvarchar(50)');
				set @email = @elementoActual.value('(/student/@email)[1]','nvarchar(50)');
				set @carnet = @elementoActual.value('(/student/@carnet)[1]','nvarchar(8)');
				set @telefono = @elementoActual.value('(/student/@phone)[1]','nvarchar(8)');
				exec SPinsertarEstudiante @nombre, @apellido, @email, @carnet, @telefono;
				--para mantener el invariante del while
				set @contador = @contador + 1;
			end;

			set @contador = 1;--de nuevo reinicio el contador, esta vez para insertar los periodos
			declare @fechaInicio date, @fechaFinal date;
			--<term ID="1" start="01/01/2017 01:00 AM" end="06/01/2017 01:00 AM" active="False" />
			while (@datosXML.exist('(/XML/termData/term[@ID=sql:variable("@contador")])') = 1)
			begin
				set @elementoActual = @datosXML.query('(/XML/termData/term[@ID=sql:variable("@contador")])');
				--select @contador, @elementoActual; --impresiones de control
				--ahora sí, hago la inserción
				set @fechaInicio = @elementoActual.value('(/term/@start)[1]','date');
				set @fechaFinal = @elementoActual.value('(/term/@end)[1]','date');
				exec SPinsertarPeriodo @fechaInicio, @fechaFinal;
				--para mantener el invariante del while
				set @contador = @contador + 1;
			end;

			set @contador = 1;--de nuevo reinicio el contador, esta vez para insertar los grupos
			--recordar que los estados de grupo fueron eliminados de la especificación
			declare @idProfesor int, @idPeriodo int, @codigoGrupo nvarchar(10);
			--<group ID="1" groupStateID="3" teacherID="4" termID="1" courseName="Fundamentos de organización de computadores" code="1818KU" />
			while (@datosXML.exist('(/XML/groupData/group[@ID=sql:variable("@contador")])') = 1)
			begin
				set @elementoActual = @datosXML.query('(/XML/groupData/group[@ID=sql:variable("@contador")])');
				--select @contador, @elementoActual; --impresiones de control
				--ahora sí, hago la inserción
				set @nombre = @elementoActual.value('(/group/@courseName)[1]','nvarchar(50)');
				set @codigoGrupo = @elementoActual.value('(/group/@code)[1]','nvarchar(10)');
				set @idPeriodo = @elementoActual.value('(/group/@termID)[1]','int');
				set @idProfesor = @elementoActual.value('(/group/@teacherID)[1]','int');
				exec SPinsertarGrupo @nombre, @codigoGrupo, @idProfesor, @idPeriodo;
				--para mantener el invariante del while
				set @contador = @contador + 1;
			end;

			set @contador = 1;--de nuevo reinicio el contador, esta vez para insertar los Estados de los estudiantes
			declare @nombreEstadoEstudiante varchar(10);
			--<studentGroupState ID="1" name="Aprobado" />
			while (@datosXML.exist('(/XML/studentGroupStateData/studentGroupState[@ID=sql:variable("@contador")])') = 1)
			begin
				set @elementoActual = @datosXML.query('(/XML/studentGroupStateData/studentGroupState[@ID=sql:variable("@contador")])');
				--select @contador, @elementoActual; --impresiones de control
				--ahora sí, hago la inserción
				set @nombreEstadoEstudiante = @elementoActual.value('(/studentGroupState/@name)[1]','varchar(10)');
				exec SPinsertarEstadoEstudiante @nombreEstadoEstudiante;
				--para mantener el invariante del while
				set @contador = @contador + 1;
			end;

			set @contador = 1;--de nuevo reinicio el contador, esta vez para insertar los GrupoXEstudiante's
			declare @idEstudiante int ,@idGrupo int, @notaAcumulada float, @idEstadoEstudiante int;
			--<studentGroup ID="1" totalGrade="80.04356403342939" groupID="6" studentID="30" studentGroupStateID="2" />
			while (@datosXML.exist('(/XML/studentGroupData/studentGroup[@ID=sql:variable("@contador")])') = 1)
			begin
				set @elementoActual = @datosXML.query('(/XML/studentGroupData/studentGroup[@ID=sql:variable("@contador")])');
				--select @contador, @elementoActual; --impresiones de control
				--ahora sí, hago la inserción
				set @idEstudiante = @elementoActual.value('(/studentGroup/@studentID)[1]','int');
				set @idGrupo = @elementoActual.value('(/studentGroup/@groupID)[1]','int');
				set @notaAcumulada = @elementoActual.value('(/studentGroup/@totalGrade)[1]','float');
				set @idEstadoEstudiante = @elementoActual.value('(/studentGroup/@studentGroupStateID)[1]','int');
				exec SPinsertarGrupoXEstudiante @idEstudiante, @idGrupo, @idEstadoEstudiante, @notaAcumulada;
				--para mantener el invariante del while
				set @contador = @contador + 1;
			end;

			set @contador = 1;--de nuevo reinicio el contador, esta vez para insertar los Rubro
			declare @nombreRubro nvarchar(20);
			--<item ID="1" name="Examen" />
			while (@datosXML.exist('(/XML/itemData/item[@ID=sql:variable("@contador")])') = 1)
			begin
				set @elementoActual = @datosXML.query('(/XML/itemData/item[@ID=sql:variable("@contador")])');
				--select @contador, @elementoActual; --impresiones de control
				--ahora sí, hago la inserción
				set @nombreRubro = @elementoActual.value('(/item/@name)[1]','nvarchar(20)');
				exec SPinsertarRubro @nombreRubro;
				--para mantener el invariante del while
				set @contador = @contador + 1;
			end;

			set @contador = 1;--de nuevo reinicio el contador, esta vez para insertar los GrupoXRubro's
			declare @idRubro int, @valorPorcentual float, @esFijo bit, @cuentaEvaluaciones int;
			--<groupItem ID="1" itemID="1" groupID="1" percentage="4.485456167596401" count="1" constantCount="True" />
			while (@datosXML.exist('(/XML/groupItemData/groupItem[@ID=sql:variable("@contador")])') = 1)
			begin
				set @elementoActual = @datosXML.query('(/XML/groupItemData/groupItem[@ID=sql:variable("@contador")])');
				--select @contador, @elementoActual; --impresiones de control
				--ahora sí, hago la inserción
				set @idRubro = @elementoActual.value('(/groupItem/@itemID)[1]','int');
				set @idGrupo = @elementoActual.value('(/groupItem/@groupID)[1]','int');
				set @valorPorcentual = @elementoActual.value('(/groupItem/@percentage)[1]','float');
				set @cuentaEvaluaciones = @elementoActual.value('(/groupItem/@count)[1]','int');
				set @esFijo = @elementoActual.value('(/groupItem/@constantCount)[1]','bit');
				exec SPinsertarGrupoXRubro @idRubro, @idGrupo, @valorPorcentual, @cuentaEvaluaciones, @esFijo;
				--para mantener el invariante del while
				set @contador = @contador + 1;
			end;

			set @contador = 1;--de nuevo reinicio el contador, esta vez para insertar las Evaluaciones
			declare @idGrupoXRubro int, @nombreEvaluacion nvarchar(20), @fechaEvaluacion datetime, @descripcionEvaluacion nvarchar(100)
			--<evaluation ID="1" groupItemID="1" name="Examen 0" date="01/01/2017 01:00 AM" percentage="4.485456167596401" description="Obikoe hrenecu otu hoii. Xiqou hi qarosum visoifis. Vainau qogou poehauqi cam daovipi dasom sebelfo." />
			while (@datosXML.exist('(/XML/evaluationData/evaluation[@ID=sql:variable("@contador")])') = 1)
			begin
				set @elementoActual = @datosXML.query('(/XML/evaluationData/evaluation[@ID=sql:variable("@contador")])');
				--select @contador, @elementoActual; --impresiones de control
				--ahora sí, hago la inserción
				set @idGrupoXRubro = @elementoActual.value('(/evaluation/@groupItemID)[1]','int');
				set @nombreEvaluacion = @elementoActual.value('(/evaluation/@name)[1]','nvarchar(20)');
				set @fechaEvaluacion = @elementoActual.value('(/evaluation/@date)[1]','datetime');
				set @valorPorcentual = @elementoActual.value('(/evaluation/@percentage)[1]','float');
				set @descripcionEvaluacion = @elementoActual.value('(/evaluation/@description)[1]','nvarchar(100)');
				exec SPinsertarEvaluacion @idGrupoXRubro, @nombreEvaluacion, @fechaEvaluacion, @valorPorcentual, @descripcionEvaluacion;
				--para mantener el invariante del while
				set @contador = @contador + 1;
			end;

			set @contador = 1;--de nuevo reinicio el contador, esta vez para insertar las EvaluacionXEstudiante's. Esto es lo último por cargar
			declare @idGrupoXEstudiante int, @idEvaluacion int
			--<studentEvaluation ID="1" studentGroupID="1" evaluationID="57" grade="100"/>
			while (@datosXML.exist('(/XML/studentEvaluationData/studentEvaluation[@ID=sql:variable("@contador")])') = 1)
			begin
				set @elementoActual = @datosXML.query('(/XML/studentEvaluationData/studentEvaluation[@ID=sql:variable("@contador")])');
				--select @contador, @elementoActual; --impresiones de control
				--ahora sí, hago la inserción
				set @idGrupoXEstudiante = @elementoActual.value('(/studentEvaluation/@studentGroupID)[1]','int');
				set @idEvaluacion = @elementoActual.value('(/studentEvaluation/@evaluationID)[1]','int');
				set @valorPorcentual = @elementoActual.value('(/studentEvaluation/@grade)[1]','float');
				exec SPinsertarEvaluacionXEstudiante @idEvaluacion, @idGrupoXEstudiante, @valorPorcentual;
				--para mantener el invariante del while
				set @contador = @contador + 1;
			end;

		commit
	end try
	begin catch
		select ERROR_MESSAGE(), ERROR_LINE(), ERROR_NUMBER()
		rollback
	end catch
end