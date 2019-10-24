create table Ordenadores(
NumeroSerie         VARCHAR2(15),
CONSTRAINT pk_Ordenadores PRIMARY KEY (NumeroSerie)
);

// Insertamos datos Ordenadores

INSERT INTO Ordenadores values('SS-00001-S-01');
INSERT INTO Ordenadores values('SS-00002-S-02');
INSERT INTO Ordenadores values('SS-00003-S-03');
INSERT INTO Ordenadores values('SS-00004-S-04');
INSERT INTO Ordenadores values('SS-00005-S-05');
INSERT INTO Ordenadores values('SS-00006-S-06');
INSERT INTO Ordenadores values('AA-00001-A-01');
INSERT INTO Ordenadores values('AA-00002-A-02');
INSERT INTO Ordenadores values('AA-00003-A-03');
INSERT INTO Ordenadores values('DD-00001-D-01');
INSERT INTO Ordenadores values('DD-00002-D-02');
INSERT INTO Ordenadores values('DD-00003-D-03');



create table Servidores(
NumeroSerie         VARCHAR2(15),
CONSTRAINT pk_servidores PRIMARY KEY (NumeroSerie),
CONSTRAINT fk_servidores FOREIGN KEY (NumeroSerie) REFERENCES Ordenadores(NumeroSerie)
);

// Insertamos Servidores

INSERT INTO Servidores values('SS-00001-S-01');
INSERT INTO Servidores values('SS-00002-S-02');
INSERT INTO Servidores values('SS-00003-S-03');
INSERT INTO Servidores values('SS-00004-S-04');
INSERT INTO Servidores values('SS-00005-S-05');
INSERT INTO Servidores values('SS-00006-S-06');



create table Usuarios(
Nombre              VARCHAR2(20),
Contrasena          VARCHAR2(20) CONSTRAINT contrasenanonula NOT NULL,
NombreReal          VARCHAR2(20) CONSTRAINT nombrerealnonulo NOT NULL,
Apellidos           VARCHAR2(40) CONSTRAINT apellidos NOT NULL,
CorreoElectronico   VARCHAR2(40) CONSTRAINT correononulo NOT NULL,
Ciudad              VARCHAR2(20),
CONSTRAINT pk_usuarios PRIMARY KEY (Nombre)
);

// Insertamos Usuarios

INSERT INTO Usuarios values('fran.huzon','1q2w3e4r5t','Francisco Jesús','Huzón Villar','franhuzon@gmail.com','Sevilla (España)');
INSERT INTO Usuarios values('paco.garcia','1234567890','Francisco','García Fernández','pacog1@hotmail.es','Lagos (Portugal)');
INSERT INTO Usuarios values('josedom24','1a2b3c4d5e','Jose Domingo','Muñoz Rodríguez','josedom24@gmail.com','Utrera (España)');
INSERT INTO Usuarios values('rruizpadi','M@ri@DB4ever','Raúl','Ruiz Padilla','rruiz@gmail.com','Sevilla (España)');
INSERT INTO Usuarios values('AnAcLeTo','b1c1clet@s','Rodrigo','Moreno Ruedas','rodrimorerue@netmail.net','París (Francia)');
INSERT INTO Usuarios values('pepe perez','23-junio-85','Juan','Pérez Pérez','eldeejemplo@orgmail.org','Portimao (Portugal)');
INSERT INTO Usuarios values('juana_la_loca','felipe_hermoso_mio','Juana','Princesa Católica','juana@edumail.edu','Aragón (España)');
INSERT INTO Usuarios values('Rosa_FOL','@@@ROSA@@@','Rosa','López de España','eurovision@infomail.info','Teruel (España)');



create table Incidencias(
Numero                      VARCHAR2(10),               
NombreUsuarioResponsable    VARCHAR2(20),
NumeroSerieOrdenador        VARCHAR2(15),
Descripcion                 VARCHAR2(50),
FechaHoraNotificacion       DATE,
FechaHoraResolucion         DATE,
CONSTRAINT pk_incidencias PRIMARY KEY (Numero),
CONSTRAINT fk_nombreusuario FOREIGN KEY (NombreUsuarioResponsable) REFERENCES Usuarios(Nombre),
CONSTRAINT fk_ordenadores FOREIGN KEY (NumeroSerieOrdenador) REFERENCES ORDENADORES(NumeroSerie)
);

// Insertamos Incidencias

INSERT INTO Incidencias values('01','josedom24','SS-00003-S-03','Cable ethernet suelto',TO_DATE('08/01/2003 09:00','DD/MM/YYYY HH24:MI'),TO_DATE('08/01/2003 09:20','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('02','pepe perez','AA-00001-A-01','No arranca sistema por fallo al particionar',TO_DATE('09/02/2004 09:10','DD/MM/YYYY HH24:MI'),TO_DATE('09/02/2004 09:40','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('03','rruizpadi','DD-00001-D-01','Cable ethernet roto',TO_DATE('10/03/2005 09:20','DD/MM/YYYY HH24:MI'),TO_DATE('10/03/2005 09:30','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('04','josedom24','SS-00002-S-02','Desconfiguración de las tarjetas de red',TO_DATE('11/04/2006 09:30','DD/MM/YYYY HH24:MI'),TO_DATE('11/04/2006 13:10','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('05','rruizpadi','DD-00002-D-02','Conflictos de IP por varios DHCPs activos',TO_DATE('08/05/2007 09:40','DD/MM/YYYY HH24:MI'),TO_DATE('08/05/2007 10:00','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('06','pepe perez','AA-00002-A-02','Cable ethernet suelto',TO_DATE('12/06/2008 09:50','DD/MM/YYYY HH24:MI'),TO_DATE('12/06/2008 09:55','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('07','josedom24','SS-00001-S-01','Desconfiguración del fichero sources.list',TO_DATE('14/09/2009 10:00','DD/MM/YYYY HH24:MI'),TO_DATE('14/09/2009 10:20','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('08','josedom24','SS-00004-S-04','Cable ethernet suelto',TO_DATE('14/10/2010 10:10','DD/MM/YYYY HH24:MI'),TO_DATE('14/10/2010 10:15','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('09','rruizpadi','DD-00003-D-03','Mal apagado del sistema',TO_DATE('16/11/2011 10:20','DD/MM/YYYY HH24:MI'),TO_DATE('16/11/2011 10:50','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('10','pepe perez','AA-00003-A-03','Cable ethernet suelto',TO_DATE('17/12/2012 10:30','DD/MM/YYYY HH24:MI'),TO_DATE('17/12/2012 10:35','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('11','josedom24','SS-00005-S-05','Cable ethernet defectuoso',TO_DATE('17/01/2013 10:40','DD/MM/YYYY HH24:MI'),TO_DATE('17/01/2013 10:45','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('12','rruizpadi','DD-00001-D-01','Desconfiguración de la tarjeta de red',TO_DATE('19/02/2014 10:50','DD/MM/YYYY HH24:MI'),TO_DATE('19/02/2014 11:20','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('13','pepe perez','AA-00001-A-01','Rotura de carcasa por caída',TO_DATE('19/03/2015 11:00','DD/MM/YYYY HH24:MI'),TO_DATE('19/03/2015 13:59','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('14','josedom24','SS-00006-S-06','Cable ethernet suelto',TO_DATE('21/04/2016 11:10','DD/MM/YYYY HH24:MI'),TO_DATE('21/04/2016 11:15','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('15','rruizpadi','DD-00002-D-02','Cable ethernet defectuoso',TO_DATE('22/05/2017 11:20','DD/MM/YYYY HH24:MI'),TO_DATE('22/05/2017 11:30','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('16','pepe perez','AA-00002-A-02','No arranca el sistema por fallo al particionar',TO_DATE('24/06/2002 11:30','DD/MM/YYYY HH24:MI'),TO_DATE('24/06/2002 12:40','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('17','josedom24','SS-00001-S-01','Desconfiguración del fichero sources.list',TO_DATE('23/09/2003 11:40','DD/MM/YYYY HH24:MI'),TO_DATE('23/09/2003 12:00','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('18','rruizpadi','DD-00003-D-03','Cable ethernet suelto',TO_DATE('24/10/2004 11:50','DD/MM/YYYY HH24:MI'),TO_DATE('24/10/2004 11:55','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('19','pepe perez','AA-00003-A-03','Cable ethernet roto',TO_DATE('27/11/2005 12:00','DD/MM/YYYY HH24:MI'),TO_DATE('27/11/2005 12:10','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('20','josedom24','SS-00002-S-02','Mal apagado del sistema',TO_DATE('29/01/2006 12:10','DD/MM/YYYY HH24:MI'),TO_DATE('29/01/2006 12:50','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('21','rruizpadi','DD-00001-D-01','Cable ethernet suelto',TO_DATE('28/02/2007 12:20','DD/MM/YYYY HH24:MI'),TO_DATE('28/02/2007 12:25','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('22','pepe perez','AA-00001-A-01','Rotura de pantalla por caída',TO_DATE('27/03/2008 12:30','DD/MM/YYYY HH24:MI'),TO_DATE('27/03/2008 13:30','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('23','josedom24','SS-00003-S-03','Cable ethernet suelto',TO_DATE('30/04/2009 12:40','DD/MM/YYYY HH24:MI'),TO_DATE('30/04/2009 12:45','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('24','rruizpadi','DD-00002-D-02','Cable ethernet mal estado',TO_DATE('31/05/2010 12:50','DD/MM/YYYY HH24:MI'),TO_DATE('31/05/2010 13:00','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('25','pepe perez','AA-00002-A-02','Rotura de pantalla por caída',TO_DATE('01/06/2011 13:00','DD/MM/YYYY HH24:MI'),TO_DATE('01/06/2011 14:00','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('26','josedom24','SS-00004-S-04','Cable ethernet suelto',TO_DATE('03/09/2012 13:10','DD/MM/YYYY HH24:MI'),TO_DATE('03/09/2012 13:15','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('27','rruizpadi','DD-00003-D-03','Conflictos de IP por varios DHCPs activos',TO_DATE('03/10/2013 19:20','DD/MM/YYYY HH24:MI'),TO_DATE('03/10/2013 20:20','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('28','pepe perez','AA-00003-A-03','Fallo en el disco duro',TO_DATE('04/11/2014 18:30','DD/MM/YYYY HH24:MI'),TO_DATE('04/11/2014 19:30','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('29','josedom24','SS-00005-S-05','Desconfiguración de las tarjetas de red',TO_DATE('03/12/2015 17:40','DD/MM/YYYY HH24:MI'),TO_DATE('04/12/2015 18:10','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('30','rruizpadi','DD-00001-D-01','Conflictos de IP por varios DHCPs activos',TO_DATE('04/02/2016 20:00','DD/MM/YYYY HH24:MI'),TO_DATE('06/02/2016 09:50','DD/MM/YYYY HH24:MI'));
INSERT INTO Incidencias values('31','fran.huzon','DD-00001-D-01','Conflictos de IP por varios DHCPs activos',TO_DATE('04/02/2016 20:00','DD/MM/YYYY HH24:MI'),TO_DATE('06/02/2016 09:50','DD/MM/YYYY HH24:MI'));


create table VersionesSO(
Codigo      VARCHAR2(15),
Nombre      VARCHAR2(20) CONSTRAINT nombrenonulo NOT NULL,
CONSTRAINT pk_versionesso PRIMARY KEY (Codigo),
);

// Insertamos VersionesSO

INSERT INTO VersionesSO values('Ubuntu18.10','Ubuntu');
INSERT INTO VersionesSO values('Debian9.0','Debian Stretch');
INSERT INTO VersionesSO values('Debian8.0','Debian Jessie');
INSERT INTO VersionesSO values('WXP','Windows Xp');
INSERT INTO VersionesSO values('W7','Windows Siete');
INSERT INTO VersionesSO values('W10','Windows Diez');
INSERT INTO VersionesSO values('WS2003','Windows Server ');
INSERT INTO VersionesSO values('WS2012','Windows Server');
INSERT INTO VersionesSO values('WS2016','Windows Server');
INSERT INTO VersionesSO values('Fedora22','Fedora');
INSERT INTO VersionesSO values('CentOS7','Cent Os');



create table Sistemas_Operativos_Instalados(
NumeroSerieServidor     VARCHAR2(15),
CodigoVersion           VARCHAR2(10),
FechaInstalacion        DATE,
FechaRetirada           DATE,
CONSTRAINT pk_sistemas PRIMARY KEY (NumeroSerieServidor, CodigoVersion, FechaInstalacion),
CONSTRAINT fk_servidores2 FOREIGN KEY (NumeroSerieServidor) REFERENCES Servidores(NumeroSerie),
CONSTRAINT fk_versionesso FOREIGN KEY (CodigoVersion) REFERENCES VersionesSO(Codigo)
);

// Insertamos Sistemas_Operativos_Instalados

INSERT INTO Sistemas_Operativos_Instalados values('SS-00001-S-01','Debian8.0',TO_DATE('01/05/2015','DD/MM/YYYY'),TO_DATE('16/09/2016','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados(NumeroSerieServidor,CodigoVersion,FechaInstalacion) values('SS-00001-S-01','Debian9.0',TO_DATE('17/09/2016','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados values('SS-00002-S-02','WXP',TO_DATE('08/01/2002','DD/MM/YYYY'),TO_DATE('20/06/2009','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados values('SS-00002-S-02','W7',TO_DATE('21/09/2009','DD/MM/YYYY'),TO_DATE('15/01/2016','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados(NumeroSerieServidor,CodigoVersion,FechaInstalacion) values('SS-00002-S-02','W10',TO_DATE('16/01/2016','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados values('SS-00003-S-03','WS2003',TO_DATE('30/06/2003','DD/MM/YYYY'),TO_DATE('16/09/2012','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados values('SS-00003-S-03','WS2012',TO_DATE('04/10/2012','DD/MM/YYYY'),TO_DATE('10/12/2016','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados(NumeroSerieServidor,CodigoVersion,FechaInstalacion) values('SS-00003-S-03','WS2016',TO_DATE('11/12/2016','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados values('SS-00004-S-04','Fedora22',TO_DATE('04/05/2015','DD/MM/YYYY'),TO_DATE('10/12/2015','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados values('SS-00004-S-04','Debian8.0',TO_DATE('11/12/2015','DD/MM/YYYY'),TO_DATE('16/01/2017','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados(NumeroSerieServidor,CodigoVersion,FechaInstalacion) values('SS-00004-S-04','Debian9.0',TO_DATE('17/01/2017','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados values('SS-00005-S-05','CentOS7',TO_DATE('04/05/2012','DD/MM/YYYY'),TO_DATE('07/06/2015','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados values('SS-00005-S-05','Debian8.0',TO_DATE('08/06/2015','DD/MM/YYYY'),TO_DATE('28/11/2017','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados(NumeroSerieServidor,CodigoVersion,FechaInstalacion) values('SS-00005-S-05','Debian9.0',TO_DATE('29/11/2017','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados values('SS-00006-S-06','WS2003',TO_DATE('26/03/2009','DD/MM/YYYY'),TO_DATE('11/06/2013','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados(NumeroSerieServidor,CodigoVersion,FechaInstalacion) values('SS-00006-S-06','WS2012',TO_DATE('12/06/2013','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados(NumeroSerieServidor,CodigoVersion,FechaInstalacion) values('SS-00006-S-06','Debian9.0',TO_DATE('13/06/2013','DD/MM/YYYY'));
INSERT INTO Sistemas_Operativos_Instalados(NumeroSerieServidor,CodigoVersion,FechaInstalacion) values('SS-00006-S-06','W10',TO_DATE('14/06/2013','DD/MM/YYYY'));



create table Periodosdeapagado(
FechaHoraInicio         DATE,
NumeroSerieServidor     VARCHAR2(15),
FechaHoraFin            DATE,
Motivo                  VARCHAR2(45) CONSTRAINT motivononulo NOT NULL,
CONSTRAINT pk_periodosapagados PRIMARY KEY (FechaHoraInicio, NumeroSerieServidor),
CONSTRAINT fk_servidores3 FOREIGN KEY (NumeroSerieServidor) REFERENCES Servidores(NumeroSerie)
);

// Insertamos Periodosdeapagado

INSERT INTO Periodosdeapagado values(TO_DATE('10/04/2002 10:23','DD/MM/YYYY HH24:MI'),'SS-00002-S-02',TO_DATE('10/04/2002 11:53','DD/MM/YYYY HH24:MI'),'Interrupcion de Suministro Electrico');
INSERT INTO Periodosdeapagado values(TO_DATE('24/09/2002 11:35','DD/MM/YYYY HH24:MI'),'SS-00001-S-01',TO_DATE('24/09/2002 12:35','DD/MM/YYYY HH24:MI'),'Tareas de Mantenimiento');
INSERT INTO Periodosdeapagado values(TO_DATE('08/01/2003 09:18','DD/MM/YYYY HH24:MI'),'SS-00003-S-03',TO_DATE('08/01/2003 09:30','DD/MM/YYYY HH24:MI'),'Averia Hardware');
INSERT INTO Periodosdeapagado values(TO_DATE('12/12/2003 14:11','DD/MM/YYYY HH24:MI'),'SS-00006-S-06',TO_DATE('12/12/2003 14:16','DD/MM/YYYY HH24:MI'),'Interrupcion de Suministro Electrico');
INSERT INTO Periodosdeapagado values(TO_DATE('28/02/2004 10:45','DD/MM/YYYY HH24:MI'),'SS-00005-S-05',TO_DATE('28/02/2004 11:15','DD/MM/YYYY HH24:MI'),'Tareas de Mantenimiento');
INSERT INTO Periodosdeapagado values(TO_DATE('25/11/2004 19:37','DD/MM/YYYY HH24:MI'),'SS-00006-S-06',TO_DATE('26/11/2004 09:10','DD/MM/YYYY HH24:MI'),'Averia Hardware');
INSERT INTO Periodosdeapagado values(TO_DATE('02/04/2005 12:12','DD/MM/YYYY HH24:MI'),'SS-00002-S-02',TO_DATE('02/04/2005 12:32','DD/MM/YYYY HH24:MI'),'Interrupcion de Suministro Electrico');
INSERT INTO Periodosdeapagado values(TO_DATE('25/11/2005 14:21','DD/MM/YYYY HH24:MI'),'SS-00006-S-06',TO_DATE('25/11/2005 13:30','DD/MM/YYYY HH24:MI'),'Tareas de Mantenimiento');
INSERT INTO Periodosdeapagado values(TO_DATE('04/03/2006 21:12','DD/MM/YYYY HH24:MI'),'SS-00004-S-04',TO_DATE('05/03/2006 11:01','DD/MM/YYYY HH24:MI'),'Averia Hardware');
INSERT INTO Periodosdeapagado values(TO_DATE('26/04/2006 10:21','DD/MM/YYYY HH24:MI'),'SS-00002-S-02',TO_DATE('26/04/2006 10:23','DD/MM/YYYY HH24:MI'),'Interrupcion de Suministro Electrico');
INSERT INTO Periodosdeapagado values(TO_DATE('25/11/2006 10:17','DD/MM/YYYY HH24:MI'),'SS-00006-S-06',TO_DATE('25/11/2006 12:17','DD/MM/YYYY HH24:MI'),'Tareas de Mantenimiento');
INSERT INTO Periodosdeapagado values(TO_DATE('30/05/2007 11:12','DD/MM/YYYY HH24:MI'),'SS-00005-S-05',TO_DATE('30/05/2007 11:52','DD/MM/YYYY HH24:MI'),'Averia Hardware');
INSERT INTO Periodosdeapagado values(TO_DATE('15/06/2007 19:52','DD/MM/YYYY HH24:MI'),'SS-00006-S-06',TO_DATE('15/06/2007 20:11','DD/MM/YYYY HH24:MI'),'Interrupcion de Suministro Electrico');
INSERT INTO Periodosdeapagado values(TO_DATE('07/03/2008 18:31','DD/MM/YYYY HH24:MI'),'SS-00001-S-01',TO_DATE('07/03/2008 20:30','DD/MM/YYYY HH24:MI'),'Tareas de Mantenimiento');
INSERT INTO Periodosdeapagado values(TO_DATE('03/03/2009 08:00','DD/MM/YYYY HH24:MI'),'SS-00004-S-04',TO_DATE('03/03/2009 14:00','DD/MM/YYYY HH24:MI'),'Averia Hardware');
INSERT INTO Periodosdeapagado values(TO_DATE('08/01/2009 16:17','DD/MM/YYYY HH24:MI'),'SS-00003-S-03',TO_DATE('08/01/2009 16:22','DD/MM/YYYY HH24:MI'),'Interrupcion de Suministro Electrico');
INSERT INTO Periodosdeapagado values(TO_DATE('10/06/2010 22:24','DD/MM/YYYY HH24:MI'),'SS-00003-S-03',TO_DATE('10/06/2010 23:18','DD/MM/YYYY HH24:MI'),'Tareas de Mantenimiento');
INSERT INTO Periodosdeapagado values(TO_DATE('15/06/2010 20:40','DD/MM/YYYY HH24:MI'),'SS-00003-S-03',TO_DATE('17/06/2010 10:00','DD/MM/YYYY HH24:MI'),'Averia Hardware');
INSERT INTO Periodosdeapagado values(TO_DATE('18/06/2010 20:40','DD/MM/YYYY HH24:MI'),'SS-00003-S-03',TO_DATE('20/06/2010 10:00','DD/MM/YYYY HH24:MI'),'Averia Hardware');
INSERT INTO Periodosdeapagado values(TO_DATE('23/10/2011 19:58','DD/MM/YYYY HH24:MI'),'SS-00001-S-01',TO_DATE('24/10/2011 00:05','DD/MM/YYYY HH24:MI'),'Interrupcion de Suministro Electrico');
INSERT INTO Periodosdeapagado values(TO_DATE('22/11/2011 21:30','DD/MM/YYYY HH24:MI'),'SS-00003-S-03',TO_DATE('22/11/2011 21:45','DD/MM/YYYY HH24:MI'),'Tareas de Mantenimiento');
INSERT INTO Periodosdeapagado values(TO_DATE('03/05/2012 23:12','DD/MM/YYYY HH24:MI'),'SS-00001-S-01',TO_DATE('04/05/2012 09:26','DD/MM/YYYY HH24:MI'),'Averia Hardware');
INSERT INTO Periodosdeapagado values(TO_DATE('17/01/2013 16:23','DD/MM/YYYY HH24:MI'),'SS-00002-S-02',TO_DATE('17/01/2013 17:03','DD/MM/YYYY HH24:MI'),'Interrupcion de Suministro Electrico');
INSERT INTO Periodosdeapagado values(TO_DATE('25/11/2013 08:34','DD/MM/YYYY HH24:MI'),'SS-00006-S-06',TO_DATE('25/11/2013 09:34','DD/MM/YYYY HH24:MI'),'Tareas de Mantenimiento');
INSERT INTO Periodosdeapagado values(TO_DATE('27/02/2015 08:42','DD/MM/YYYY HH24:MI'),'SS-00006-S-06',TO_DATE('27/02/2015 09:02','DD/MM/YYYY HH24:MI'),'Averia Hardware');
INSERT INTO Periodosdeapagado values(TO_DATE('10/03/2017 12:00','DD/MM/YYYY HH24:MI'),'SS-00003-S-03',TO_DATE('10/03/2017 12:40','DD/MM/YYYY HH24:MI'),'Interrupcion de Suministro Electrico');
INSERT INTO Periodosdeapagado values(TO_DATE('10/06/2010 23:24','DD/MM/YYYY HH24:MI'),'SS-00003-S-03',TO_DATE('10/06/2010 23:29','DD/MM/YYYY HH24:MI'),'Tareas de Mantenimiento');



create table Servicios(
Nombre      VARCHAR2(25),
Descripcion VARCHAR2(120),
CONSTRAINT pk_servicios PRIMARY KEY (Nombre)
);

// Insertamos Servicios

INSERT INTO Servicios values('DNS','Resuelve el nombre de las redes relacionándolas con su IP.');
INSERT INTO Servicios values('Correo','Presta servicio de correo electrónico entre Servidores usando el protocolo SMTP.');
INSERT INTO Servicios values('Web','Recibe peticiones de un cliente y proporciona una respuesta rederizada en un navegador web usando el protocolo HTTP.');
INSERT INTO Servicios values('DHCP','Asigna direcciones IP al resto de máquinas de forma automática.');
INSERT INTO Servicios values('Base de datos','Almacena, modifica y extrae información de la base de datos.');
INSERT INTO Servicios values('Seguridad','Protege el sistema de intrusiones no deseadas.');
INSERT INTO Servicios values('FTP','Permite el desplazamiento de datos entre diferentes máquinas.');
INSERT INTO Servicios values('SSH','Controla las líneas de módem de la red para que las peticiones conecten con la red de una posición remota.');



create table Serviciosinstalados(
NumeroSerieServidor     VARCHAR2(15),
NombreServicio          VARCHAR2(20),
FechaInico              DATE,
FechaFin                DATE,
CONSTRAINT pk_serviciosinstalados PRIMARY KEY (NumeroSerieServidor, NombreServicio),
CONSTRAINT fk_servidores4 FOREIGN KEY (NumeroSerieServidor) REFERENCES Servidores(NumeroSerie),
CONSTRAINT fk_servicios FOREIGN KEY (NombreServicio) REFERENCES Servicios(Nombre)
);

// Insertamos Serviciosinstalados

INSERT INTO Serviciosinstalados values('SS-00001-S-01','DHCP','10/04/2005','25/04/2011');
INSERT INTO Serviciosinstalados values('SS-00001-S-01','DNS','02/05/2015','16/09/2016');
INSERT INTO Serviciosinstalados(NumeroSerieServidor,NombreServicio,FechaInico) values('SS-00001-S-01','SSH','16/09/2016');
INSERT INTO Serviciosinstalados values('SS-00001-S-01','Web','06/11/2002','24/09/2006');
INSERT INTO Serviciosinstalados values('SS-00001-S-01','Correo','30/10/2008','16/09/2011');
INSERT INTO Serviciosinstalados values('SS-00002-S-02','Correo','25/05/2015','16/09/2016');
INSERT INTO Serviciosinstalados(NumeroSerieServidor,NombreServicio,FechaInico) values('SS-00002-S-02','DNS','17/09/2016');
INSERT INTO Serviciosinstalados values('SS-00003-S-03','Base de datos','29/05/2003','28/02/2009');
INSERT INTO Serviciosinstalados values('SS-00003-S-03','Correo','20/11/2016','23/06/2017');
INSERT INTO Serviciosinstalados values('SS-00003-S-03','DHCP','05/04/2010','16/09/2016');
INSERT INTO Serviciosinstalados values('SS-00003-S-03','SSH','17/09/2015','16/09/2016');
INSERT INTO Serviciosinstalados values('SS-00004-S-04','DNS','10/06/2016','16/10/2016');
INSERT INTO Serviciosinstalados values('SS-00004-S-04','FTP','16/09/2016','20/11/2016');
INSERT INTO Serviciosinstalados(NumeroSerieServidor,NombreServicio,FechaInico) values('SS-00004-S-04','SSH','17/09/2016');
INSERT INTO Serviciosinstalados values('SS-00004-S-04','Web','12/12/2015','06/12/2017');
INSERT INTO Serviciosinstalados values('SS-00005-S-05','Base de datos','29/04/2008','23/02/2010');
INSERT INTO Serviciosinstalados values('SS-00005-S-05','DHCP','02/05/2015','16/09/2016');
INSERT INTO Serviciosinstalados values('SS-00005-S-05','Seguridad','03/04/2013','15/10/2014');
INSERT INTO Serviciosinstalados(NumeroSerieServidor,NombreServicio,FechaInico) values('SS-00006-S-06','Correo','19/06/2008');
INSERT INTO Serviciosinstalados(NumeroSerieServidor,NombreServicio,FechaInico) values('SS-00006-S-06','Seguridad','10/04/2007');























