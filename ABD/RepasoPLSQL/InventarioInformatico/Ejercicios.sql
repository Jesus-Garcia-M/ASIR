/*
4. Realizar un trigger para que en el momento en que se produzca una incidencia se envíe un correo electrónico con
toda la información al usuario responsable de la misma. Si el ordenador es uno de los servidores, el correo se
enviará a todos los usuarios.
*/

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





CREATE OR REPLACE FUNCTION ObtenerCorreo (p_usuario Usuarios.Nombre%type)
RETURN VARCHAR2
AS
  v_correo VARCHAR2;

BEGIN
  SELECT CorreoElectronico INTO v_correo
  FROM Usuarios
  WHERE Nombre = p_usuario;

  RETURN v_correo;

END ObtenerCorreo;
/





CREATE OR REPLACE PROCEDURE EnviarCorreoDifusion (p_numeroincidencia Incidencias.Numero%type
                                                  p_numeroserie Incidencias.NumeroSerieOrdenador%type,
                                                  p_descripcion Incidencias.Descripcion%type,
                                                  p_fechanotificacion Incidencias.FechaHoraNotificacion%type))
AS
  conexion UTL_SMTP.connection;

  CURSOR c_usuarios IS
    SELECT Nombre
    FROM Usuarios;

BEGIN
  conexion := UTL_SMTP.open_connection('smtp.gmail.com', 25);
  
  FOR elem IN c_usuarios LOOP
    UTL_SMTP.helo(conexion, 'smtp.gmail.com');
    UTL_SMTP.mail(conexion, 'incidencias@gmail.com');
    UTL_SMTP.rcpt(conexion, ObtenerCorreo(elem.Nombre));
    UTL_SMTP.data(conexion, p_numeroserie || UTL_TCP.crlf || UTL_TCP.crlf);
    UTL_SMTP.data(conexion, p_descripcion || UTL_TCP.crlf || UTL_TCP.crlf);
    UTL_SMTP.data(conexion, p_fechanotificacion || UTL_TCP.crlf || UTL_TCP.crlf);
  END LOOP;

  UTL_SMTP.quit(conexion);  

END EnviarCorreo;
/





CREATE OR REPLACE PROCEDURE EnviarCorreoUnico (p_numeroincidencia Incidencias.Numero%type
                                               p_usuario Incidencias.NombreUsuarioResponsable%type,
                                               p_numeroserie Incidencias.NumeroSerieOrdenador%type,
                                               p_descripcion Incidencias.Descripcion%type,
                                               p_fechanotificacion Incidencias.FechaHoraNotificacion%type)
AS
  conexion UTL_SMTP.connection;

BEGIN
  conexion := UTL_SMTP.open_connection('smtp.gmail.com', 25);
  UTL_SMTP.helo(conexion, 'smtp.gmail.com');
  UTL_SMTP.mail(conexion, 'incidencias@gmail.com');
  UTL_SMTP.rcpt(conexion, ObtenerCorreo(p_usuario));
  UTL_SMTP.data(conexion, p_numeroserie || UTL_TCP.crlf || UTL_TCP.crlf);
  UTL_SMTP.data(conexion, p_descripcion || UTL_TCP.crlf || UTL_TCP.crlf);
  UTL_SMTP.data(conexion, p_fechanotificacion || UTL_TCP.crlf || UTL_TCP.crlf);
  UTL_SMTP.quit(conexion);

END EnviarCorreoUnico;
/





CREATE OR REPLACE TRIGGER CorreoIncidencia
AFTER INSERT ON Incidencias
FOR EACH ROW
BEGIN
  IF ComprobarSiServidor(:new.NumeroSerieOrdenador) = 1 THEN
	EnviarCorreoDifusion(:new.Numero);
  ELSE
    EnviarCorreoUnico(:new.Numero);
  END IF;

END;
/




/*
5. Añade una columna TiempodeDesconexión en la tabla Servidores. Haz un procedimiento que la rellene a partir de
los datos que aparecen en la tabla PeriodosdeApagado y realiza un trigger que mantenga la columna actualizada
cada vez que termine un periodo de apagado.
*/
ALTER TABLE Servidores ADD TiempodeDesconexion NUMBER(15);

CREATE OR REPLACE FUNCTION CalcularTiempo (p_inicio DATE,
                                           p_fin DATE)
RETURN NUMBER
AS
  v_diferencia NUMBER := 0;

BEGIN
  v_diferencia := (p_fin - p_inicio) * 86400;
  RETURN v_diferencia;

END CalcularTiempo;
/


CREATE OR REPLACE PROCEDURE RellenarTiempoDesconexion
AS
  CURSOR c_periodosapagado IS
    SELECT NumeroSerieServidor, sum(CalcularTiempo(FechaHoraInicio, FechaHoraFin)) AS tiempodesconexion
    FROM Periodosdeapagado;

BEGIN
  FOR elem IN c_periodosapagado LOOP
    UPDATE Servidores
      SET TiempodeDesconexion = elem.tiempodesconexion
      WHERE NumeroSerie = elem.NumeroSerieServidor;
  END LOOP;

END RellenarTiempoDesconexion;
/



/*
7. Realiza los módulos de programación necesarios para garantizar que un servidor siempre proporciona al menos un
servicio.
*/