-- Llenamos la tabla de Estudiantes con los datos que nos provee los archivos CVS
-- Ruta
INSERT INTO Ruta(Nombre, Tipo)
    SELECT DISTINCT Ruta, Tipo_de_Ruta
    FROM Censo WHERE Ruta IS NOT NULL AND Tipo_de_ruta IS NOT NULL;

INSERT INTO Ruta(Nombre, Tipo)
	VALUES ('Ruta litoral inactiva', 'Inactivo');

DELETE FROM Ruta
    WHERE Nombre = 'Ruta';

-- Medio de Transportes
INSERT INTO Transporte(Tipo)
    SELECT DISTINCT Medio_de_Transporte
    FROM Censo;

DELETE FROM Transporte
    WHERE Tipo = 'Medio de Transporte';

-- Materias
INSERT INTO Materia(Codigo)
    SELECT DISTINCT CODIGO_MATERIA
    FROM Horarios_Litoral;

INSERT INTO Estudiantes(Carnet)
    SELECT DISTINCT Carnet
    FROM Censo;

-- Actualizamos los demás campos de las Materias
ALTER TABLE Materia alter column Descripcion set data type varchar(100) ;

UPDATE Materia 
SET 
    Descripcion = c.DESCRIPCION,
	Creditos = c.creditos
FROM (
    SELECT CODIGO_MATERIA, DESCRIPCION, creditos
    FROM Horarios_Litoral) c
WHERE 
    c.CODIGO_MATERIA = Materia.Codigo;


-- Actualizamos todos los demás campos que no sean clave principal de la tabla de estudiantes
UPDATE Estudiantes 
SET Nombre = c.Nombre_Completo,
	Ruta = c.Ruta,
	Transporte = c.Medio_de_Transporte
FROM (
    SELECT Carnet, Nombre_Completo, Ruta, Medio_de_Transporte
    FROM Censo) c
WHERE 
    c.Carnet = Estudiantes.Carnet;

-- Eliminamos una fila innecesaria en Horarios Litoral
DELETE FROM Horarios_Litoral WHERE Horarios_Litoral.CARNET = 'CARNET';

-- Insertamos los estudiantes en Horario Litoral que no están en Censo Estudiantes
INSERT INTO Estudiantes(Carnet)
    SELECT DISTINCT CARNET
	FROM Horarios_Litoral
	WHERE 
	NOT EXISTS(SELECT DISTINCT
                Carnet
            FROM 
                Estudiantes 
            WHERE 
                Estudiantes.Carnet = Horarios_Litoral.CARNET);

-- Actualizamos los nombres y cedula de los estudiantes que están en Horario Litoral pero no en Censo Estudiantes
UPDATE Estudiantes 
SET 
    Nombre = c.NOMBRES,
	Cedula = c.CEDULA
FROM (
    SELECT CARNET, NOMBRES, CEDULA
    FROM Horarios_Litoral) c
WHERE 
    c.CARNET = Estudiantes.Carnet;



-- Tabla Censo
