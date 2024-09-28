CREATE OR REPLACE PROCEDURE consulta_ventas (
    p_mes IN NUMBER, p_year IN NUMBER) 
    IS
    ausente BOOLEAN := FALSE;
    consulta_ventas SYS_REFCURSOR;
    -- Cursor para obtener las ventas del mes y año especificados
    CURSOR c_ventas IS
        SELECT
            NVL(XMLCAST(XMLQUERY('/Cliente/Estrato' PASSING c.c RETURNING CONTENT) AS VARCHAR2(100)),'Ausente') AS estrato,
            NVL(XMLCAST(XMLQUERY('/Cliente/Genero' PASSING c.c RETURNING CONTENT) AS VARCHAR2(100)), 'Ausente') AS genero,
            NVL(SUM(TO_NUMBER(jv.totalpesos)), 0) AS totalpesos
        FROM venta j
        JOIN JSON_TABLE(j.jventa, '$.items[*]'
            COLUMNS (
                totalpesos VARCHAR2(100) PATH '$.totalpesos'
            )) jv ON 1=1
        LEFT JOIN cliente c ON JSON_VALUE(j.jventa, '$.codcliente') = TO_CHAR(XMLCAST(XMLQUERY('/Cliente/@clNro' PASSING c.c RETURNING CONTENT) AS VARCHAR2(100)))
        WHERE
            EXTRACT(MONTH FROM TO_DATE(JSON_VALUE(j.jventa, '$.fecha' RETURNING VARCHAR2(10)), 'DD-MM-YYYY')) = p_mes
            AND EXTRACT(YEAR FROM TO_DATE(JSON_VALUE(j.jventa, '$.fecha' RETURNING VARCHAR2(10)), 'DD-MM-YYYY')) = p_year
        GROUP BY
            NVL(XMLCAST(XMLQUERY('/Cliente/Estrato' PASSING c.c RETURNING CONTENT) AS VARCHAR2(100)),'Ausente'),
            NVL(XMLCAST(XMLQUERY('/Cliente/Genero' PASSING c.c RETURNING CONTENT) AS VARCHAR2(100)), 'Ausente')
        ORDER BY
            totalpesos DESC;

BEGIN
    IF p_year < 1900 OR p_year > 2024 OR p_mes < 1 OR p_mes > 12 THEN
        DBMS_OUTPUT.PUT_LINE('Fecha incorrecta');
        CLOSE consulta_ventas;
    END IF;
    -- Imprime la cabecera del informe
    DBMS_OUTPUT.PUT_LINE('Informe para ' || TO_CHAR(p_mes, 'FM00') || '-' || TO_CHAR(p_year) || ':');
    DBMS_OUTPUT.PUT_LINE('totalpesos' || CHR(9) || CHR(9) ||  'estrato' || CHR(9) || CHR(9) || 'genero');
    -- Recorre las ventas e imprime los detalles
    FOR r_venta IN c_ventas LOOP
        -- Imprime los detalles de la venta
        IF TO_CHAR(r_venta.estrato) = 'Ausente' THEN
            ausente:= TRUE ;
        END IF;
        IF TO_CHAR(r_venta.totalpesos) > 999999999 THEN
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(r_venta.totalpesos) || CHR(9) || TO_CHAR(r_venta.estrato) || CHR(9) || CHR(9) || r_venta.genero);
        ELSIF r_venta.totalpesos > 99999 THEN
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(r_venta.totalpesos) || CHR(9) || CHR(9) || TO_CHAR(r_venta.estrato) || CHR(9) || CHR(9) || r_venta.genero);
        ELSE
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(r_venta.totalpesos) || CHR(9) || CHR(9)  || CHR(9) || TO_CHAR(r_venta.estrato) || CHR(9) || CHR(9) || r_venta.genero);
        END IF;
    END LOOP;
    IF ausente = FALSE THEN
        DBMS_OUTPUT.PUT_LINE(0 || CHR(9) || CHR(9) || CHR(9)  || 'Ausente' || CHR(9) || CHR(9) || 'Ausente');
    END IF;
    
END;
/
EXECUTE consulta_ventas (11,2023);
EXECUTE consulta_ventas (8,2022);
EXECUTE consulta_ventas (10,2025);

