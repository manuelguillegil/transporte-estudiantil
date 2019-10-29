-- 		Laboratorio de Sistema de Bases de Datos I 
--      Proyecto 1
--      Sept - Dic 2019
--
--		Integrantes:
--			Manuel Gil                  14-10397
--			Maria Fernanda Machado      13-10780
--
-------------------------------------------------------------------------

-- Tabla Censo para importar la tabla en excel/cvs a un registro de postgres
CREATE TABLE Censo (
    Carnet                  varchar(50),
    Nombre_Completo         varchar(50),
    Medio_de_Transporte     varchar(50),
    Zona_donde_vive         varchar(50),
    Relacion                varchar(50),
    Lunes                   varchar(50),
    Martes                  varchar(50),
    Miercoles               varchar(50),
    Jueves                  varchar(50),
    Viernes                 varchar(50),
    Sede                    varchar(50),
    Tipo_de_Ruta            varchar(50),
    Ruta                    varchar(50),
    Tiempo_llegada          varchar(50)
);

-- Impoortamos el archivo cvs a la tabla creada
\copy Censo FROM 'Censo Estudiantes Litoral.csv' WITH DELIMITER ',' csv header;

-- Tabla de Horarios Litoral para importar la tabla en excel/cvs a un registro de postgres
CREATE TABLE Horarios_Litoral (
    CARNET            varchar(50),
    CEDULA            varchar(50),
    APELLIDOS         varchar(50),
    NOMBRES           varchar(50),
    CODIGO_MATERIA    varchar(50),
    SECCION           varchar(50),
    DESCRIPCION       varchar(100),
    creditos          varchar(50),
    dia               varchar(50),
    hora_inicio       varchar(50),
    hora_fin          varchar(50)
);

-- Impoortamos el archivo cvs a la tabla creada
\copy Horarios_Litoral FROM 'Horarios Litoral.csv' WITH DELIMITER ',' csv header;

-- Tabla Horaio
CREATE TABLE Horario (
    Id        SERIAL PRIMARY KEY,
    Hora_1    boolean,
    Hora_2    boolean,
    Hora_3    boolean,
    Hora_4    boolean,
    Hora_5    boolean,
    Hora_6    boolean,
    Hora_7    boolean,
    Hora_8    boolean,
    Hora_9    boolean,
    Hora_10   boolean
);

-- Tabla Ruta
CREATE TABLE Ruta (
    Nombre        varchar(50) PRIMARY KEY,
    Tipo          varchar(50)
);

-- Tabla Transporte
CREATE TABLE Transporte (
    Tipo     varchar(50) PRIMARY KEY
);

-- Tabla Materia
CREATE TABLE Materia (
    Codigo            varchar(50) PRIMARY KEY,
    Descripcion       varchar(50),
    Creditos          varchar(50)
);

-- Tabla Inscribe
CREATE TABLE Inscribe (
    Id        SERIAL PRIMARY KEY,
    Inicio    varchar(50),
    Fin       varchar(50),
    Dia       varchar(50),
    Materias  varchar(50) REFERENCES Materia
);

-- Tabla Estudantes
CREATE TABLE Estudiantes (
    Carnet    varchar(50) PRIMARY KEY,
    Cedula    varchar(50),
    Nombre    varchar(50)
);

-- Alteramos las tablas para crear claves foranéas
-- Tabla Estudiantes
-- Ruta
ALTER TABLE Estudiantes
    ADD COLUMN Ruta varchar(50);
	
ALTER TABLE Estudiantes
    ADD CONSTRAINT FKtest
    FOREIGN KEY(Ruta)
    REFERENCES Ruta (Nombre);

-- Horario
ALTER TABLE Estudiantes
    ADD COLUMN Horario INTEGER;

--ALTER TABLE Estudiantes
--    ADD COLUMN Horario_dia character varying(50);
	
ALTER TABLE Estudiantes
    ADD CONSTRAINT FKtestt
    FOREIGN KEY(Horario)
    REFERENCES Horario (Id);
	
-- Transporte
ALTER TABLE Estudiantes
    ADD COLUMN Transporte character varying(50);
	
ALTER TABLE Estudiantes
    ADD CONSTRAINT FKtests
    FOREIGN KEY(Transporte)
    REFERENCES Transporte (Tipo);

-- Tabla Inscribe
-- Estudiante
ALTER TABLE Inscribe
    ADD COLUMN Estudiante character varying(50);
	
ALTER TABLE Inscribe
    ADD CONSTRAINT FKEstudiante
    FOREIGN KEY(Estudiante)
    REFERENCES Estudiantes (Carnet);

-- Materia
ALTER TABLE Inscribe
    ADD COLUMN Materia character varying(50);
	
ALTER TABLE Inscribe
    ADD CONSTRAINT FKMateria
    FOREIGN KEY(Materia)
    REFERENCES Materia (Codigo);