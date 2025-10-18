class Veiculo {
  //atributos -> 
  final int? id; //pode ser nulo, pois é o BD que vai dar o valor do id
  final String marca;
  final String modelo;
  final String ano;
  final String placa;
  final String kmInicial;

  //métodos -> Construtor
  Veiculo({
    this.id,
    required this.marca,
    required this.modelo,
    required this.ano,
    required this.placa,
    required this.kmInicial
  });

  //Métodos de Conversão de OBJ <=> BD
  //toMap: obj => BD
  Map<String,dynamic> toMap() {
    return{
      "id":id,
      "marca": marca,
      "modelo": modelo,
      "ano": ano,
      "placa": placa,
      "km_inicial":kmInicial
    };
  }

  //fromMap: BD => Obj
  factory Veiculo.fromMap(Map<String,dynamic> map){
    return Veiculo(
      id: map["id"] as int, //cast
      marca: map["nome"] as String, 
      modelo: map["raca"] as String, 
      ano: map["ano"] as String, 
      placa: map["placa"] as String, 
      kmInicial: map["km_inicial"] as String); 
  }
}