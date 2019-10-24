#--------------------------------------------------#
#                    POSTGRESQL                    #
#--------------------------------------------------#

CREATE TABLE paises
	(
		codigo				VARCHAR(2),
		nombre				VARCHAR(20) NOT NULL,
		clubs				NUMBER(2),
		jugadores_federados	NUMBER(4) NOT NULL,
		CONSTRAINT pk_paises 			PRIMARY KEY (codigo),
		CONSTRAINT paises_nombre_unico 	UNIQUE (nombre)
	);



CREATE TABLE participantes
	(
		codigo 		VARCHAR(6),
		codigo_pais	VARCHAR(2),
		nombre		VARCHAR(50) NOT NULL,
		direccion	VARCHAR(60),
		telefono	VARCHAR(14) NOT NULL,
		CONSTRAINT pk_participantes 			PRIMARY KEY (codigo),
		CONSTRAINT fk_participantes_paises		FOREIGN KEY (codigo_pais) REFERENCES paises,
		CONSTRAINT nombre_participante_valido 	CHECK (nombre = initcap(nombre)),
		CONSTRAINT participantes_tlf_unico		UNIQUE (telefono)
	);



CREATE TABLE jugadores
	(
		codigo	VARCHAR(3),
		elo		NUMERIC(8,3) NOT NULL,
		CONSTRAINT pk_jugadores					PRIMARY KEY (codigo),
		CONSTRAINT fk_jugadores_participantes 	FOREIGN KEY (codigo) REFERENCES participantes,
		CONSTRAINT elo_valido 					CHECK (elo <= 10000)
	);



CREATE TABLE arbitros
	(
		codigo		VARCHAR(6),
		categoria	VARCHAR(20) NOT NULL,
		CONSTRAINT pk_arbitros					PRIMARY KEY (codigo),
		CONSTRAINT fk_arbitros_participantes	FOREIGN KEY (codigo) REFERENCES participantes,
		CONSTRAINT codigo_arbitro_valido		CHECK (codigo ~ '^[A-D]{1}[0-9]{3}[A-Z]{2}$')
	);



CREATE TABLE torneos
	(
		nombre		VARCHAR(30),
		edicion		VARCHAR(15) NOT NULL,
		CONSTRAINT pk_torneos		PRIMARY KEY (nombre, edicion),
		CONSTRAINT edicion_valida 	CHECK (edicion ~ '^[0-9]{1,3}ª$')
	);



CREATE TABLE historial_jugadores
	(
		nombre_torneo	VARCHAR(30),
		edicion_torneo	VARCHAR(15),
		codigo_jugador	VARCHAR(3),
		posicion		VARCHAR(15) NOT NULL,
		CONSTRAINT pk_historialjugadores 			PRIMARY KEY (nombre_torneo, edicion_torneo, codigo_jugador),
		CONSTRAINT fk_historialjugadores_torneos	FOREIGN KEY (nombre_torneo, edicion_torneo) REFERENCES torneos,
		CONSTRAINT fk_histjugadores_jugadores		FOREIGN KEY (codigo_jugador) REFERENCES jugadores,
		CONSTRAINT posicion_valido 					CHECK (posicion IN ('Campeon', 'Finalista', 'Semifinalista', 'Cuartofinalista'))
	);



CREATE TABLE historial_arbitros
	(
		nombre_torneo	VARCHAR(30),
		edicion_torneo	VARCHAR(15),
		codigo_arbitro	VARCHAR(6),
		CONSTRAINT pk_historialarbitros	 			PRIMARY KEY (nombre_torneo, edicion_torneo, codigo_arbitro),
		CONSTRAINT fk_historialarbitros_torneos		FOREIGN KEY (nombre_torneo, edicion_torneo) REFERENCES torneos,
		CONSTRAINT fk_historialarbitros_arbitros	FOREIGN KEY (codigo_arbitro) REFERENCES arbitros
	);



CREATE TABLE partidas
	(
		codigo			VARCHAR(3),
		codigo_arbitro	VARCHAR(6),
		blancas			VARCHAR(3),
		negras			VARCHAR(3),
		ronda			VARCHAR(20) NOT NULL,
		resultado		VARCHAR(15),
		CONSTRAINT pk_partidas			PRIMARY KEY (codigo)
		CONSTRAINT fk_partidas_arbitros	FOREIGN KEY (codigo_arbitro) REFERENCES arbitros,
		CONSTRAINT fk_partidas_blancas	FOREIGN KEY (blancas) REFERENCES jugadores,
		CONSTRAINT fk_partidas_negras	FOREIGN KEY (negras) REFERENCES jugadores
	);



CREATE TABLE causas_tablas
	(
		codigo			VARCHAR(1),
		descripcion		VARCHAR(25) NOT NULL,
		CONSTRAINT pk_causas_tablas 	PRIMARY KEY (codigo),
		CONSTRAINT causa_tablas_valida	CHECK (descripcion IN ('Acuerdo', 'Ahogamiento', 'Jaque Perpetuo', 'Material Insuficiente'))
	);



CREATE TABLE partidas_empatadas
	(
		codigo_partida	VARCHAR(3),
		causa_tablas	VARCHAR(1) NOT NULL,
		CONSTRAINT pk_partidas_empatadas			PRIMARY KEY (codigo_partida),
		CONSTRAINT fk_partsempatadas_causastablas	FOREIGN KEY (causa_tablas) REFERENCES causas_tablas
	);



CREATE TABLE movimientos
	(
		orden			NUMBER(3),
		codigo_partida	VARCHAR(3),
		codigo_jugador	VARCHAR(3),
		duracion		DATE NOT NULL,
		pieza			VARCHAR(8) NOT NULL,
		casilla_salida	VARCHAR(2) NOT NULL,
		casilla_llegada	VARCHAR(2) NOT NULL,
		CONSTRAINT pk_movimientos 			PRIMARY KEY (orden, codigo_partida, codigo_jugador),
		CONSTRAINT tiempo_movimiento_max	CHECK (to_char(duracion, 'HH24MISS') < '11500'),
		CONSTRAINT nombre_casilla_valido 	CHECK ((casilla_salida ~ '^[A-H]{1}[1-8]{1}$') AND (casilla_llegada ~ '^[A-H]{1}[1-8]{1}$'))
	);