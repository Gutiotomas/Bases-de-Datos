---- casamatriz
DROP TABLE casahija;
DROP TABLE casamatriz;
CREATE TABLE casamatriz(
id NUMBER(8) PRIMARY KEY,
capitalp NUMBER(8) NOT NULL CHECK(capitalp > 0)
);
-- Ejemplos
INSERT INTO casamatriz VALUES(1, 1000);
INSERT INTO casamatriz VALUES(2, 2000);
INSERT INTO casamatriz VALUES(3, 1000);

---- casahija
DROP TABLE casahija;
CREATE TABLE casahija(
id NUMBER(8) PRIMARY KEY,
capitalh NUMBER(8) NOT NULL CHECK(capitalh > 0),
casapadre NUMBER(8) NOT NULL REFERENCES casamatriz
);

INSERT INTO casahija VALUES(1, 300, 1);
INSERT INTO casahija VALUES(2, 300, 1);
INSERT INTO casahija VALUES(3, 350, 1);
INSERT INTO casahija VALUES(4, 400, 2);
INSERT INTO casahija VALUES(5, 1500, 2);