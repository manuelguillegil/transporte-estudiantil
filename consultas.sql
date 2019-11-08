--- 1. ¿Quiénes son los estudiantes que sabemos necesitan llegar en el Transporte Universitario
-- a las 8:00 los jueves desde cada parada (por tener clase)?: 134
SELECT DISTINCT e.ruta, e.nombres, e.apellidos, e.carnet, e.cedula 
FROM Estudiantes AS e JOIN Inscribe AS i ON i.carnet_estudiante = e.carnet
WHERE i.inicio = '1' AND i.dia = 'jueves' AND e.transporte = 'Transporte Universitario'
ORDER BY e.ruta;

-- 2. ¿Cuántos estudiantes adicionales se pueden esperar en cada parada a esa hora?
SELECT e.ruta, COUNT(*)
    FROM Estudiantes e, Horario_Llegada hl, Inscribe i
    WHERE hl.carnet_estudiante = e.carnet AND hl.dia = 'jueves' AND
          hl.hora = '8:00'::TIME AND 
          NOT EXISTS (SELECT *
                      FROM Inscribe i
                      WHERE i.carnet_estudiante = e.carnet AND i.dia = 'jueves' AND
                            inicio = '1')
    GROUP BY e.ruta;

-- 3. ¿Cuántos estudiantes deben llegar los jueves en Transporte Universitario a cada hora de
-- cada cohorte? (es decir, cuál cohorte es la mayor usuaria del Transporte Universitario)

SELECT substring(e.carnet, 1, 2), i.inicio, COUNT(*)
    FROM Estudiantes AS e JOIN Inscribe AS i ON i.carnet_estudiante = e.carnet
    WHERE i.dia = 'jueves' AND e.transporte = 'Transporte Universitario'
    GROUP BY substring(e.carnet, 1, 2), i.inicio;

-- 4. ¿Cuántos estudiantes se pueden esperar que usen el transporte universitario ese día?


