DROP TABLE cliente;
CREATE TABLE cliente(
  id NUMBER(8) PRIMARY KEY,
  c XMLTYPE NOT NULL);

INSERT INTO cliente VALUES 
(1, XMLTYPE('<Cliente clNro="445">  
             <Estrato>5</Estrato>
             <Genero>m</Genero>
             </Cliente>'));

INSERT INTO cliente VALUES 
(2, XMLTYPE('<Cliente clNro="800">  
             <Estrato>88</Estrato>
             <Genero>x</Genero>
             </Cliente>'));



DROP TABLE producto;
CREATE TABLE producto(
  id NUMBER(8) PRIMARY KEY,
  p XMLTYPE NOT NULL);

INSERT INTO producto VALUES 
(1, XMLTYPE('<Producto plNro="100">  
             <Marca>Micerdito Azul</Marca>
             <Tipoprod>Carnico</Tipoprod>
             </Producto>'));

INSERT INTO producto VALUES 
(2, XMLTYPE('<Producto plNro="155">  
             <Marca>Lino</Marca>
             <Tipoprod>Tela</Tipoprod>
             </Producto>'));

INSERT INTO producto VALUES 
(3, XMLTYPE('<Producto plNro="111">  
             <Marca>Acme</Marca>
             <Tipoprod>Mueble de Oficina</Tipoprod>
             </Producto>'));

INSERT INTO producto VALUES 
(4, XMLTYPE('<Producto plNro="123">  
             <Marca>Ikea</Marca>
             <Tipoprod>Mueble de Oficina</Tipoprod>
             </Producto>'));



DROP TABLE venta;
CREATE TABLE venta(
  id  NUMBER(8) PRIMARY KEY,
  jventa JSON NOT NULL
);


INSERT INTO venta VALUES (1,
'{
  "codventa": 66,
  "fecha": "29-11-2023",
  "codcliente": 445,
  "items": [
    {
      "codproducto": 100,
      "nrounidades": 3,
      "totalpesos": 75
    },
    {
      "codproducto": 111,
      "nrounidades": 1,
      "totalpesos": 1000
    },
    {
      "codproducto": 100,
      "nrounidades": 1,
      "totalpesos": 26
    }
  ]
}'
);
INSERT INTO venta VALUES (2,
'{
  "codventa": 67,
  "fecha": "29-11-2022",
  "codcliente": 445,
  "items": [
    {
      "codproducto": 100,
      "nrounidades": 3,
      "totalpesos": 75
    },
    {
      "codproducto": 111,
      "nrounidades": 1,
      "totalpesos": 1000
    },
    {
      "codproducto": 100,
      "nrounidades": 1,
      "totalpesos": 26
    }
  ]
}'
);
INSERT INTO venta VALUES (3,
'{
  "codventa": 68,
  "fecha": "29-10-2022",
  "codcliente": 445,
  "items": [
    {
      "codproducto": 100,
      "nrounidades": 3,
      "totalpesos": 75
    },
    {
      "codproducto": 111,
      "nrounidades": 1,
      "totalpesos": 1000
    },
    {
      "codproducto": 100,
      "nrounidades": 1,
      "totalpesos": 26
    }
  ]
}'
);
INSERT INTO venta VALUES (4,
'{
  "codventa": 50,
  "fecha": "29-09-2022",
  "codcliente": 445,
  "items": [
    {
      "codproducto": 100,
      "nrounidades": 3,
      "totalpesos": 75
    },
    {
      "codproducto": 111,
      "nrounidades": 1,
      "totalpesos": 1000
    },
    {
      "codproducto": 123,
      "nrounidades": 1,
      "totalpesos": 2600
    }
  ]
}'
);
INSERT INTO venta VALUES (5,
'{
  "codventa": 69,
  "fecha": "20-02-2023",
  "codcliente": 445,
  "items": [
    {
      "codproducto": 123,
      "nrounidades": 3,
      "totalpesos": 4000
    },
    {
      "codproducto": 111,
      "nrounidades": 1,
      "totalpesos": 1000
    },
    {
      "codproducto": 100,
      "nrounidades": 1,
      "totalpesos": 26
    }
  ]
}'
);

INSERT INTO venta VALUES (6,
'{
  "codventa": 69,
  "fecha": "20-02-2022",
  "codcliente": 445,
  "items": [
    {
      "codproducto": 155,
      "nrounidades": 3,
      "totalpesos": 400
    },
    {
      "codproducto": 111,
      "nrounidades": 1,
      "totalpesos": 100
    },
    {
      "codproducto": 123,
      "nrounidades": 1,
      "totalpesos": 200
    },
    {
      "codproducto": 70,
      "nrounidades": 1,
      "totalpesos": 260
    },
    {
      "codproducto": 155,
      "nrounidades": 1,
      "totalpesos": 260
    },
    {
      "codproducto": 155,
      "nrounidades": 1,
      "totalpesos": 500
    }
  ]
}'
);
