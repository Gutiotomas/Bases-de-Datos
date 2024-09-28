/*
Punto 3
Cuando se vaya a aumentar el capital de una casa hija (o sea, capitalh), se debe controlar que la
suma del capital de las hijas (de una misma casa matriz) no supere el capital de su
correspondiente casa matriz. En el ejemplo, si se sube el capital de la casa hija número 1 de 300
a 400 se rechaza, pero si se sube por ejemplo a 349 se acepta.

UPDATE casahija SET capitalh = 200 WHERE id = 1;

*/

CREATE OR REPLACE TRIGGER punto3
FOR UPDATE OF capitalh ON casahija
COMPOUND TRIGGER
  -- DEFINO VARIABLES PARA TODO EL TRIGGER

  --cursor que me contiene los resultados de esta consulta (casapadre, capital)
  CURSOR cursor_casahija IS 
  SELECT casapadre,SUM(capitalh) as capital FROM casahija GROUP BY casapadre;
  
  saldo_matriz casamatriz.capitalp%TYPE; -- Declaro un saldo
  TYPE t_capital IS TABLE OF NUMBER(8) INDEX BY BINARY_INTEGER; -- Declaro un tipo de arreglo
  arreglo_capital t_capital; -- Declaro el arreglo con el tipo que cree arriba

  before statement is
      begin
      -- Por cada casapadre que haya, puedo sacar entonces el valor total de las hijas
      FOR fila IN cursor_casahija LOOP
        -- Lo deposito en el array, con el indice casapadre (este es unico por el group by)
        arreglo_capital(fila.casapadre) := fila.capital;
        -- Esto porque si uso el cursor en las operaciones de fila, devuelve error tabla mutante
      END LOOP;
  end  before statement;
      
  before each row is
      begin
      -- Aqui puedo hacer esta busqueda porque no es de la tabla que se hace actualización
      SELECT capitalp INTO saldo_matriz FROM casamatriz WHERE ID = :OLD.casapadre;
      -- Reviso la condición
      IF :NEW.capitalh - :OLD.capitalh + arreglo_capital(:NEW.casapadre) > saldo_matriz THEN
          RAISE_APPLICATION_ERROR(-20003,'¡Supera el valor de la casa matriz!');
      END IF;

  end before each row;
end;
/