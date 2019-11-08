-- Llenamos las tablas  con los datos que nos proveen los archivos CVS
-- Ruta
INSERT INTO Ruta(nombre, tipo)
    SELECT DISTINCT ruta, tipo_de_ruta
    FROM Censo WHERE ruta IS NOT NULL AND tipo_de_ruta IS NOT NULL AND
         ruta <> 'Ruta';

INSERT INTO Ruta(nombre, tipo)
	VALUES ('Ruta litoral inactiva', 'Inactivo');

-- Medio de Transportes
INSERT INTO Transporte(tipo)
    SELECT DISTINCT medio_de_transporte
    FROM Censo
    WHERE medio_de_transporte <> 'Medio de Transporte';

-- Materias
INSERT INTO Materia(codigo, descripcion, creditos)
    SELECT DISTINCT codigo_materia, descripcion, creditos
    FROM Horarios_Litoral
    WHERE codigo_materia IS NOT NULL AND 
          codigo_materia <> 'CODIGO_MATERIA';

-- Estudiantes
INSERT INTO Estudiantes(carnet, cedula, apellidos, nombres, transporte, ruta)
    SELECT DISTINCT hl.carnet, hl.cedula, hl.apellidos, hl.nombres, c.medio_de_transporte, c.ruta
    FROM Censo AS c, Horarios_Litoral AS hl
    WHERE c.carnet = hl.carnet AND NOT EXISTS(SELECT *
                                              FROM Horarios_Litoral hl2
                                              WHERE hl2.carnet = c.carnet AND (hl2.nombres <> hl.nombres OR
                                                    hl.apellidos <> hl2.apellidos OR hl.cedula <> hl2.cedula));

-- Inscribe
INSERT INTO Inscribe(inicio, fin, dia, seccion, carnet_estudiante, codigo_materia)
    SELECT hora_inicio, hora_fin, dia, seccion, carnet, codigo_materia
	FROM Horarios_Litoral;

-- Horario Llegada
INSERT INTO Horario_Llegada(dia, hora, carnet_estudiante)
    SELECT 'lunes', lunes::TIME, carnet
    FROM Censo
    WHERE lunes IS NOT NULL;

INSERT INTO Horario_Llegada(dia, hora, carnet_estudiante)
    SELECT 'martes', martes::TIME, carnet
    FROM Censo
    WHERE martes IS NOT NULL;

INSERT INTO Horario_Llegada(dia, hora, carnet_estudiante)
    SELECT 'miercoles', miercoles::TIME, carnet
    FROM Censo
    WHERE miercoles IS NOT NULL;

INSERT INTO Horario_Llegada(dia, hora, carnet_estudiante)
    SELECT 'jueves', jueves::TIME, carnet
    FROM Censo
    WHERE jueves IS NOT NULL;

INSERT INTO Horario_Llegada(dia, hora, carnet_estudiante)
    SELECT 'viernes', viernes::TIME, carnet
    FROM Censo
    WHERE viernes IS NOT NULL;

-- Se reemplzan los numeros de la semana por el nombre de los dias de la semana 
UPDATE Inscribe
    SET dia = REPLACE(dia,'1','lunes');
 
UPDATE Inscribe
    SET dia = REPLACE(dia,'2','martes');

UPDATE Inscribe
    SET dia = REPLACE(dia,'3','miercoles');

UPDATE Inscribe
    SET dia = REPLACE(dia,'4','jueves');

UPDATE Inscribe
    SET dia = REPLACE(dia,'5','viernes');
