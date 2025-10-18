class ClimaModel {
  //atributos
  final String cidade;
  final double temperatura;
  final String descricao;

  //construtor
  ClimaModel({
    required this.cidade,
    required this.temperatura,
    required this.descricao,
  });

  //factory
  factory ClimaModel.fromjson(Map<String, dynamic> json) {
    return ClimaModel(
      cidade: json["name"],
      temperatura: json["main"]["temp"].toDouble(),
      descricao: json["weather"][0]["description"],
    );
  }

  static Future<ClimaModel?> fromJson(dados) async {}
}
