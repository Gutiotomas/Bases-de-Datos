/*
Punto 2
Cuando se vaya a disminuir el capital de una casa matriz (o sea, capitalp), se debe garantizar que
el nuevo capital de la casa matriz sea mayor o igual que la suma del capital de sus hijas. En los
ejemplos anteriores, si se baja el capital (capitalp) de la casa matriz 1 a 990 se acepta (en el
ejemplo la suma de las hijas de la casa 1 es 950), pero si se baja el capital (capitalp) a 949 se
rechaza.

UPDATE casamatriz SET  capitalp = 5000 WHERE id = 1;
*/

-- casahija(id NUMBER,capitalh NUMBER,casapadre NUMBER);

CREATE OR REPLACE TRIGGER control_disminucion_capitalp_casamatriz
BEFORE UPDATE OF capitalp ON casamatriz
FOR EACH ROW
DECLARE
  saldo_total_hijas casahija.capitalh%TYPE;
BEGIN
  SELECT SUM(capitalh) INTO saldo_total_hijas FROM casahija WHERE casapadre=:OLD.id;
  
  IF :NEW.capitalp < saldo_total_hijas THEN
    DBMS_OUTPUT.PUT_LINE('Saldo con que quedaria: ' || :NEW.capitalp);
    DBMS_OUTPUT.PUT_LINE('Saldo total de las hijas: ' || saldo_total_hijas);
    RAISE_APPLICATION_ERROR(-20002,'Valor menor a la suma de las casas hijas');
  END IF;
END;
/