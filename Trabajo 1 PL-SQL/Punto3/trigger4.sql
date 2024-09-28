-- casamatriz(id NUMBER,capitalp NUMBER);
-- casahija(id NUMBER,capitalh NUMBER,casapadre NUMBER);

/*
Punto 4
a - Se debe controlar adicionalmente para la inserción, que el máximo número de hijas que una
casa matriz pueda tener es 5.

b- Además, para la actualización no se permite que una casa hija se
cambie de casa matriz.
*/

CREATE OR REPLACE TRIGGER punto4
BEFORE INSERT OR UPDATE ON casahija
FOR EACH ROW
DECLARE
  cantidad_hijas_casa NUMBER(8);
BEGIN
  ---PUNTO A
  IF INSERTING THEN
    SELECT COUNT(id) INTO cantidad_hijas_casa FROM casahija WHERE  casapadre = :NEW.casapadre;
    IF cantidad_hijas_casa > 4 THEN
      RAISE_APPLICATION_ERROR(-20004,'¡Muchas hijas ya en esa casa!');
    END IF;
  END IF;
  ---PUNTO B
  IF UPDATING('casapadre') THEN
      RAISE_APPLICATION_ERROR(-20004,'¡No te puedes salir de esta casa! >=C');
  END IF;
END;
/

/*
---PUNTO A

DELETE casahija;
INSERT INTO casahija VALUES(1, 300, 1);
INSERT INTO casahija VALUES(2, 300, 1);
INSERT INTO casahija VALUES(3, 350, 1);
INSERT INTO casahija VALUES(4, 400, 2);
INSERT INTO casahija VALUES(5, 1500, 2);

INSERT INTO casahija VALUES(6, 10, 1);
INSERT INTO casahija VALUES(7, 10, 1);
INSERT INTO casahija VALUES(8, 10, 1);

INSERT INTO casahija VALUES(80, 10, 1);

SELECT COUNT(id) FROM casahija;
SELECT * FROM casahija;

---PUNTO B

UPDATE casahija SET  CASAPADRE = 2 WHERE id = 1;
UPDATE casahija SET  CASAPADRE = 2 WHERE id = 2;
UPDATE casahija SET  CASAPADRE = 2 WHERE id = 3;
UPDATE casahija SET  CASAPADRE = 1 WHERE id = 4;
*/