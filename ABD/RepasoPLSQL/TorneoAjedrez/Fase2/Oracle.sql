#----------------------------------------------#
#                    ORACLE                    #
#----------------------------------------------#

CREATE TABLE paises
	(
		codigo				VARCHAR2(2),
		nombre				VARCHAR2(20) CONSTRAINT paises_nombre_notnull NOT NULL,
		clubs				NUMBER(2),
		jugadores_federados	NUMBER(4) CONSTRAINT paises_jugfed_notnull NOT NULL,
		CONSTRAINT pk_paises 			PRIMARY KEY (codigo),
		CONSTRAINT paises_nombre_unico 	UNIQUE (nombre)
	);



CREATE TABLE participantes
	(
		codigo 		VARCHAR2(6),
		codigo_pais	VARCHAR2(2),
		nombre		VARCHAR2(50) CONSTRAINT participantes_nombre_notnull NOT NULL,
		direccion	VARCHAR2(60),
		telefono	VARCHAR2(14) CONSTRAINT participantes_tlf_notnull NOT NULL,
		CONSTRAINT pk_participantes 			PRIMARY KEY (codigo),
		CONSTRAINT fk_participantes_paises		FOREIGN KEY (codigo_pais) REFERENCES paises,
		CONSTRAINT nombre_participante_valido 	CHECK (nombre = initcap(nombre)),
		CONSTRAINT participantes_tlf_unico		UNIQUE (telefono)
	);



CREATE TABLE jugadores
	(
		codigo	VARCHAR2(3),
		elo		NUMBER(8,3) CONSTRAINT elo_notnull NOT NULL,
		CONSTRAINT pk_jugadores					PRIMARY KEY (codigo),
		CONSTRAINT fk_jugadores_participantes	FOREIGN KEY (codigo) REFERENCES participantes,
		CONSTRAINT elo_valido 					CHECK (elo <= 10000)
	);



CREATE TABLE arbitros
	(
		codigo		VARCHAR2(6),
		categoria	VARCHAR2(20) CONSTRAINT categoria_notnull NOT NULL,
		CONSTRAINT pk_arbitros					PRIMARY KEY (codigo),
		CONSTRAINT fk_arbitros_participantes	FOREIGN KEY (codigo) REFERENCES participantes,
		CONSTRAINT codigo_arbitro_valido		CHECK (regexp_like(codigo, '^[A-D]{1}[0-9]{3}[A-Z]{2}$'))
	);



CREATE TABLE torneos
	(
		nombre		VARCHAR2(30),
		edicion		VARCHAR2(15) CONSTRAINT edicion_notnull NOT NULL,
		CONSTRAINT pk_torneos		PRIMARY KEY (nombre, edicion),
		CONSTRAINT edicion_valida 	CHECK (regexp_like(edicion, '^[0-9]{1,3}ª$'))
	);



CREATE TABLE historial_jugadores
	(
		nombre_torneo	VARCHAR2(30),
		edicion_torneo	VARCHAR2(15),
		codigo_jugador	VARCHAR2(3),
		posicion		VARCHAR2(15) CONSTRAINT posicion_notnull NOT NULL,
		CONSTRAINT pk_historialjugadores 			PRIMARY KEY (nombre_torneo, edicion_torneo, codigo_jugador),
		CONSTRAINT fk_historialjugadores_torneos	FOREIGN KEY (nombre_torneo, edicion_torneo) REFERENCES torneos,
		CONSTRAINT fk_histjugadores_jugadores		FOREIGN KEY (codigo_jugador) REFERENCES jugadores,
		CONSTRAINT posicion_valida					CHECK (posicion IN ('Campeon', 'Finalista', 'Semifinalista', 'Cuartofinalista'))
	);



CREATE TABLE historial_arbitros
	(
		nombre_torneo	VARCHAR2(30),
		edicion_torneo	VARCHAR2(15),
		codigo_arbitro	VARCHAR2(6),
		CONSTRAINT pk_historialarbitros	 			PRIMARY KEY (nombre_torneo, edicion_torneo, codigo_arbitro),
		CONSTRAINT fk_historialarbitros_torneos		FOREIGN KEY (nombre_torneo, edicion_torneo) REFERENCES torneos,
		CONSTRAINT fk_historialarbitros_arbitros	FOREIGN KEY (codigo_arbitro) REFERENCES arbitros
	);



CREATE TABLE partidas
	(
		codigo			VARCHAR2(3),
		codigo_arbitro	VARCHAR2(6),
		blancas			VARCHAR2(3),
		negras			VARCHAR2(3),
		ronda			VARCHAR2(20) CONSTRAINT ronda_notnull NOT NULL,
		resultado		VARCHAR2(15),
		CONSTRAINT pk_partidas			PRIMARY KEY (codigo),
		CONSTRAINT fk_partidas_arbitros	FOREIGN KEY (codigo_arbitro) REFERENCES arbitros,
		CONSTRAINT fk_partidas_blancas	FOREIGN KEY (blancas) REFERENCES jugadores,
		CONSTRAINT fk_partidas_negras	FOREIGN KEY (negras) REFERENCES jugadores
	);



CREATE TABLE causas_tablas
	(
		codigo			VARCHAR2(1),
		descripcion		VARCHAR2(25) CONSTRAINT descripcion_notnull NOT NULL,
		CONSTRAINT pk_causastablas 		PRIMARY KEY (codigo),
		CONSTRAINT causa_tablas_validas	CHECK (descripcion IN ('Acuerdo', 'Ahogamiento', 'Jaque Perpetuo', 'Material Insuficiente'))
	);



CREATE TABLE partidas_empatadas
	(
		codigo_partida	VARCHAR2(3),
		causa_tablas	VARCHAR2(1) CONSTRAINT causatablas_notnull NOT NULL,
		CONSTRAINT pk_partidasempatadas					PRIMARY KEY (codigo_partida),
		CONSTRAINT fk_partsempatadas_causastablas	FOREIGN KEY (causa_tablas) REFERENCES causas_tablas
	);



CREATE TABLE movimientos
	(
		orden			NUMBER(3),
		codigo_partida	VARCHAR2(3),
		codigo_jugador	VARCHAR2(3),
		duracion		DATE CONSTRAINT duracion_mov_notnull NOT NULL,
		pieza			VARCHAR2(8) CONSTRAINT pieza_notnull NOT NULL,
		casilla_salida	VARCHAR2(2) CONSTRAINT casillasalida_notnull NOT NULL,
		casilla_llegada	VARCHAR2(2) CONSTRAINT casillallegada_notnull NOT NULL,
		CONSTRAINT pk_movimientos 			PRIMARY KEY (orden, codigo_partida, codigo_jugador),
		CONSTRAINT tiempo_movimiento_max	CHECK (to_char(duracion, 'HH24MISS') < '11500'),
		CONSTRAINT nombre_casilla_valido 	CHECK (regexp_like(casilla_salida, casilla_llegada, '^[A-H]{1}[1-8]{1}$'))
	);