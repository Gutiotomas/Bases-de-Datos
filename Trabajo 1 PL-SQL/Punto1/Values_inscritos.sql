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


INSERT INTO cliente VALUES 
(3, XMLTYPE('<Cliente clNro="32">  
             <Estrato>5</Estrato>
             <Genero>m</Genero>
             </Cliente>'));

INSERT INTO cliente VALUES 
(4, XMLTYPE('<Cliente clNro="500">  
             <Estrato>88</Estrato>
             <Genero>x</Genero>
             </Cliente>'));

INSERT INTO cliente VALUES 
(5, XMLTYPE('<Cliente clNro="300">  
             <Estrato>3</Estrato>
             <Genero>x</Genero>
             </Cliente>'));

INSERT INTO cliente VALUES 
(6, XMLTYPE('<Cliente clNro="600">  
             <Estrato>6</Estrato>
             <Genero>m</Genero>
             </Cliente>'));

INSERT INTO cliente VALUES 
(7, XMLTYPE('<Cliente clNro="87">  
             <Estrato>7</Estrato>
             <Genero>m</Genero>
             </Cliente>'));

INSERT INTO cliente VALUES 
(8, XMLTYPE('<Cliente clNro="900">  
             <Estrato>7</Estrato>
             <Genero>x</Genero>
             </Cliente>'));

DROP TABLE producto;
CREATE TABLE producto(
id NUMBER(8) PRIMARY KEY,
p XMLTYPE NOT NULL);

INSERT INTO producto VALUES
(4, XMLTYPE('<Producto plNro="111">
<Marca></Marca>
<Tipoprod>Mueble de Oficina</Tipoprod>
</Producto>'));

INSERT INTO producto VALUES
(1, XMLTYPE('<Producto plNro="100">
<Marca>Micerdito Azul</Marca>
<Tipoprod>Carnico</Tipoprod>
</Producto>'));

INSERT INTO producto VALUES 
(2, XMLTYPE('<Producto plNro="123">  
             <Marca>Ikea</Marca>
             <Tipoprod>Mueble de Oficina</Tipoprod>
             </Producto>'));

INSERT INTO producto VALUES 
(3, XMLTYPE('<Producto plNro="155">  
             <Marca>Lino</Marca>
             <Tipoprod>Tela</Tipoprod>
             </Producto>'));

INSERT INTO producto VALUES 
(5, XMLTYPE('<Producto plNro="45">  
             <Marca>Mivaquita</Marca>
             <Tipoprod>Carnico</Tipoprod>
             </Producto>'));

DROP TABLE venta;

CREATE TABLE venta(
id NUMBER(8) PRIMARY KEY,
jventa JSON NOT NULL
);

INSERT INTO venta VALUES (1,
'{
"codventa":66,
"fecha":"29-11-2023",
"codcliente":445,
"items":[
{
"codproducto":100,
"nrounidades":3,
"totalpesos":75
},
{
"codproducto":111,
"nrounidades":1,
"totalpesos":1000
},
{
"codproducto":100,
"nrounidades":1,
"totalpesos":26
}
]
}'
);

INSERT INTO venta VALUES (2,
'{
"codventa":57,
"fecha":"05-08-2022",
"codcliente":800,
"items":[
{
"codproducto":100,
"nrounidades":6,
"totalpesos":400
},
{
"codproducto":111,
"nrounidades":3,
"totalpesos":745
},
{
"codproducto":123,
"nrounidades":2,
"totalpesos":45
}
]
}'
);

INSERT INTO venta VALUES (3,
'{
"codventa":30,
"fecha":"17-07-2021",
"codcliente":500,
"items":[
{
"codproducto":100,
"nrounidades":4,
"totalpesos":300
},
{
"codproducto":155,
"nrounidades":2,
"totalpesos":100
},
{
"codproducto":111,
"nrounidades":5,
"totalpesos":800
}
]
}'
);

INSERT INTO venta VALUES (4,
'{
"codventa":99,
"fecha":"09-05-2020",
"codcliente":32,
"items":[
{
"codproducto":102,
"nrounidades":3,
"totalpesos":50
},
{
"codproducto":11,
"nrounidades":2,
"totalpesos":40
},
{
      "codproducto": 123,
      "nrounidades": 1,
      "totalpesos": 2600
    },
{
"codproducto":111,
"nrounidades":5,
"totalpesos":800
}
]
}'
);

INSERT INTO venta VALUES (5,
'{
"codventa":10,
"fecha":"09-05-2020",
"codcliente":32,
"items":[
{
"codproducto":104,
"nrounidades":3,
"totalpesos":1300
},
{
"codproducto":100,
"nrounidades":2,
"totalpesos":500
},
{
      "codproducto": 123,
      "nrounidades": 3,
      "totalpesos": 4000
    },
{
"codproducto":111,
"nrounidades":5,
"totalpesos":40
}
]
}'
);

INSERT INTO venta VALUES (6,
'{
"codventa":52,
"fecha":"17-07-2021",
"codcliente":445,
"items":[
{
"codproducto":100,
"nrounidades":4,
"totalpesos":300
},
{
"codproducto":111,
"nrounidades":5,
"totalpesos":600
},
{
      "codproducto": 155,
      "nrounidades": 1,
      "totalpesos": 260
    },
{
"codproducto":11,
"nrounidades":3,
"totalpesos":400
}
]
}'
);

INSERT INTO venta VALUES (7,
'{
"codventa":78,
"fecha":"05-08-2022",
"codcliente":800,
"items":[
{
"codproducto":10,
"nrounidades":6,
"totalpesos":400
},
{
"codproducto":11,
"nrounidades":3,
"totalpesos":745
},
{
"codproducto":100,
"nrounidades":2,
"totalpesos":45
}
]
}'
);

INSERT INTO venta VALUES (8,
'{
"codventa":84,
"fecha":"29-11-2023",
"codcliente":87,
"items":[
{
"codproducto":104,
"nrounidades":3,
"totalpesos":598
},
{
"codproducto":111,
"nrounidades":6,
"totalpesos":3000
},
{
"codproducto":100,
"nrounidades":4,
"totalpesos":256
}
]
}'
);

INSERT INTO venta VALUES (9,
'{
"codventa":95,
"fecha":"09-05-2020",
"codcliente":445,
"items":[
{
"codproducto":102,
"nrounidades":3,
"totalpesos":13
},
{
"codproducto":11,
"nrounidades":2,
"totalpesos":403
},
{
      "codproducto": 123,
      "nrounidades": 1,
      "totalpesos": 260
    },
{
"codproducto":111,
"nrounidades":5,
"totalpesos":400
}
]
}'
);

INSERT INTO venta VALUES (10,
'{
"codventa":65,
"fecha":"05-08-2022",
"codcliente":500,
"items":[
{
"codproducto":100,
"nrounidades":6,
"totalpesos":4040
},
{
"codproducto":111,
"nrounidades":3,
"totalpesos":74
},
{
"codproducto":123,
"nrounidades":2,
"totalpesos":456
}
]
}'
);

INSERT INTO venta VALUES (11,
'{
"codventa":231,
"fecha":"12-11-2023",
"codcliente":32,
"items":[
{
"codproducto":104,
"nrounidades":3,
"totalpesos":5913
},
{
"codproducto":111,
"nrounidades":6,
"totalpesos":3034
},
{
"codproducto":100,
"nrounidades":4,
"totalpesos":2673
}
]
}'
);

INSERT INTO venta VALUES (12,
'{
"codventa":35,
"fecha":"18-07-2021",
"codcliente":900,
"items":[
{
"codproducto":100,
"nrounidades":4,
"totalpesos":300
},
{
"codproducto":155,
"nrounidades":2,
"totalpesos":100
},
{
"codproducto":111,
"nrounidades":5,
"totalpesos":800
}
]
}'
);

INSERT INTO venta VALUES (13,
'{
"codventa":786,
"fecha":"12-11-2023",
"codcliente":800,
"items":[
{
"codproducto":104,
"nrounidades":3,
"totalpesos":5913
},
{
"codproducto":111,
"nrounidades":6,
"totalpesos":3034
},
{
"codproducto":100,
"nrounidades":4,
"totalpesos":2673
}
]
}'
);

INSERT INTO venta VALUES (14,
'{
"codventa":785,
"fecha":"12-11-2023",
"codcliente":500,
"items":[
{
"codproducto":104,
"nrounidades":3,
"totalpesos":5913
},
{
"codproducto":111,
"nrounidades":6,
"totalpesos":3034
},
{
"codproducto":100,
"nrounidades":4,
"totalpesos":2673
}
]
}'
);
