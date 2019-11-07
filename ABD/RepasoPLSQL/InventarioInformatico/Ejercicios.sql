/*
4. Realizar un trigger para que en el momento en que se produzca una incidencia se envíe un correo electrónico con
toda la información al usuario responsable de la misma. Si el ordenador es uno de los servidores, el correo se
enviará a todos los usuarios.
*/

-- Parámetro: Número de serie de un ordenador.
-- Descripción: Comprueba si el número de serie pertenece a un servidor o no, si es un servidor devuelve 1, si no, 0.
CREATE OR REPLACE FUNCTION ComprobarSiServidor (p_numeroserie Servidores.NumeroSerie%type)
RETURN NUMBER
AS
  CURSOR c_servidores IS
    SELECT NumeroSerie
    FROM Servidores;

BEGIN
  FOR elem IN c_servidores LOOP
    IF p_numeroserie = elem.NumeroSerie THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  END LOOP;

END ComprobarSiServidor;
/





-- Parámetro: Nombre de usuario. 
-- Descripción: Devuelve la dirección de correo del usuario indicado.
CREATE OR REPLACE FUNCTION ObtenerCorreo (p_usuario Usuarios.Nombre%type)
RETURN VARCHAR2
AS
  v_correo VARCHAR2(50);

BEGIN
  SELECT CorreoElectronico INTO v_correo
  FROM Usuarios
  WHERE Nombre = p_usuario;

  RETURN v_correo;

END ObtenerCorreo;
/





-- Parámetros: 
--    Numero de la incidencia.
--    Número de serie del ordenador afectado.
--    Descripción de la incidencia.
--    Fecha de creación de la incidencia.
-- Descripción: Envía la información de la incidencia a todos los usuarios.
CREATE OR REPLACE PROCEDURE EnviarCorreoDifusion (p_numeroincidencia Incidencias.Numero%type,
                                                  p_numeroserie Incidencias.NumeroSerieOrdenador%type,
                                                  p_descripcion Incidencias.Descripcion%type,
                                                  p_fechanotificacion Incidencias.FechaHoraNotificacion%type)
AS
  conexion UTL_SMTP.connection;

  CURSOR c_usuarios IS
    SELECT Nombre
    FROM Usuarios;

BEGIN
  conexion := UTL_SMTP.open_connection('smtp.gmail.com', 587);

  FOR elem IN c_usuarios LOOP
    UTL_SMTP.helo(conexion, 'smtp.gmail.com');
    UTL_SMTP.mail(conexion, 'incidencias@gmail.com');
    UTL_SMTP.rcpt(conexion, ObtenerCorreo(elem.Nombre));
    UTL_SMTP.data(conexion, p_numeroserie || UTL_TCP.crlf || UTL_TCP.crlf);
    UTL_SMTP.data(conexion, p_descripcion || UTL_TCP.crlf || UTL_TCP.crlf);
    UTL_SMTP.data(conexion, p_fechanotificacion || UTL_TCP.crlf || UTL_TCP.crlf);
  END LOOP;

  UTL_SMTP.quit(conexion);

END EnviarCorreoDifusion;
/





-- Parámetros: 
--    Numero de la incidencia.
--    Usuario que crea la incidencia.
--    Número de serie del ordenador afectado.
--    Descripción de la incidencia.
--    Fecha de creación de la incidencia.
-- Descripción: Envía la información de la incidencia al usuario responsable de la misma.
CREATE OR REPLACE PROCEDURE EnviarCorreoUnico (p_numeroincidencia Incidencias.Numero%type,
                                               p_usuario Incidencias.NombreUsuarioResponsable%type,
                                               p_numeroserie Incidencias.NumeroSerieOrdenador%type,
                                               p_descripcion Incidencias.Descripcion%type,
                                               p_fechanotificacion Incidencias.FechaHoraNotificacion%type)
AS
  conexion UTL_SMTP.connection;

BEGIN
  conexion := UTL_SMTP.open_connection('smtp.gmail.com', 587);
  UTL_SMTP.helo(conexion, 'smtp.gmail.com');
  UTL_SMTP.mail(conexion, 'incidencias@gmail.com');
  UTL_SMTP.rcpt(conexion, ObtenerCorreo(p_usuario));
  UTL_SMTP.data(conexion, p_numeroserie || UTL_TCP.crlf || UTL_TCP.crlf);
  UTL_SMTP.data(conexion, p_descripcion || UTL_TCP.crlf || UTL_TCP.crlf);
  UTL_SMTP.data(conexion, p_fechanotificacion || UTL_TCP.crlf || UTL_TCP.crlf);
  UTL_SMTP.quit(conexion);

END EnviarCorreoUnico;
/





-- Descripción: Tras insertar una nueva incidencia, comprueba si el ordenador afectado es un servidor,
-- si lo és, llama a la función "EnviarCorreoDifusión", si no, llama a la función "EnviarCorreoUnico". 
CREATE OR REPLACE TRIGGER CorreoIncidencia
AFTER INSERT ON Incidencias
FOR EACH ROW
BEGIN
  IF ComprobarSiServidor(:new.NumeroSerieOrdenador) = 1 THEN
     EnviarCorreoDifusion(:new.Numero,
	 	                  :new.NumeroSerieOrdenador,
	 	                  :new.Descripcion,
		                  :new.FechaHoraNotificacion);
  ELSE
     EnviarCorreoUnico(:new.Numero,
    	               :new.NombreUsuarioResponsable,
    	               :new.NumeroSerieOrdenador,
    	               :new.Descripcion,
    	               :new.FechaHoraNotificacion);
  END IF;

END;
/




/*
5. Añade una columna TiempodeDesconexión en la tabla Servidores. Haz un procedimiento que la rellene a partir de
los datos que aparecen en la tabla PeriodosdeApagado y realiza un trigger que mantenga la columna actualizada
cada vez que termine un periodo de apagado.
*/

-- Añadir la columna "TiempodeDesconexion" a la tabla "Servidores".
ALTER TABLE Servidores ADD TiempodeDesconexion NUMBER(15);


-- Parámetros:
--    Fecha inicio.
--    Fecha fin.
-- Descripción: Devuelve el tiempo transcurrido en segundos entre las dos fechas.
CREATE OR REPLACE FUNCTION CalcularDiferencia (p_inicio DATE,
                                               p_fin DATE)
RETURN NUMBER
AS
  v_diferencia NUMBER := 0;

BEGIN
  v_diferencia := (p_fin - p_inicio) * 86400;
  RETURN v_diferencia;

END CalcularDiferencia;
/





-- Descripción: Rellena la columna "TiempodeDesconexion" a través de los datos de la tabla "Periodosdeapagado".
CREATE OR REPLACE PROCEDURE RellenarTiempoDesconexion
AS
  CURSOR c_periodosapagado IS
    SELECT NumeroSerieServidor, sum(CalcularDiferencia(FechaHoraInicio, FechaHoraFin)) AS tiempodesconexion
    FROM Periodosdeapagado
    GROUP BY NumeroSerieServidor;

BEGIN
  FOR elem IN c_periodosapagado LOOP
    UPDATE Servidores
      SET TiempodeDesconexion = elem.tiempodesconexion
      WHERE NumeroSerie = elem.NumeroSerieServidor;
  END LOOP;

END RellenarTiempoDesconexion;
/





-- Descripción: Llama al procedimiento "RellenarTiempoDesconexion" cuando se inserta o actualiza el campo "FechaHoraFin".
CREATE OR REPLACE TRIGGER ActualizarTablaServidores
AFTER INSERT OR UPDATE OF FechaHoraFin ON Periodosdeapagado
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    UPDATE Servidores
      SET TiempodeDesconexion = TiempodeDesconexion + CalcularDiferencia(:new.FechaHoraInicio, :new.FechaHoraFin)
      WHERE NumeroSerie = :new.NumeroSerieServidor;
  ELSIF UPDATING THEN
    UPDATE Servidores
      SET TiempodeDesconexion = TiempodeDesconexion + CalcularDiferencia(:new.FechaHoraInicio, :new.FechaHoraFin)
      WHERE NumeroSerie = :old.NumeroSerieServidor;
  END IF;

END;
/





-- POSTGRESQL
-- Añadir la columna "TiempodeDesconexion" a la tabla "Servidores".
ALTER TABLE Servidores ADD TiempodeDesconexion NUMERIC(15);


-- Parámetros:
--    Fecha inicio.
--    Fecha fin.
-- Descripción: Devuelve el tiempo transcurrido en segundos entre las dos fechas.
CREATE OR REPLACE FUNCTION CalcularDiferencia (p_inicio TIMESTAMP,
                                               p_fin TIMESTAMP)
RETURNS NUMERIC
AS $CalcularDiferencia$
DECLARE
  v_diferencia NUMERIC := 0;

BEGIN
  v_diferencia := EXTRACT(EPOCH FROM (p_fin - p_inicio));
  RETURN v_diferencia;

END;
$CalcularDiferencia$ LANGUAGE plpgsql;





-- Descripción: Rellena la columna "TiempodeDesconexion" a través de los datos de la tabla "Periodosdeapagado".
CREATE OR REPLACE FUNCTION RellenarTiempoDesconexion()
RETURNS VOID
AS $RellenarTiempoDesconexion$
DECLARE
  c_periodosapagado CURSOR FOR
    SELECT NumeroSerieServidor, sum(CalcularDiferencia(FechaHoraInicio, FechaHoraFin)) AS tiempodesconexion
    FROM Periodosdeapagado
    GROUP BY NumeroSerieServidor;

  elem RECORD;

BEGIN
  FOR elem IN c_periodosapagado LOOP
    UPDATE Servidores
      SET TiempodeDesconexion = elem.tiempodesconexion
      WHERE NumeroSerie = elem.NumeroSerieServidor;
  END LOOP;

END;
$RellenarTiempoDesconexion$ LANGUAGE plpgsql;





-- Descripción: Actualiza la columna "TiempodeDesconexion" de la tabla "Servidores".
CREATE OR REPLACE FUNCTION ActualizarTablaServidores()
RETURNS trigger AS $TriggerActualizarServidores$

BEGIN
  IF (TG_OP = 'INSERT') THEN
    UPDATE Servidores
      SET TiempodeDesconexion = TiempodeDesconexion + CalcularDiferencia(NEW.FechaHoraInicio, NEW.FechaHoraFin)
      WHERE NumeroSerie = NEW.NumeroSerieServidor;
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE Servidores
      SET TiempodeDesconexion = TiempodeDesconexion + CalcularDiferencia(NEW.FechaHoraInicio, NEW.FechaHoraFin)
      WHERE NumeroSerie = OLD.NumeroSerieServidor;
  END IF;

  RETURN NULL;

END;

$TriggerActualizarServidores$ LANGUAGE plpgsql;





-- Descripción: Llama a la función "ActualizarTablaServidores" cada vez que se inserta o actualiza la columna "FechaHoraFin" de la tabla "Periodosdeapagado"
CREATE TRIGGER TriggerActualizarServidores
AFTER INSERT OR UPDATE OF FechaHoraFin ON Periodosdeapagado
FOR EACH ROW
EXECUTE PROCEDURE ActualizarTablaServidores();





/*
7. Realiza los módulos de programación necesarios para garantizar que un servidor siempre proporciona al menos un
servicio.
*/

after update of numeroserie or delete on serviciosinstalados
