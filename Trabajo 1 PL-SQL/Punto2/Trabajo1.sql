
CREATE OR REPLACE PROCEDURE consulta_producto
  (v_tipo_producto IN VARCHAR2)
  IS
  v_rec NUMBER;
  v_anio_venta NUMBER;
  v_marca VARCHAR2(100);
  v_total_pesos NUMBER;
  v_len NUMBER;
BEGIN
  -- Verificar si el tipo de producto existe
  SELECT COUNT(*)
  INTO v_rec
  FROM producto p,
      XMLTABLE('/Producto'
              PASSING p.p
              COLUMNS
                  Tipoprod VARCHAR2(100) PATH 'Tipoprod'
              ) x
  WHERE x.Tipoprod = v_tipo_producto;

  -- Si el tipo de producto no existe, imprimir "No existe" y salir del programa
  IF v_rec = 0 THEN
  DBMS_OUTPUT.PUT_LINE('No existe');
  RETURN;
  END IF;
  DBMS_OUTPUT.PUT_LINE('Informe para ' || v_tipo_producto || ' por año y marca: ' || CHR(10));
  -- Recorremos cada año
  FOR year_rec IN (
    SELECT DISTINCT EXTRACT(YEAR FROM TO_DATE(JSON_VALUE(j.jventa, '$.fecha' RETURNING VARCHAR2(10)), 'DD-MM-YYYY')) AS year
    FROM venta j
    ORDER BY year
  )
  LOOP
    v_anio_venta := year_rec.year;
    
    DBMS_OUTPUT.PUT_LINE(v_anio_venta);
    DBMS_OUTPUT.PUT_LINE('marca' || CHR(9) || CHR(9) || 'totalpesos');
    
    -- Recorremos cada marca
    FOR marca_rec IN (
      SELECT DISTINCT
        XMLCAST(
          XMLQUERY('/Producto/Marca' PASSING p RETURNING CONTENT) AS VARCHAR2(100)
        ) AS marca
      FROM producto,
           XMLTABLE('/Producto' PASSING p
             COLUMNS 
               marca VARCHAR2(100) PATH '/Producto/Marca',
               tipoprod VARCHAR2(100) PATH '/Producto/Tipoprod') t
      WHERE t.tipoprod = v_tipo_producto
    )
    LOOP
      v_marca := marca_rec.marca;
      v_total_pesos := 0;
      
      -- Sumamos los totales de ventas para la marca y tipo de producto en el año actual
      FOR venta_rec IN (SELECT t.*
                        FROM venta E, 
                            JSON_TABLE(E.jventa, '$.items[*]'
                            COLUMNS (codproducto NUMBER PATH '$.codproducto',
                                        totalpesos NUMBER PATH '$.totalpesos')
                            ) AS t 
                            WHERE EXTRACT(YEAR FROM TO_DATE(JSON_VALUE(E.jventa, '$.fecha' RETURNING VARCHAR2(10)), 'DD-MM-YYYY')) = v_anio_venta
                            AND t.codproducto IN ( SELECT x.plNro
                                                        FROM producto p,
                                                            XMLTABLE('/Producto' PASSING p.p
                                                                    COLUMNS 
                                                                        plNro VARCHAR2(200) PATH '@plNro',
                                                                        Marca VARCHAR2(200) PATH 'Marca',
                                                                        Tipoprod VARCHAR2(200) PATH 'Tipoprod'
                                                                    ) x
                                                        WHERE x.Marca = v_marca
                                                        AND x.Tipoprod = v_tipo_producto))
        LOOP
            v_total_pesos := v_total_pesos + TO_NUMBER(venta_rec.totalpesos);
        END LOOP;

      -- Imprimimos el resultado
      DBMS_OUTPUT.PUT_LINE(v_marca || CHR(9) || CHR(9) || v_total_pesos || CHR(13));
    END LOOP;
    
    -- Calculamos el total de los productos no registrados en la tabla producto
    v_total_pesos := 0;
    FOR venta_rec_non IN (SELECT t.*
                        FROM venta E, 
                            JSON_TABLE(E.jventa, '$.items[*]'
                            COLUMNS (codproducto NUMBER PATH '$.codproducto',
                                        totalpesos NUMBER PATH '$.totalpesos')
                            ) AS t 
                            WHERE EXTRACT(YEAR FROM TO_DATE(JSON_VALUE(E.jventa, '$.fecha' RETURNING VARCHAR2(10)), 'DD-MM-YYYY')) = v_anio_venta
                            AND t.codproducto NOT IN ( SELECT x.plNro
                                                        FROM producto p,
                                                            XMLTABLE('/Producto' PASSING p.p
                                                                    COLUMNS 
                                                                        plNro VARCHAR2(200) PATH '@plNro') x))
        LOOP
        v_total_pesos := v_total_pesos + TO_NUMBER(venta_rec_non.totalpesos);

    END LOOP;
    
    -- Imprimimos el total de los productos no registrados
    DBMS_OUTPUT.PUT_LINE('Total de los productos no registrados en la tabla producto: ' || v_total_pesos);
  END LOOP;
END;
/