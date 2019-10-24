create table ORDENADORES(
NumeroSerie         VARCHAR(15),
CONSTRAINT pk_ordenadores PRIMARY KEY (NumeroSerie),
CONSTRAINT formatonumserie CHECK(NumeroSerie ~ '^[A-Za-z]{2}-[0-9]{5}-[A-Za-z]-[0-9]{2}$')
);

// Insertamos datos ORDENADORES

INSERT INTO ORDENADORES values('SS-00001-S-01');
INSERT INTO ORDENADORES values('SS-00002-S-02');
INSERT INTO ORDENADORES values('SS-00003-S-03');
INSERT INTO ORDENADORES values('SS-00004-S-04');
INSERT INTO ORDENADORES values('SS-00005-S-05');
INSERT INTO ORDENADORES values('SS-00006-S-06');
INSERT INTO ORDENADORES values('AA-00001-A-01');
INSERT INTO ORDENADORES values('AA-00002-A-02');
INSERT INTO ORDENADORES values('AA-00003-A-03');
INSERT INTO ORDENADORES values('DD-00001-D-01');
INSERT INTO ORDENADORES values('DD-00002-D-02');
INSERT INTO ORDENADORES values('DD-00003-D-03');



create table SERVIDORES(
NumeroSerie         VARCHAR(15),
CONSTRAINT pk_servidores PRIMARY KEY (NumeroSerie),
CONSTRAINT fk_servidores FOREIGN KEY (NumeroSerie) REFERENCES ORDENADORES(NumeroSerie)
);

// Insertamos SERVIDORES

INSERT INTO SERVIDORES values('SS-00001-S-01');
INSERT INTO SERVIDORES values('SS-00002-S-02');
INSERT INTO SERVIDORES values('SS-00003-S-03');
INSERT INTO SERVIDORES values('SS-00004-S-04');
INSERT INTO SERVIDORES values('SS-00005-S-05');
INSERT INTO SERVIDORES values('SS-00006-S-06');



create table USUARIOS(
Nombre              VARCHAR(20),
Contrasena          VARCHAR(20) CONSTRAINT contrasenanonula NOT NULL,
NombreReal          VARCHAR(20) CONSTRAINT nombrerealnonulo NOT NULL,
Apellidos           VARCHAR(40) CONSTRAINT apellidos NOT NULL,
CorreoElectronico   VARCHAR(40) CONSTRAINT correononulo NOT NULL,
Ciudad              VARCHAR(20),
CONSTRAINT pk_usuarios PRIMARY KEY (Nombre),
CONSTRAINT contrasena10 CHECK(LENGTH(Contrasena) >= 10),
CONSTRAINT formatocorreo CHECK(CorreoElectronico ~ '^.+@.+\.(com|es|org|edu|net|gov|info|fr|pt)$'),
CONSTRAINT ciudadpais CHECK(Ciudad ~ '^.+ \((España|Portugal|Francia)\)$'),
CONSTRAINT correounico UNIQUE (CorreoElectronico)
);

// Insertamos USUARIOS

INSERT INTO USUARIOS values('fran.huzon','1q2w3e4r5t','Francisco Jesús','Huzón Villar','franhuzon@gmail.com','Sevilla (España)');
INSERT INTO USUARIOS values('paco.garcia','1234567890','Francisco','García Fernández','pacog1@hotmail.es','Lagos (Portugal)');
INSERT INTO USUARIOS values('josedom24','1a2b3c4d5e','Jose Domingo','Muñoz Rodríguez','josedom24@gmail.com','Utrera (España)');
INSERT INTO USUARIOS values('rruizpadi','M@ri@DB4ever','Raúl','Ruiz Padilla','rruiz@gmail.com','Sevilla (España)');
INSERT INTO USUARIOS values('AnAcLeTo','b1c1clet@s','Rodrigo','Moreno Ruedas','rodrimorerue@netmail.net','París (Francia)');
INSERT INTO USUARIOS values('pepe perez','23-junio-85','Juan','Pérez Pérez','eldeejemplo@orgmail.org','Portimao (Portugal)');
INSERT INTO USUARIOS values('juana_la_loca','felipe_hermoso_mio','Juana','Princesa Católica','juana@edumail.edu','Aragón (España)');
INSERT INTO USUARIOS values('Rosa_FOL','@@@ROSA@@@','Rosa','López de España','eurovision@infomail.info','Teruel (España)');



create table INCIDENCIAS(
Numero                      VARCHAR(10),               
NombreUsuarioResponsable    VARCHAR(20),
NumeroSerieOrdenador        VARCHAR(15),
Descripcion                 VARCHAR(50),
FechaHoraNotificacion       TIMESTAMP,
FechaHoraResolucion         TIMESTAMP,
CONSTRAINT pk_incidencias PRIMARY KEY (Numero),
CONSTRAINT fk_nombreusuario FOREIGN KEY (NombreUsuarioResponsable) REFERENCES USUARIOS(Nombre),
CONSTRAINT fk_ordenadores FOREIGN KEY (NumeroSerieOrdenador) REFERENCES ORDENADORES(NumeroSerie),
CONSTRAINT horario CHECK((TO_CHAR(FechaHoraNotificacion,'HH24:MI') BETWEEN '09:00' AND '14:00') OR (TO_CHAR(FechaHoraNotificacion,'HH24:MI') BETWEEN '17:00' AND '20:00')),
CONSTRAINT dia CHECK(TO_CHAR(FechaHoraNotificacion,'D')-1 in ('1','2','3','4','5')) 
);

// Insertamos INCIDENCIAS

INSERT INTO INCIDENCIAS values('01','josedom24','SS-00003-S-03','Cable ethernet suelto','08/01/2003 09:00','08/01/2003 09:20');
INSERT INTO INCIDENCIAS values('02','pepe perez','AA-00001-A-01','No arranca sistema por fallo al particionar','09/02/2004 09:10','09/02/2004 09:40');
INSERT INTO INCIDENCIAS values('03','rruizpadi','DD-00001-D-01','Cable ethernet roto','10/03/2005 09:20','10/03/2005 09:30');
INSERT INTO INCIDENCIAS values('04','josedom24','SS-00002-S-02','Desconfiguración de las tarjetas de red','11/04/2006 09:30','11/04/2006 13:10');
INSERT INTO INCIDENCIAS values('05','rruizpadi','DD-00002-D-02','Conflictos de IP por varios DHCPs activos','08/05/2007 09:40','08/05/2007 10:00');
INSERT INTO INCIDENCIAS values('06','pepe perez','AA-00002-A-02','Cable ethernet suelto','12/06/2008 09:50','12/06/2008 09:55');
INSERT INTO INCIDENCIAS values('07','josedom24','SS-00001-S-01','Desconfiguración del fichero sources.list','14/09/2009 10:00','14/09/2009 10:20');
INSERT INTO INCIDENCIAS values('08','josedom24','SS-00004-S-04','Cable ethernet suelto','14/10/2010 10:10','14/10/2010 10:15');
INSERT INTO INCIDENCIAS values('09','rruizpadi','DD-00003-D-03','Mal apagado del sistema','16/11/2011 10:20','16/11/2011 10:50');
INSERT INTO INCIDENCIAS values('10','pepe perez','AA-00003-A-03','Cable ethernet suelto','17/12/2012 10:30','17/12/2012 10:35');
INSERT INTO INCIDENCIAS values('11','josedom24','SS-00005-S-05','Cable ethernet defectuoso','17/01/2013 10:40','17/01/2013 10:45');
INSERT INTO INCIDENCIAS values('12','rruizpadi','DD-00001-D-01','Desconfiguración de la tarjeta de red','19/02/2014 10:50','19/02/2014 11:20');
INSERT INTO INCIDENCIAS values('13','pepe perez','AA-00001-A-01','Rotura de carcasa por caída','19/03/2015 11:00','19/03/2015 13:59');
INSERT INTO INCIDENCIAS values('14','josedom24','SS-00006-S-06','Cable ethernet suelto','21/04/2016 11:10','21/04/2016 11:15');
INSERT INTO INCIDENCIAS values('15','rruizpadi','DD-00002-D-02','Cable ethernet defectuoso','22/05/2017 11:20','22/05/2017 11:30');
INSERT INTO INCIDENCIAS values('16','pepe perez','AA-00002-A-02','No arranca el sistema por fallo al particionar','24/06/2002 11:30','24/06/2002 12:40');
INSERT INTO INCIDENCIAS values('17','josedom24','SS-00001-S-01','Desconfiguración del fichero sources.list','23/09/2003 11:40','23/09/2003 12:00');
INSERT INTO INCIDENCIAS values('18','rruizpadi','DD-00003-D-03','Cable ethernet suelto','24/10/2004 11:50','24/10/2004 11:55');
INSERT INTO INCIDENCIAS values('19','pepe perez','AA-00003-A-03','Cable ethernet roto','27/11/2005 12:00','27/11/2005 12:10');
INSERT INTO INCIDENCIAS values('20','josedom24','SS-00002-S-02','Mal apagado del sistema','29/01/2006 12:10','29/01/2006 12:50');
INSERT INTO INCIDENCIAS values('21','rruizpadi','DD-00001-D-01','Cable ethernet suelto','28/02/2007 12:20','28/02/2007 12:25');
INSERT INTO INCIDENCIAS values('22','pepe perez','AA-00001-A-01','Rotura de pantalla por caída','27/03/2008 12:30','27/03/2008 13:30');
INSERT INTO INCIDENCIAS values('23','josedom24','SS-00003-S-03','Cable ethernet suelto','30/04/2009 12:40','30/04/2009 12:45');
INSERT INTO INCIDENCIAS values('24','rruizpadi','DD-00002-D-02','Cable ethernet mal estado','31/05/2010 12:50','31/05/2010 13:00');
INSERT INTO INCIDENCIAS values('25','pepe perez','AA-00002-A-02','Rotura de pantalla por caída','01/06/2011 13:00','01/06/2011 14:00');
INSERT INTO INCIDENCIAS values('26','josedom24','SS-00004-S-04','Cable ethernet suelto','03/09/2012 13:10','03/09/2012 13:15');
INSERT INTO INCIDENCIAS values('27','rruizpadi','DD-00003-D-03','Conflictos de IP por varios DHCPs activos','03/10/2013 19:20','03/10/2013 20:20');
INSERT INTO INCIDENCIAS values('28','pepe perez','AA-00003-A-03','Fallo en el disco duro','04/11/2014 18:30','04/11/2014 19:30');
INSERT INTO INCIDENCIAS values('29','josedom24','SS-00005-S-05','Desconfiguración de las tarjetas de red','03/12/2015 17:40','03/12/2015 18:10');
INSERT INTO INCIDENCIAS values('30','rruizpadi','DD-00001-D-01','Conflictos de IP por varios DHCPs activos','04/02/2016 20:00','05/02/2016 09:50');


create table VERSIONESSO(
Codigo      VARCHAR(15),
Nombre      VARCHAR(20) NOT NULL,
CONSTRAINT pk_versionesso PRIMARY KEY (Codigo),
CONSTRAINT inicialmayus CHECK(Nombre = INITCAP(Nombre))
);

// Insertamos VERSIONESSO

INSERT INTO VERSIONESSO values('Ubuntu18.10','Ubuntu');
INSERT INTO VERSIONESSO values('Debian9.0','Debian Stretch');
INSERT INTO VERSIONESSO values('Debian8.0','Debian Jessie');
INSERT INTO VERSIONESSO values('WXP','Windows Xp');
INSERT INTO VERSIONESSO values('W7','Windows Siete');
INSERT INTO VERSIONESSO values('W10','Windows Diez');
INSERT INTO VERSIONESSO values('WS2003','Windows Server');
INSERT INTO VERSIONESSO values('WS2012','Windows Server');
INSERT INTO VERSIONESSO values('WS2016','Windows Server');
INSERT INTO VERSIONESSO values('Fedora22','Fedora');
INSERT INTO VERSIONESSO values('CentOS7','Cent Os');



create table SISTEMAS_OPERATIVOS_INSTALADOS(
NumeroSerieServidor     VARCHAR(15),
CodigoVersion           VARCHAR(10),
FechaInstalacion        TIMESTAMP,
FechaRetirada           TIMESTAMP,
CONSTRAINT pk_sistemas PRIMARY KEY (NumeroSerieServidor, CodigoVersion, FechaInstalacion),
CONSTRAINT fk_servidores2 FOREIGN KEY (NumeroSerieServidor) REFERENCES SERVIDORES(NumeroSerie),
CONSTRAINT fk_versionesso FOREIGN KEY (CodigoVersion) REFERENCES VERSIONESSO(Codigo),
CONSTRAINT fechainstalacioncorrecta CHECK((TO_CHAR(FechaInstalacion,'MM')!='07') AND (TO_CHAR(FechaInstalacion,'MM')!='08'))
);

// Insertamos SISTEMAS_OPERATIVOS_INSTALADOS

INSERT INTO SISTEMAS_OPERATIVOS_INSTALADOS values('SS-00001-S-01','Debian8.0','01/05/2015','16/09/2016');
INSERT INTO SISTEMAS_OPERATIVOS_INSTALADOS(NumeroSerieServidor,CodigoVersion,FechaInstalacion) values('SS-00001-S-01','Debian9.0','17/09/2016');
INSERT INTO SISTEMAS_OPERATIVOS_INSTALADOS values('SS-00002-S-02','WXP','08/01/2002','20/06/2009');
INSERT INTO SISTEMAS_OPERATIVOS_INSTALADOS values('SS-00002-S-02','W7','21/09/2009','15/01/2016');
INSERT INTO SISTEMAS_OPERATIVOS_INSTALADOS(NumeroSerieServidor,CodigoVersion,FechaInstalacion) values('SS-00002-S-02','W10','16/01/2016');
INSERT INTO SISTEMAS_OPERATIVOS_INSTALADOS values('SS-00003-S-03','WS2003','30/06/2003','16/09/2012');
INSERT INTO SISTEMAS_OPERATIVOS_INSTALADOS values('SS-00003-S-03','WS2012','04/10/2012','10/12/2016');
INSERT INTO SISTEMAS_OPERATIVOS_INSTALADOS(NumeroSerieServidor,CodigoVersion,FechaInstalacion) values('SS-00003-S-03','WS2016','11/12/2016');
INSERT INTO SISTEMAS_OPERATIVOS_INSTALADOS values('SS-00004-S-04','Fedora22','04/05/2015','10/12/2015');
INSERT INTO SISTEMAS_OPERATIVOS_INSTALADOS values('SS-00004-S-04','Debian8.0','11/12/2015','16/01/2017');
INSERT INTO SISTEMAS_OPERATIVOS_INSTALADOS(NumeroSerieServidor,CodigoVersion,FechaInstalacion) values('SS-00004-S-04','Debian9.0','17/01/2017');
INSERT INTO SISTEMAS_OPERATIVOS_INSTALADOS values('SS-00005-S-05','CentOS7','04/05/2012','07/06/2015');
INSERT INTO SISTEMAS_OPERATIVOS_INSTALADOS values('SS-00005-S-05','Debian8.0','08/06/2015','28/11/2017');
INSERT INTO SISTEMAS_OPERATIVOS_INSTALADOS(NumeroSerieServidor,CodigoVersion,FechaInstalacion) values('SS-00005-S-05','Debian9.0','29/11/2017');
INSERT INTO SISTEMAS_OPERATIVOS_INSTALADOS values('SS-00006-S-06','WS2003','26/03/2009','11/06/2013');
INSERT INTO SISTEMAS_OPERATIVOS_INSTALADOS(NumeroSerieServidor,CodigoVersion,FechaInstalacion) values('SS-00006-S-06','WS2012','12/06/2013');



create table PERIODOSDEAPAGADO(
FechaHoraInicio         TIMESTAMP,
NumeroSerieServidor     VARCHAR(15),
FechaHoraFin            TIMESTAMP,
Motivo                  VARCHAR(45) NOT NULL,
CONSTRAINT pk_periodosapagados PRIMARY KEY (FechaHoraInicio, NumeroSerieServidor),
CONSTRAINT fk_servidores3 FOREIGN KEY (NumeroSerieServidor) REFERENCES SERVIDORES(NumeroSerie),
CONSTRAINT motivo CHECK(Motivo IN ('Tareas de Mantenimiento', 'Interrupcion de Suministro Electrico', 'Averia Hardware'))
);

// Insertamos PERIODOSDEAPAGADO

INSERT INTO PERIODOSDEAPAGADO values('10/04/2002 10:23','SS-00002-S-02','10/04/2002 11:53','Interrupcion de Suministro Electrico');
INSERT INTO PERIODOSDEAPAGADO values('24/09/2002 11:35','SS-00001-S-01','24/09/2002 12:35','Tareas de Mantenimiento');
INSERT INTO PERIODOSDEAPAGADO values('08/01/2003 09:18','SS-00003-S-03','08/01/2003 09:30','Averia Hardware');
INSERT INTO PERIODOSDEAPAGADO values('12/12/2003 14:11','SS-00006-S-06','12/12/2003 14:16','Interrupcion de Suministro Electrico');
INSERT INTO PERIODOSDEAPAGADO values('28/02/2004 10:45','SS-00005-S-05','28/02/2004 11:15','Tareas de Mantenimiento');
INSERT INTO PERIODOSDEAPAGADO values('25/11/2004 19:37','SS-00006-S-06','26/11/2004 09:10','Averia Hardware');
INSERT INTO PERIODOSDEAPAGADO values('02/04/2005 12:12','SS-00002-S-02','02/04/2005 12:32','Interrupcion de Suministro Electrico');
INSERT INTO PERIODOSDEAPAGADO values('25/11/2005 14:21','SS-00006-S-06','25/11/2005 13:30','Tareas de Mantenimiento');
INSERT INTO PERIODOSDEAPAGADO values('04/03/2006 21:12','SS-00004-S-04','05/03/2006 11:01','Averia Hardware');
INSERT INTO PERIODOSDEAPAGADO values('26/04/2006 10:21','SS-00002-S-02','26/04/2006 10:23','Interrupcion de Suministro Electrico');
INSERT INTO PERIODOSDEAPAGADO values('25/11/2006 10:17','SS-00006-S-06','25/11/2006 12:17','Tareas de Mantenimiento');
INSERT INTO PERIODOSDEAPAGADO values('30/05/2007 11:12','SS-00005-S-05','30/05/2007 11:52','Averia Hardware');
INSERT INTO PERIODOSDEAPAGADO values('15/06/2007 19:52','SS-00006-S-06','15/06/2007 20:11','Interrupcion de Suministro Electrico');
INSERT INTO PERIODOSDEAPAGADO values('07/03/2008 18:31','SS-00001-S-01','07/03/2008 20:30','Tareas de Mantenimiento');
INSERT INTO PERIODOSDEAPAGADO values('03/03/2009 08:00','SS-00004-S-04','03/03/2009 14:00','Averia Hardware');
INSERT INTO PERIODOSDEAPAGADO values('08/01/2009 16:17','SS-00003-S-03','08/01/2009 16:22','Interrupcion de Suministro Electrico');
INSERT INTO PERIODOSDEAPAGADO values('10/06/2010 22:24','SS-00003-S-03','10/06/2010 23:18','Tareas de Mantenimiento');
INSERT INTO PERIODOSDEAPAGADO values('15/06/2010 20:40','SS-00003-S-03','17/06/2010 10:00','Averia Hardware');
INSERT INTO PERIODOSDEAPAGADO values('23/10/2011 19:58','SS-00001-S-01','24/10/2011 00:05','Interrupcion de Suministro Electrico');
INSERT INTO PERIODOSDEAPAGADO values('22/11/2011 21:30','SS-00003-S-03','22/11/2011 21:45','Tareas de Mantenimiento');
INSERT INTO PERIODOSDEAPAGADO values('03/05/2012 23:12','SS-00001-S-01','04/05/2012 09:26','Averia Hardware');
INSERT INTO PERIODOSDEAPAGADO values('17/01/2013 16:23','SS-00002-S-02','17/01/2013 17:03','Interrupcion de Suministro Electrico');
INSERT INTO PERIODOSDEAPAGADO values('25/11/2013 08:34','SS-00006-S-06','25/11/2013 09:34','Tareas de Mantenimiento');
INSERT INTO PERIODOSDEAPAGADO values('27/02/2015 08:42','SS-00006-S-06','27/02/2015 09:02','Averia Hardware');
INSERT INTO PERIODOSDEAPAGADO values('10/03/2017 12:00','SS-00003-S-03','10/03/2017 12:40','Interrupcion de Suministro Electrico');



create table SERVICIOS(
Nombre      VARCHAR(25),
Descripcion VARCHAR(120),
CONSTRAINT pk_servicios PRIMARY KEY (Nombre)
);

// Insertamos SERVICIOS

INSERT INTO SERVICIOS values('DNS','Resuelve el nombre de las redes relacionándolas con su IP.');
INSERT INTO SERVICIOS values('Correo','Presta servicio de correo electrónico entre servidores usando el protocolo SMTP.');
INSERT INTO SERVICIOS values('Web','Recibe peticiones de un cliente y proporciona una respuesta rederizada en un navegador web usando el protocolo HTTP.');
INSERT INTO SERVICIOS values('DHCP','Asigna direcciones IP al resto de máquinas de forma automática.');
INSERT INTO SERVICIOS values('Base de datos','Almacena, modifica y extrae información de la base de datos.');
INSERT INTO SERVICIOS values('Seguridad','Protege el sistema de intrusiones no deseadas.');
INSERT INTO SERVICIOS values('FTP','Permite el desplazamiento de datos entre diferentes máquinas.');
INSERT INTO SERVICIOS values('SSH','Controla las líneas de módem de la red para que las peticiones conecten con la red de una posición remota.');



create table SERVICIOSINSTALADOS(
NumeroSerieServidor     VARCHAR(15),
NombreServicio          VARCHAR(20),
FechaInico              TIMESTAMP,
FechaFin                TIMESTAMP,
CONSTRAINT pk_serviciosinstalados PRIMARY KEY (NumeroSerieServidor, NombreServicio),
CONSTRAINT fk_servidores4 FOREIGN KEY (NumeroSerieServidor) REFERENCES SERVIDORES(NumeroSerie),
CONSTRAINT fk_servicios FOREIGN KEY (NombreServicio) REFERENCES SERVICIOS(Nombre)
);

// Insertamos SERVICIOSINSTALADOS

INSERT INTO SERVICIOSINSTALADOS values('SS-00001-S-01','DHCP','10/04/2005','25/04/20011');
INSERT INTO SERVICIOSINSTALADOS values('SS-00001-S-01','DNS','02/05/2015','16/09/2016');
INSERT INTO SERVICIOSINSTALADOS(NumeroSerieServidor,NombreServicio,FechaInico) values('SS-00001-S-01','SSH','16/09/2016');
INSERT INTO SERVICIOSINSTALADOS values('SS-00001-S-01','Web','06/11/2002','24/09/2006');
INSERT INTO SERVICIOSINSTALADOS values('SS-00001-S-01','Correo','30/10/2008','16/09/2011');
INSERT INTO SERVICIOSINSTALADOS values('SS-00002-S-02','Correo','25/05/2015','16/09/2016');
INSERT INTO SERVICIOSINSTALADOS(NumeroSerieServidor,NombreServicio,FechaInico) values('SS-00002-S-02','DNS','17/09/2016');
INSERT INTO SERVICIOSINSTALADOS values('SS-00003-S-03','Base de datos','29/05/2003','28/02/2009');
INSERT INTO SERVICIOSINSTALADOS values('SS-00003-S-03','Correo','20/11/2016','23/06/2017');
INSERT INTO SERVICIOSINSTALADOS values('SS-00003-S-03','DHCP','05/04/2010','16/09/2016');
INSERT INTO SERVICIOSINSTALADOS values('SS-00003-S-03','SSH','17/09/2015','16/09/2016');
INSERT INTO SERVICIOSINSTALADOS values('SS-00004-S-04','DNS','10/06/2016','16/10/2016');
INSERT INTO SERVICIOSINSTALADOS values('SS-00004-S-04','FTP','16/09/2016','20/11/2016');
INSERT INTO SERVICIOSINSTALADOS(NumeroSerieServidor,NombreServicio,FechaInico) values('SS-00004-S-04','SSH','17/09/2016');
INSERT INTO SERVICIOSINSTALADOS values('SS-00004-S-04','Web','12/12/2015','06/12/2017');
INSERT INTO SERVICIOSINSTALADOS values('SS-00005-S-05','Base de datos','29/04/2008','23/02/2010');
INSERT INTO SERVICIOSINSTALADOS values('SS-00005-S-05','DHCP','02/05/2015','16/09/2016');
INSERT INTO SERVICIOSINSTALADOS values('SS-00005-S-05','Seguridad','03/04/2013','15/10/2014');
INSERT INTO SERVICIOSINSTALADOS(NumeroSerieServidor,NombreServicio,FechaInico) values('SS-00006-S-06','Correo','19/06/2008');
INSERT INTO SERVICIOSINSTALADOS(NumeroSerieServidor,NombreServicio,FechaInico) values('SS-00006-S-06','Seguridad','10/04/2007');