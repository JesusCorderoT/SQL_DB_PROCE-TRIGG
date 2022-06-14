/*1. Realizar una vista vAlumnos que obtenga el siguiente resultado*/

CREATE VIEW VIEW_ALU
AS
select 
alu.nombre AS Nombre,
alu.primerApellido AS ApellidoM,
alu.segundoApellido AS ApellidoP,
alu.correo AS Correo,alu.telefono AS Telefono,
alu.curp AS Curp,
es.nombre as Estado,
ea.nombre as Estatus
from ALUMNOS alu
INNER JOIN Estados es ON alu.idestadoorigen = es.id
INNER JOIN EstatusAlumno ea ON alu.idEstatus = ea.id;


SELECT * FROM VIEW_ALU;

/*2. Realizar el procedimiento almacenado consultarEstados el cual obtendrá la
siguiente consulta, recibiendo como parámetro el id del registro que se
requiere consultar de la tabla Estados. En caso de que el valor sea -1 (menos
uno) deberá regresar todos los registros de dicha tabla.*/CREATE PROCEDURE consultarEstados @ide INT 
AS   
  SELECT id,nombre from Estados where id = @ide OR @ide = -1;
GO

exec consultarEstados '4';
exec consultarEstados '-1';/*
 CREATE FUNCTION FU_IDSTATES(
 @ide INT
 )
 RETURNS @TABLA TABLE
 (
ida int,
estado varchar(20)
 )
 AS
BEGIN
insert into @TABLA
select
id,nombre
from Estados where id = @ide OR @ide = -1
RETURN
END

SELECT * FROM dbo.FU_IDSTATES (5);
SELECT * FROM dbo.FU_IDSTATES (-1);
*/



/*3. Realizar el procedimiento almacenado consultarEstatusAlumnos el cual
obtendrá la siguiente consulta, recibiendo como parámetro el id del registro
que se requiere consultar de la tabla estatusAlumnos. En caso de que el valor
sea -1 (menos uno) deberá regresar todos los registros de dicha tabla.*/CREATE PROCEDURE PO_consultarEstatusAlumnos @ida INT 
AS   
  SELECT id,nombre from EstatusAlumno where id = @ida OR @ida = -1;
GO

exec PO_consultarEstatusAlumnos '4';
exec PO_consultarEstatusAlumnos '-1';

/*4. Realizar el procedimiento almacenado consultarAlumnos el cual obtendrá la
siguiente consulta, recibiendo como parámetro el id del registro que se
requiere consultar de la tabla Alumnos. En caso de que el valor sea -1 (menos
uno) deberá regresar todos los registros de dicha tabla.*/CREATE PROCEDURE PO_consultarAlumnos @ida INTASSELECT * from dbo.FU_ALUMNOS1(@ida);EXEC dbo.PO_consultarAlumnos 1;EXEC dbo.PO_consultarAlumnos -1;/* CREATE FUNCTION FU_ALUMNOS1(
 @ida INT
 )
 RETURNS @TABLA TABLE
 (
nombre TEXT,
primerApellido TEXT,
segundoApellido TEXT,
correo TEXT,
telefono TEXT,
curp TEXT,
nombre1 TEXT,
nombre2 TEXT
 )
 AS
BEGIN
insert into @TABLA
SELECT 
alu.nombre,
alu.primerApellido,
alu.segundoApellido,
alu.correo,
alu.telefono,
alu.curp,
nombre1 = es.nombre,
nombre2 = ea.nombre
from ALUMNOS alu
INNER JOIN Estados es ON alu.idestadoorigen = es.id
INNER JOIN EstatusAlumno ea ON alu.idEstatus = ea.idwhere alu.id = @ida or @ida= -1;
RETURN
END
go

go

select * from dbo.FU_ALUMNOS1(8);
select * from dbo.FU_ALUMNOS1(-1);*/



/*5. Realizar el procedimiento almacenado consultarEAlumnos el cual obtendrá la
siguiente consulta, recibiendo como parámetro el id del registro que se
requiere consultar de la tabla Alumnos. En caso de que el valor sea -1 (menos
uno) deberá regresar todos los registros de dicha tabla.*/-- IGUAL AL ANTERIOR/*6. Realizar el procedimiento almacenado actualizarEstatusAlumnos el cual
recibirá como parámetros el id del Alumno al cual se le requiere cambiar el
estatus y el valor del nuevo estatus.*/

CREATE PROCEDURE PO_actualizarEstatusAlumnos @ida INT , @ide INT
AS   
  UPDATE ALUMNOS SET idEstatus = @ide where id = @ida;
GO
--------------------------ID_ALUMNO/ID_ESTATUS------------------------------
EXEC PO_actualizarEstatusAlumnos 1 , 1;

SELECT * FROM ALUMNOS;



/*7. Realizar el procedimiento almacenado agregarAlumnos el cual recibirá como
parámetros los valores de cada una de las columnas de la tabla de Alumnos
con los cuales se insertará el registro a la tabla Alumnos. El procedimiento
deberá regresar el id con el que se creo el registro en formato de entero.*/CREATE PROCEDURE PO_agregarAlumnos
@name text, @first text,@surname 
text,@mail text,@phone nchar(10),@birth date,
@curp varchar(18),@money decimal(9,2),@state int,@status int
AS   
 INSERT INTO ALUMNOS VALUES (@name,@first,@surname,@mail,@phone,@birth,@curp,@money,@state,@status);
 select SCOPE_IDENTITY()
GOEXEC PO_agregarAlumnos 'Martha','Vichi','Perez','ma@gmail.com',5546985213,'1997-01-05','MAVP010597MMC',15000,19,1;SELECT * FROM ALUMNOS;/*8. Realizar el procedimiento almacenado actualizarAlumnos el cual recibirá
como parámetros los valores de cada una de las columnas de la tabla de Alumnos
con los cuales se actualizarán los valores que existen en la tabla
Alumnos del registro que corresponda al id enviado como parámetro. El
procedimiento deberá regresar la cantidad de registros actualizados. */

CREATE PROCEDURE PO_actualizarAlumnos
@name text, @first text,@surname 
text,@mail text,@phone nchar(10),@birth date,
@curp varchar(18),@money decimal(9,2),@state int,@status int, @ida int
AS   
 UPDATE ALUMNOS SET  nombre = @name,primerApellido = @first,segundoApellido = @surname, correo = @mail,telefono = @phone,fechaNacimiento = @birth, curp = @curp,sueldo = @money,idestadoorigen = @state,idEstatus = @status where id = @ida; SELECT @@ROWCOUNTEXEC PO_actualizarAlumnos 'MartHa','Vichi','Perez','lu@gmail.com',0000000000,'1990-01-05','LUVPP010597MMC',30000,19,1,1005;SELECT * FROM ALUMNOS;

/*9. Realizar el procedimiento almacenado eliminarAlumnos el cual recibirá como
parámetros el valor del id del registro del alumno del que se requiere eliminar.

Primeramente se deberán eliminar todos los registros de la Tabla de
CursosAlumnos los cuales tengan el id del alumno a eliminar y posteriormente
el eliminar al alumno de la Tabla de Alumnos.

Esto deberá considerarse como una transacción ya que se trate de actualizar
dos tablas relacionadas.

En caso de que no se haya eliminado el registro de la tabla de Alumnos
deberá levantar una excepción.*/

ALTER PROCEDURE PO_eliminarAlumnos
@ida int
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
			
		DELETE FROM CursosAlumnos WHERE idalumno = @ida;

		DELETE from ALUMNOS where id = @ida;
		
		
	PRINT 'Eliminacion completada'
	COMMIT TRANSACTION
 END TRY
 BEGIN CATCH
	ROLLBACK TRANSACTION
    print 'Existio un error';
	THROW 51000,'Error al realizar la transferencia', 1;
 END CATCH
END
GO
*/
EXEC PO_eliminarAlumnos 3;

select * from CursosAlumnos;
select * from ALUMNOS;
SELECT * FROM AlumnosBaja;

/*10. Crear el trigger Trigger_EliminarAlumnos el cual se debe ejecutar cuando se
elimina un registro de la tabla de Alumnos. Este trigger deberá insertar un
registro en la Tabla AlumnosBaja del alumno eliminado.*/

	CREATE TRIGGER Trigger_EliminarAlumnos
	ON alumnos
	AFTER DELETE
	AS
	SET NOCOUNT ON --impide que se muestre en los mensajes la fila afectada 
	BEGIN
		INSERT INTO AlumnosBaja (nombre,
								 primerApellido,
								 segundoApellido,
								 fechaBaja
								 )
		SELECT d.nombre,
			   d.primerApellido,
			   d.segundoApellido,
			   getdate()
		FROM deleted d;
	END
	GO

SELECT * FROM Alumnos

DELETE FROM alumnos WHERE id = 1002;

select * from alumnosBaja;



/*11. Obtener un respaldo de su base de datos InstitutoTich*/

USE InstitutoTich;
GO

BACKUP DATABASE InstitutoTich
TO DISK = 'E:\SEMANA 1\27-05-2022\InstitutoTich.bak'
WITH FORMAT,
MEDIANAME = 'SQLServerBackups',
NAME = 'RESPALDO COMPLETADO...'
GO


/*12. Restaurar la base de datos InstitutoTich*/



RESTORE DATABASE InstitutoTich
FROM
DISK = 'E:\SEMANA 1\27-05-2022\InstitutoTich.bak'
WITH REPLACE





/*MORTI*/


 CREATE FUNCTION MORTI00(
 @idalu INT
 )
 RETURNS @TABLA TABLE
 (
nquincena int,
anterior decimal(9,2),
pago decimal(9,2),
nuevo decimal(9,2)
 )
 AS

BEGIN

DECLARE @nquincena int = 1
DECLARE @anterior decimal(9,2)
DECLARE @pago decimal(9,2)
DECLARE @nuevo int
DECLARE @desc decimal(9,2)
set @desc = (select dbo.REEMBOLSOQUINCENAL3(@idalu))

 WHILE @nquincena <= 12
 BEGIN


 SET @anterior = (select sueldo FROM ALUMNOS WHERE ID = @idalu)/12;


insert into @TABLA
select
nquincena = @nquincena,
anterior = (select sueldo FROM ALUMNOS WHERE ID = @idalu),
pago = (select dbo.REEMBOLSOQUINCENAL3(@idalu)),

nuevo = ((select sueldo FROM ALUMNOS WHERE ID = @idalu) - @desc)
SELECT @nquincena = @nquincena+1
END
RETURN
END
 
 /**/


 select * from MORTI00(1);

print dbo.REEMBOLSOQUINCENAL(55000);
print dbo.REEMBOLSOQUINCENAL2(1);


