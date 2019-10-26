/* Maria Fernanda Machado
Manuel Guillermo Gil

Códigos PostgresSQL para crear la Base de Datos del Proyecto 1 (Transporte Estudiantil) de la materia de Bases de Datos. Sept. - Dic. 2019
 */

-- Creamos la Base de Datos en el cual vamos a trabajar en el proyecto. También un usuario administrador el cual vamos a asignarle todos los privilegios a la misma
CREATE USER te_admin PASSWORD 'te_admin';
CREATE DATABASE transporte_estudiantil_db WITH OWNER te_admin;
GRANT ALL PRIVILEGES ON DATABASE transporte_estudiantil_db TO te_admin;
ALTER ROLE te_admin WITH SUPERUSER 

CREATE table estudiantes(Carnet int primary key not null,Nombre Completo not null,Cédula int not null);

-- Creamos la tabla de Censo para importar la tabla en excel/cvs a un registro de postgres
CREATE TABLE public."Censo"
(
    "Carnet" character varying(50),
    "Nombre Completo" character varying(50),
    "Medio de Transporte" character varying(50),
    "Zona donde vive" character varying(50),
    "Relacion" character varying(50),
    "Hora a la que llega a la universidad [Lunes]" character varying(50),
    "Hora a la que llega a la universidad [Martes]" character varying(50),
    "Hora a la que llega a la universidad" character varying(50),
    "Hora a la que llega a la universidad [Jueves]" character varying(50),
    "Hora a la que llega a la universidad [Viernes]" character varying(50),
    "Sede" character varying(50),
    "Tipo de Ruta" character varying(50),
    "Ruta" character varying(50),
    "Tiempo en llegar a la Universidad" character varying(50)
);

-- Impoortamos el archivo cvs a la tabla creada
copy Censo (Carnet, Nombre Completo, Medio de Transporte, Zona donde vive, Relacion, Hora a la que llega a la universidad [Lunes], Hora a la que llega a la universidad [Martes], Hora a la que llega a la universidad, Hora a la que llega a la universidad [Jueves], Hora a la que llega a la universidad [Viernes], Sede, Tipo de Ruta, Ruta, Tiempo en llegar a la Universidad) from '~/Development/transporte-estudiantil/Censo_Estudiantes_Litoral.csv' delimiter ',' csv header;

-- Creamos la tabla de Horarios Litoral para importar la tabla en excel/cvs a un registro de postgres
CREATE TABLE public."Horarios Litoral"
(
    "CARNET" character varying(50),
    "CEDULA" character varying(50),
    "APELLIDOS" character varying(50),
    "NOMBRES" character varying(50),
    "CODIGO_MATERIA" character varying(50),
    "SECCION" character varying(50),
    "DESCRIPCION" character varying(100),
    "creditos" character varying(50),
    "dia" character varying(50),
    "hora_inicio" character varying(50),
    "hora_fin" character varying(50)
);

-- Impoortamos el archivo cvs a la tabla creada
copy Censo (CARNET, CEDULA, APELLIDOS, NOMBRES, CODIGO_MATERIA, SECCION, DESCRIPCION, creditos, dia, hora_inicio, hora_fin) from '~/Development/transporte-estudiantil/Horarios_Litoral.csv' delimiter ',' csv header;

CREATE TABLE public."Horario" (
    "Id" SERIAL PRIMARY KEY,
    "Hora 1" boolean,
    "Hora 2" boolean,
    "Hora 3" boolean,
    "Hora 4" boolean,
    "Hora 5" boolean,
    "Hora 6" boolean,
    "Hora 7" boolean,
    "Hora 8" boolean,
    "Hora 9" boolean,
    "Hora 10" boolean
);

CREATE TABLE public."Ruta" (
    "Nombre" character varying(50) PRIMARY KEY,
    "Tipo" character varying(50)
);

CREATE TABLE public."Transporte" (
    "Tipo" character varying(50) PRIMARY KEY
);

CREATE TABLE public."Materia" (
    "Codigo" character varying(50) PRIMARY KEY,
    "Descripcion" character varying(50),
    "Creditos" character varying(50)
);

CREATE TABLE public."Inscribe" (
    "Id" SERIAL PRIMARY KEY,
    "Inicio" character varying(50),
    "Fin" character varying(50),
    "Dia" character varying(50),
    "Materia" character varying(50) REFERENCES "Materia"
);

CREATE TABLE public."Estudiantes" (
    "Carnet" character varying(50) PRIMARY KEY,
    "Cedula" character varying(50),
    "Nombre" character varying(50)
);

-- Alteramos las tablas para crear claves foranéas

ALTER TABLE public."Estudiantes"
    ADD COLUMN "Ruta" character varying(50);
	
ALTER TABLE public."Estudiantes"
    ADD CONSTRAINT FKtest
    FOREIGN KEY("Ruta")
    REFERENCES "Ruta" ("Nombre");

ALTER TABLE public."Estudiantes"
    ADD COLUMN "Horario" character varying(50);

ALTER TABLE public."Estudiantes"
    ADD COLUMN "Horario_dia" character varying(50);
	
ALTER TABLE public."Estudiantes"
    ADD CONSTRAINT FKtest
    FOREIGN KEY("Horario")
    REFERENCES "Horario" ("Id");

ALTER TABLE public."Estudiantes"
    ADD COLUMN "Transporte" character varying(50);
	
ALTER TABLE public."Estudiantes"
    ADD CONSTRAINT FKtest
    FOREIGN KEY("Transporte")
    REFERENCES "Transporte" ("Tipo");

ALTER TABLE public."Inscribe"
    ADD COLUMN "Estudiante" character varying(50);
	
ALTER TABLE public."Inscribe"
    ADD CONSTRAINT FKEstudiante
    FOREIGN KEY("Estudiante")
    REFERENCES "Estudiantes" ("Carnet");

ALTER TABLE public."Inscribe"
    ADD COLUMN "Materia" character varying(50);
	
ALTER TABLE public."Inscribe"
    ADD CONSTRAINT FKMateria
    FOREIGN KEY("Materia")
    REFERENCES "Materia" ("Codigo");

-- Llenamos la tabla de Estudiantes con los datos que nos provee los archivos CVS

-- Rutas
INSERT INTO "Ruta"("Nombre", "Tipo")
    SELECT DISTINCT "Ruta", "Tipo de Ruta"
    FROM "Censo" WHERE "Ruta" IS NOT NULL AND "Ruta" IS NOT NULL;

DELETE FROM "Ruta"
    WHERE "Nombre" = 'Ruta';

-- Medio de Transportes
INSERT INTO "Transporte"("Tipo")
    SELECT DISTINCT "Medio de Transporte"
    FROM "Censo";

DELETE FROM "Transporte"
    WHERE "Tipo" = 'Medio de Transporte';

-- Materias
INSERT INTO "Materia"("Codigo")
    SELECT DISTINCT "CODIGO_MATERIA"
    FROM "Horarios Litoral";

-- Actualizamos los demás campos de las Materias
ALTER TABLE "Materia" alter column "Descripcion" set data type character varying(100);

UPDATE "Materia" 
SET 
    "Descripcion" = c."DESCRIPCION",
	"Creditos" = c."creditos"
FROM (
    SELECT "CODIGO_MATERIA", "DESCRIPCION", "creditos"
    FROM "Horarios Litoral") c
WHERE 
    c."CODIGO_MATERIA" = "Materia"."Codigo";

-- Se eliminan estas dos columnas ya que como varios Estudiantes pueden tener el mismo horario, y el mismo horario puede estar asignado
-- a varios estudiantes, entonces se creará otra tabla llamada Asignacion_Horario el cual corresponde a la relación entre Estudiante
-- y Horario, con una cardinalidad de N a M
ALTER TABLE "Estudiantes" 
	DROP COLUMN "Horario";

ALTER TABLE "Estudiantes" 
	DROP COLUMN "Horario_dia";

CREATE TABLE public."Horario_Asignado"
(
    "Estudiante" character varying(50) REFERENCES "Estudiantes",
    "Horario" SERIAL REFERENCES "Horario"
);

-- Llenamos los campos del Estudiante

INSERT INTO "Estudiantes"("Carnet")
    SELECT DISTINCT "Carnet"
    FROM "Censo";

-- Hay que añadir este valor ya que sino habrá una violación a la clave foranéa de Ruta al actualizar la tabla de estudiantes
INSERT INTO public."Ruta"(
	"Nombre", "Tipo")
	VALUES ('Ruta litoral inactiva', 'Inactivo');


-- Actualizamos todos los demás campos que no sean clave principal de la tabla de estudiantes
UPDATE "Estudiantes" 
SET "Nombre" = c."Nombre Completo",
	"Ruta" = c."Ruta",
	"Transporte" = c."Medio de Transporte"
FROM (
    SELECT "Carnet", "Nombre Completo", "Ruta", "Medio de Transporte"
    FROM "Censo") c
WHERE 
    c."Carnet" = "Estudiantes"."Carnet";

-- Eliminamos el '-' en los carnets
UPDATE 
"Estudiantes"
SET 
"Carnet" = REPLACE("Carnet",'-','');

-- Eliminamos una fila innecesaria en Horarios Litoral
DELETE FROM "Horarios Litoral" WHERE "Horarios Litoral"."CARNET" = 'CARNET';

-- Insertamos los estudiantes en Horario Litoral que no están en Censo Estudiantes
INSERT INTO "Estudiantes"("Carnet")
    SELECT DISTINCT "CARNET"
	FROM "Horarios Litoral"
	WHERE 
	NOT EXISTS(SELECT DISTINCT
                "Carnet"
            FROM 
                "Estudiantes" 
            WHERE 
                "Estudiantes"."Carnet" = "Horarios Litoral"."CARNET");

-- Actualizamos los nombres y cedula de los estudiantes que están en Horario Litoral pero no en Censo Estudiantes
UPDATE "Estudiantes" 
SET 
    "Nombre" = c."NOMBRES",
	"Cedula" = c."CEDULA"
FROM (
    SELECT "CARNET", "NOMBRES", "CEDULA"
    FROM "Horarios Litoral") c
WHERE 
    c."CARNET" = "Estudiantes"."Carnet";

-- Llenamos la tabla de Inscribe ya que es la data de los Estudiantes con las materias que tienen inscritas
INSERT INTO "Inscribe"("Inicio", "Fin", "Dia", "Estudiante", "Materia")
    SELECT "hora_inicio", "hora_fin", "dia", "CARNET", "CODIGO_MATERIA"
	FROM "Horarios Litoral";

-- Vamos a reemplazar los valores [1,2,3,4,5] por [Lunes, Martes, Miercoles, Jueves, Viernes] respectivamente
UPDATE 
"Inscribe"
SET 
"Dia" = REPLACE("Dia",'1','Lunes');

UPDATE 
"Inscribe"
SET 
"Dia" = REPLACE("Dia",'2','Martes');

UPDATE 
"Inscribe"
SET 
"Dia" = REPLACE("Dia",'3','Miercoles');

UPDATE 
"Inscribe"
SET 
"Dia" = REPLACE("Dia",'4','Jueves');

UPDATE 
"Inscribe"
SET 
"Dia" = REPLACE("Dia",'5','Viernes');


--- 1. ¿Quiénes son los estudiantes que sabemos necesitan llegar en el Transporte Universitario
-- a las 8:00 los jueves desde cada parada (por tener clase)?