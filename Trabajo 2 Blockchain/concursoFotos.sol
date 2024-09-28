// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract concursoGaleria {
    address public organizador;
    address public juez;
    uint public valorBolsa;
    uint public costoInscripcion;

    enum Estado { Creado, Iniciado, CerradoInscripciones, Juzgado, Inactivo }
    Estado public estado;

    event concursoCreado();
    event concursoIniciado();
    event inscripcionesCerradas();
    event fotosJuzgadas();
    event concursoInactivo();

    struct obraArte {
        address artista;
        string nombre;
        string url;
        uint puntuacion;
        string comentario;
        bool enviada;
    } 

    obraArte[] private obras;
    
    // Mappings para evitar registros duplicados
    mapping(address => bool) internal artistaRegistrado;

    mapping(string => bool) internal obraRegistrada;

    modifier soloOrganizador() {
        require(msg.sender == organizador, "No es el organizador");
        _;
    }

    modifier soloJuez() {
        require(msg.sender == juez, "No es el juez");
        _;
    }

    modifier enEstado(Estado _estado) {
        require(estado == _estado, "Estado invalido");
        _;
    }

    constructor() payable {
        // Condición de rango
        require(msg.value >= 1 ether && msg.value <= 90 ether, "Para la creacion del concurso se requiere depositar un valor entre 1 y 90 ethers");
        
        // Condición de número entero
        require(msg.value % 1 ether == 0, "El numero de ethers debe ser entero");
        
        // Condición de valor par
        require((msg.value / 1 ether) % 2 == 0, "El valor en ethers debe ser par");

        organizador = msg.sender;
        valorBolsa = msg.value;
        costoInscripcion = valorBolsa / 2;
        estado = Estado.Creado;
        emit concursoCreado();
    }

    function nombrarJurado(address _juez) public soloOrganizador enEstado(Estado.Creado) {
        require(_juez != organizador, "El juez no puede ser el organizador");
        juez = _juez;
        estado = Estado.Iniciado;
        emit concursoIniciado();
    }

    function registrarObra(string memory _nombre, string memory _url) public payable enEstado(Estado.Iniciado) {
        // Verificar que el pago sea correcto
        require(msg.value == costoInscripcion, "La tarifa de registro debe ser igual a la mitad del valorBolsa");
        
        // Verificar que el remitente no sea el jurado ni el organizador
        require(msg.sender != juez, "El jurado no puede participar en el concurso");
        require(msg.sender != organizador, "El organizador no puede participar en el concurso");
        
        // Verificar que el artista no haya registrado previamente una obra
        require(!artistaRegistrado[msg.sender], "El artista ya ha registrado una obra");
        
        // Verificar que la obra (URL) no haya sido registrada previamente
        require(!obraRegistrada[_url], "Esta obra ya ha sido registrada en el concurso");

        // Verificar que no se haya alcanzado el máximo de obras permitidas
        require(obras.length < 6, "Se ha alcanzado el numero maximo de obras permitidas");
        
        // Registrar la obra
        obras.push(obraArte({
            artista: msg.sender,
            nombre: _nombre,
            url: _url,
            puntuacion: 0,
            comentario: "",
            enviada: true
        }));
        
        // Actualizar mappings para evitar registros duplicados
        artistaRegistrado[msg.sender] = true;
        obraRegistrada[_url] = true;

        // Update the prize pool
        valorBolsa += msg.value;
    }

    function cerrarInscripciones() public soloOrganizador enEstado(Estado.Iniciado) {
        require(obras.length >= 4 && obras.length <= 6, "El concurso debe tener entre 4 y 6 obras para cerrar las inscripciones");
        estado = Estado.CerradoInscripciones;
        emit inscripcionesCerradas();
    }

    // Consultar una obra
    function revisarObra(uint _index) public soloJuez enEstado(Estado.CerradoInscripciones) view returns (string memory nombre, string memory url) {
        require(_index < obras.length, "Index de obra invalida");
        
        // Accedemos a la obra en la posición indicada por _index
        nombre = obras[_index].nombre;
        url = obras[_index].url;
        
        return (nombre, url);
    }

    function juzgarObras(uint _index, uint _puntuacion, string memory _comentario) public soloJuez enEstado(Estado.CerradoInscripciones) {
        require(_index < obras.length, "Indice de obra invalido");
        require(_puntuacion >= 1 && _puntuacion <= 10, "Puntuacion invalida");

        // Verifica que la obra no haya sido evaluada previamente (sin comentario)
        require(bytes(obras[_index].comentario).length == 0, "La obra ya ha sido juzgada");
        
        for (uint i = 0; i < obras.length; i++) {
            require(obras[i].puntuacion != _puntuacion, "No se permiten puntuaciones duplicadas");
        }
        // Asignar puntuación y comentario
        obras[_index].puntuacion = _puntuacion;
        obras[_index].comentario = _comentario;
    }

    function reconsiderarPuntuacion(uint _index, uint _puntuacion) public soloJuez enEstado(Estado.CerradoInscripciones) {
        require(_index < obras.length, "Indice de obra invalido");
        require(_puntuacion >= 1 && _puntuacion <= 10, "Puntuacion invalida");

        // Verifica que la obra haya sido juzgada previamente (con comentario)
        require(bytes(obras[_index].comentario).length > 0, "La obra aun no ha sido juzgada");

        for (uint i = 0; i < obras.length; i++) {
            require(obras[i].puntuacion != _puntuacion, "No se permiten puntuaciones duplicadas");
        }

        // Modificar la puntuación de la obra
        obras[_index].puntuacion = _puntuacion;
    }

    function obrasJuzgadas() internal view returns (bool) {
        for (uint i = 0; i < obras.length; i++) {
            if (obras[i].puntuacion == 0) {
                return false;
            }
        }
        return true;
    }
        
    function finalizarJuzgamiento() public soloJuez enEstado(Estado.CerradoInscripciones) {
        require(obrasJuzgadas(), "No todas las obras han sido juzgadas");
        estado = Estado.Juzgado;
        emit fotosJuzgadas();
    }   

    function obtenerIndexOrganizados() internal view returns (uint[] memory) {
        uint[] memory indexes = new uint[](obras.length);
        for (uint i = 0; i < obras.length; i++) {
            indexes[i] = i;
        }

        for (uint i = 0; i < indexes.length; i++) {
            for (uint j = i + 1; j < indexes.length; j++) {
                if (obras[indexes[j]].puntuacion > obras[indexes[i]].puntuacion) {
                    uint temp = indexes[i];
                    indexes[i] = indexes[j];
                    indexes[j] = temp;
                }
            }
        }

        return indexes;
    }

    function distribuirPremios() public soloOrganizador enEstado(Estado.Juzgado) {
    require(address(this).balance >= valorBolsa, "Balance insuficiente para repartir los premios");

    uint[] memory indexOrganizados = obtenerIndexOrganizados();
    uint primerPremio = (valorBolsa * 50) / 100;
    uint segundoPremio = (valorBolsa * 25) / 100;
    uint tercerPremio = (valorBolsa * 10) / 100;
    uint serviciosJuez = (valorBolsa * 15) / 100;

    require(payable(obras[indexOrganizados[0]].artista).send(primerPremio), "Transferencia al primer lugar fallida");
    require(payable(obras[indexOrganizados[1]].artista).send(segundoPremio), "Transferencia al segundo lugar fallida");
    require(payable(obras[indexOrganizados[2]].artista).send(tercerPremio), "Transferencia al tercer lugar fallida");
    require(payable(juez).send(serviciosJuez), "Transferencia al juez fallida");

    estado = Estado.Inactivo;
    emit concursoInactivo();
    }

    function primerPuesto() public view enEstado(Estado.Inactivo) returns (address artista, string memory nombre, string memory url,  uint premio, string memory comentario) {
        uint[] memory indexOrganizados = obtenerIndexOrganizados();
        uint index = indexOrganizados[0];

        nombre = obras[index].nombre;
        url = obras[index].url;
        artista = obras[index].artista;
        premio = (valorBolsa * 50) / 100;
        comentario = obras[index].comentario;

        return (artista, nombre, url, premio, comentario);
    }

    function segundoPuesto() public view enEstado(Estado.Inactivo) returns (address artista, string memory nombre, string memory url,  uint premio, string memory comentario) {
        uint[] memory indexOrganizados = obtenerIndexOrganizados();
        uint index = indexOrganizados[1];

        nombre = obras[index].nombre;
        url = obras[index].url;
        artista = obras[index].artista;
        premio = (valorBolsa * 25) / 100;
        comentario = obras[index].comentario;

        return (artista, nombre, url, premio, comentario);
    }

    function tercerPuesto() public view enEstado(Estado.Inactivo) returns (address artista, string memory nombre, string memory url,  uint premio, string memory comentario) {
        uint[] memory indexOrganizados = obtenerIndexOrganizados();
        uint index = indexOrganizados[2];

        nombre = obras[index].nombre;
        url = obras[index].url;
        artista = obras[index].artista;
        premio = (valorBolsa * 10) / 100;
        comentario = obras[index].comentario;

        return (artista, nombre, url, premio, comentario);
    }
}
