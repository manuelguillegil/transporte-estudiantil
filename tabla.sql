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
--DROP TABLE IF EXISTS Horario;
DROP TABLE IF EXISTS Inscribe;
DROP TABLE IF EXISTS Materia;
DROP TABLE IF EXISTS Estudiantes;
DROP TABLE IF EXISTS Ruta;
DROP TABLE IF EXISTS Transporte;

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

/*CREATE TABLE Horario_Inicio (
    Estudiante       varchar(50) REFERENCES Estudiantes,
    Horario          varchar(5)
);
*/
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
    Materias  varchar(50) REFERENCES Materia ON DELETE CASCADE
);

-- Tabla Estudantes
CREATE TABLE Estudiantes (
    Carnet    varchar(50) PRIMARY KEY,
    Cedula    varchar(50),
    Nombre    varchar(50),
    Ruta      varchar(50) REFERENCES Ruta(nombre) ON DELETE CASCADE
);
	
-- Horario

--ALTER TABLE Estudiantes
--   ADD COLUMN Horario varchar(5) REFERENCES Horario_Inicio() ON DELETE CASCADE;

--ALTER TABLE Estudiantes
--    ADD COLUMN Horario_dia varchar(50);
	
--ALTER TABLE Estudiantes
--    ADD CONSTRAINT FKtestt
--    FOREIGN KEY(Horario)
--    REFERENCES Horario(Id);
	
-- Transporte
ALTER TABLE Estudiantes
    ADD COLUMN Transporte varchar(50);
	
ALTER TABLE Estudiantes
    ADD CONSTRAINT FKtests
    FOREIGN KEY(Transporte)
    REFERENCES Transporte (Tipo) ON DELETE CASCADE;

-- Tabla Inscribe
-- Estudiante
ALTER TABLE Inscribe
    ADD COLUMN Estudiante varchar(50);
	
ALTER TABLE Inscribe
    ADD CONSTRAINT FKEstudiante
    FOREIGN KEY(Estudiante)
    REFERENCES Estudiantes (Carnet) ON DELETE CASCADE;

-- Materia
ALTER TABLE Inscribe
    ADD COLUMN Materia varchar(50);
	
ALTER TABLE Inscribe
    ADD CONSTRAINT FKMateria
    FOREIGN KEY(Materia)
    REFERENCES Materia (Codigo) ON DELETE CASCADE;

UPDATE Censo SET Carnet = REPLACE(Carnet,'-','');
UPDATE Censo SET Carnet = SUBSTRING(Carnet, 1,7);