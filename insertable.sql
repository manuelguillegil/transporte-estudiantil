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



-- Tabla Censo
