class LivroModel {
  final String? id;
  final String titulo;
  final String autor;

  // Construtor
  LivroModel({
    this.id,
    required this.titulo,
    required this.autor,
  });

  // Para converter em JSON
  Map<String, dynamic> toJson() {
    final data = {
      "titulo": titulo,
      "autor": autor,
    };
    if (id != null) data["id"] ;
    return data;
  }

  // Para criar a partir de JSON
  factory LivroModel.fromJson(Map<String, dynamic> json) {
    return LivroModel(
      id: json["id"]?.toString(),
      titulo: json["titulo"].toString(),
      autor: json["autor"].toString(),
    );
  }
}
