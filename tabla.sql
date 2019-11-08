-- 		Laboratorio de Sistema de Bases de Datos I 
--      Proyecto 1
--      Sept - Dic 2019
--
--		Integrantes:
--			Manuel Gil                  14-10397
--			Maria Fernanda Machado      13-10780
--
-------------------------------------------------------------------------
DROP TABLE IF EXISTS Censo ;
DROP TABLE IF EXISTS Horarios_Litoral;
DROP TABLE IF EXISTS Horario_Llegada;
DROP TABLE IF EXISTS Inscribe;
DROP TABLE IF EXISTS Materia;
DROP TABLE IF EXISTS Estudiantes;
DROP TABLE IF EXISTS Ruta;
DROP TABLE IF EXISTS Transporte;

-- Tabla Censo para importar la tabla en excel/cvs a un registro de postgres
CREATE TABLE Censo (
    carnet                  VARCHAR(64),
    nombre_nompleto         VARCHAR(64),
    medio_de_transporte     VARCHAR(64),
    zona_donde_vive         VARCHAR(64),
    relacion                VARCHAR(64),
    lunes                   VARCHAR(64),
    martes                  VARCHAR(64),
    miercoles               VARCHAR(64),
    jueves                  VARCHAR(64),
    viernes                 VARCHAR(64),
    sede                    VARCHAR(64),
    tipo_de_ruta            VARCHAR(64),
    ruta                    VARCHAR(64),
    tiempo_llegada          VARCHAR(64)
);

-- Importamos el archivo cvs a la tabla creada
\COPY Censo FROM 'Censo Estudiantes Litoral.csv' WITH DELIMITER ',' CSV HEADER;

-- Tabla de Horarios Litoral para importar la tabla en excel/cvs a un registro de postgres
CREATE TABLE Horarios_Litoral (
    carnet            VARCHAR(64),
    cedula            VARCHAR(64),
    apellidos         VARCHAR(64),
    nombres           VARCHAR(64),
    codigo_materia    VARCHAR(64),
    seccion           VARCHAR(64),
    descripcion       VARCHAR(128),
    creditos          VARCHAR(64),
    dia               VARCHAR(64),
    hora_inicio       VARCHAR(64),
    hora_fin          VARCHAR(64)
);

-- Importamos el archivo cvs a la tabla creada
\COPY Horarios_Litoral FROM 'Horarios Litoral.csv' WITH DELIMITER ',' CSV HEADER;

-- Tabla Ruta
CREATE TABLE Ruta (
    nombre        VARCHAR(64) NOT NULL PRIMARY KEY,
    tipo          VARCHAR(64) NOT NULL
);

-- Tabla Transporte
CREATE TABLE Transporte (
    tipo     VARCHAR(64) NOT NULL PRIMARY KEY
);

-- Tabla Materia
CREATE TABLE Materia (
    codigo            VARCHAR(64) NOT NULL PRIMARY KEY,
    descripcion       VARCHAR(128) NOT NULL,
    creditos          VARCHAR(64) NOT NULL
);

-- Tabla Estudantes
CREATE TABLE Estudiantes (
    carnet          VARCHAR(64) PRIMARY KEY,
    cedula          VARCHAR(64) NOT NULL UNIQUE,
    nombres         VARCHAR(64) NOT NULL,
    apellidos       VARCHAR(64) NOT NULL,
    ruta            VARCHAR(64),
    transporte      VARCHAR(64) NOT NULL
);
	
-- Tabla Inscribe
CREATE TABLE Inscribe (
    inicio               VARCHAR(64) NOT NULL,
    fin                  VARCHAR(64) NOT NULL,
    dia                  VARCHAR(64) NOT NULL,
    seccion              VARCHAR(64) NOT NULL,
    codigo_materia       VARCHAR(64) NOT NULL,
    carnet_estudiante    VARCHAR(64) NOT NULL
);

-- Horario Llegada de los estudiantes
CREATE TABLE Horario_Llegada (
    dia                  VARCHAR(64) NOT NULL,
    hora                 TIME ,
    carnet_estudiante    VARCHAR(64) NOT NULL
);

-- Alteramos las tablas para crear claves foranéas
-- Estudiantes
ALTER TABLE Estudiantes
    ADD CONSTRAINT estudiante_ruta_fk
    FOREIGN KEY (ruta)
    REFERENCES Ruta(nombre)
    ON DELETE SET NULL;

ALTER TABLE Estudiantes
    ADD CONSTRAINT estudiante_transporte_fk
    FOREIGN KEY (transporte)
    REFERENCES Transporte(tipo)
    ON DELETE SET NULL;

-- Inscribe
ALTER TABLE Inscribe
    ADD CONSTRAINT incribe_materia_fk
    FOREIGN KEY (codigo_materia)
    REFERENCES Materia(codigo)
    ON DELETE CASCADE;

ALTER TABLE Inscribe
    ADD CONSTRAINT incribe_estudiante_fk
    FOREIGN KEY (carnet_estudiante)
    REFERENCES Estudiantes(carnet)
    ON DELETE CASCADE;

-- Horario llegada
ALTER TABLE Horario_Llegada
    ADD CONSTRAINT hora_llegada_estudiante_fk
    FOREIGN KEY (carnet_estudiante)
    REFERENCES Estudiantes(carnet)
    ON DELETE CASCADE;
	
-- Se elimina el - de los carnet e censo
UPDATE Censo SET carnet = REPLACE(Carnet,'-','');
-- En caso de haber un correo se selecciona solo el carnet
UPDATE Censo SET carnet = SUBSTRING(Carnet, 1,7);
-- Se cambian como estan los horarios a uno que pueda usar el TIME
UPDATE Censo SET lunes = REPLACE(lunes, 'No uso el transporte USB', '0:00');
UPDATE Censo SET martes = REPLACE(martes, 'No uso el transporte USB', '0:00');
UPDATE Censo SET miercoles = REPLACE(miercoles, 'No uso el transporte USB', '0:00');
UPDATE Censo SET jueves = REPLACE(jueves, 'No uso el transporte USB', '0:00');
UPDATE Censo SET viernes = REPLACE(viernes, 'No uso el transporte USB', '0:00');

UPDATE Censo SET lunes = REPLACE(lunes, 'Antes de las 8 a. m.', '7:00');
UPDATE Censo SET martes = REPLACE(martes, 'Antes de las 8 a. m.', '7:00');
UPDATE Censo SET miercoles = REPLACE(miercoles, 'Antes de las 8 a. m.', '7:00');
UPDATE Censo SET jueves = REPLACE(jueves, 'Antes de las 8 a. m.', '7:00');
UPDATE Censo SET viernes = REPLACE(viernes, 'Antes de las 8 a. m.', '7:00');

UPDATE Censo SET lunes = REPLACE(lunes, '8 a. m.', '8:00');
UPDATE Censo SET martes = REPLACE(martes, '8 a. m.', '8:00');
UPDATE Censo SET miercoles = REPLACE(miercoles, '8 a. m.', '8:00');
UPDATE Censo SET jueves = REPLACE(jueves, '8 a. m.', '8:00');
UPDATE Censo SET viernes = REPLACE(viernes, '8 a. m.', '8:00');

UPDATE Censo SET lunes = REPLACE(lunes, '9 a. m.', '9:00');
UPDATE Censo SET martes = REPLACE(martes, '9 a. m.', '9:00');
UPDATE Censo SET miercoles = REPLACE(miercoles, '9 a. m.', '9:00');
UPDATE Censo SET jueves = REPLACE(jueves, '9 a. m.', '9:00');
UPDATE Censo SET viernes = REPLACE(viernes, '9 a. m.', '9:00');

UPDATE Censo SET lunes = REPLACE(lunes, '10 a. m.', '10:00');
UPDATE Censo SET martes = REPLACE(martes, '10 a. m.', '10:00');
UPDATE Censo SET miercoles = REPLACE(miercoles, '10 a. m.', '10:00');
UPDATE Censo SET jueves = REPLACE(jueves, '10 a. m.', '10:00');
UPDATE Censo SET viernes = REPLACE(viernes, '10 a. m.', '10:00');

UPDATE Censo SET lunes = REPLACE(lunes, '11 a. m.', '11:00');
UPDATE Censo SET martes = REPLACE(martes, '11 a. m.', '11:00');
UPDATE Censo SET miercoles = REPLACE(miercoles, '11 a. m.', '11:00');
UPDATE Censo SET jueves = REPLACE(jueves, '11 a. m.', '11:00');
UPDATE Censo SET viernes = REPLACE(viernes, '11 a. m.', '11:00');

UPDATE Censo SET lunes = REPLACE(lunes, '12 m.', '12:00');
UPDATE Censo SET martes = REPLACE(martes, '12 m.', '12:00');
UPDATE Censo SET miercoles = REPLACE(miercoles, '12 m.', '12:00');
UPDATE Censo SET jueves = REPLACE(jueves, '12 m.', '12:00');
UPDATE Censo SET viernes = REPLACE(viernes, '12 m.', '12:00');