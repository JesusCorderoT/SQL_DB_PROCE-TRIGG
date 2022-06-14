	CREATE TRIGGER Trigger_EliminarAlumnos
	ON alumnos
	AFTER DELETE
	AS
	SET NOCOUNT ON 
	BEGIN
	
	BEGIN TRY
	BEGIN TRANSACTION
	
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
	
	
	
	CREATE PROCEDURE TransaccionEfectivo
@IdCuentaOrigen int,
@IdCuentaDestino int,
@MontoTransacción decimal
AS
BEGIN
DECLARE @saldoActual decimal
	BEGIN TRY
	BEGIN TRANSACTION
	    SET @saldoActual=(SELECT saldo FROM Saldos WHERE id=@IdCuentaOrigen)
		UPDATE Saldos
		SET  saldo = IIF(@MontoTransacción<=@saldoActual,@saldoActual-@MontoTransacción,0)
		WHERE id=@IdCuentaOrigen
		UPDATE Saldos
		SET saldo = (SELECT saldo FROM Saldos WHERE id=@IdCuentaDestino)+@MontoTransacción
		WHERE id=@IdCuentaDestino
		INSERT Transacciones(idOrigen,idDestino,monto)
		VALUES(@IdCuentaOrigen,@IdCuentaDestino,@MontoTransacción)
	
	PRINT 'Transacción exitosa'
	COMMIT TRANSACTION
 END TRY
 BEGIN CATCH
	ROLLBACK TRANSACTION
    print 'Existio un error';
	THROW 51000,'Error al realizar la transferencia', 1;
 END CATCH
END
GO