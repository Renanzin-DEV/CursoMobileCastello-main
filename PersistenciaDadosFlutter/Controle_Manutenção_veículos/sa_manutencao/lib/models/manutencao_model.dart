



import 'package:intl/intl.dart';

class Manutencao {
  final int? id; //pode ser nulo
  final int veiculoId; //chave estrangeira
  final String tipoServico;
  final DateTime dataHora;
  final String kmAtual;
  final String custo;
  final String observacao;

  Manutencao({ //construtor
    this.id,
    required this.veiculoId,
    required this.tipoServico,
    required this.dataHora,
    required this.kmAtual,
    required this.custo,
    required this.observacao,
  });

  // toMap : Obj => BD
  Map<String, dynamic> toMap() => {
    "id": id,
    "veiculo_id": veiculoId,
    "tipo_servico": tipoServico,
    "data_hora": dataHora
        .toIso8601String(), // padrão internacional de hora para BD
    "km_atual": kmAtual,
    "custo": custo,
    "observacao": observacao,
  };

  //fromMap() : BD => obj
  factory Manutencao.fromMap(Map<String, dynamic> map) => 
  Manutencao(
    id: map["id"] as int,
    veiculoId: map["veiculo_id"] as int,
    tipoServico: map["tipo_servico"] as String,
    dataHora: DateTime.parse(map["data_hora"] as String),
    kmAtual: map["km_atual"] as String,
    custo: map["custo"] as String,
    observacao: map["observação"] as String,

  );

  // método de conversão de Data e hora para formato BR

  String get dataHoraLocal {
    final local = DateFormat("dd/MM/yyyy HH:mm");
    return local.format(dataHora);
  }
}




