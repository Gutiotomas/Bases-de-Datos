/*
Punto 1
Cuando se vaya a insertar una fila en casahija, se debe verificar que la suma de los capitales de
todas las hijas de una misma casa matriz no supere el capital de la casa matriz. Considerando los
ejemplos anteriores, si se va a insertar la siguiente fila en casahija:
INSERT INTO casahija VALUES(9, 125, 2);

El trigger debe impedir esta inserción porque la suma de las hijas de la casa 2 daría: 2025 y la
casa matriz número 2 solamente tiene un capital de 2000. Ahora si se fuese a insertar la
siguiente fila en casahija:
INSERT INTO casahija VALUES(11, 80, 2);
Esta inserción SÍ se acepta porque la suma daría 1980 la cual es menor que 2000.
*/

-- casahija(id NUMBER,capitalh NUMBER,casapadre NUMBER);

CREATE OR REPLACE TRIGGER control_insercion_casahijas
BEFORE INSERT ON casahija
FOR EACH ROW
DECLARE
  saldo_matriz casamatriz.capitalp%TYPE;
  saldo_total_hijas casahija.capitalh%TYPE;
BEGIN
  SELECT SUM(capitalh) INTO saldo_total_hijas FROM casahija WHERE casapadre = :NEW.casapadre;
  SELECT capitalp INTO saldo_matriz FROM casamatriz WHERE ID = :NEW.casapadre;

  IF saldo_matriz < saldo_total_hijas + :NEW.capitalh THEN
    RAISE_APPLICATION_ERROR(-20001,'¡Supera el valor de la casa matriz!');
  END IF;
END;
/

---
SELECT SUM(capitalh) FROM casahija WHERE casapadre = 2;
INSERT INTO casahija VALUES(6, 500, 2);