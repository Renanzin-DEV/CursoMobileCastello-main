//& classe de modelagem de dados para Movie

class FavoriteMovie {
  //* atributos
  final int id; // from TMDB
  final String title; // from TMDB
  final String posterPath; // caminho para imagem do poster
  double rating; // nota do usuário

  //* construtor
  FavoriteMovie({
    required this.id,
    required this.title,
    required this.posterPath,
    this.rating = 0,
  });

  //* métodos de conversão de OBJ <=> Json

  //? toMap
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "posterPath": posterPath,
      "rating": rating,
    };
  }

  //? fromMap
  factory FavoriteMovie.fromMap(Map<String, dynamic> map) {
    return FavoriteMovie(
      id: map["id"],
      title: map["title"],
      posterPath: map["posterPath"],
      rating: (map["rating"] as num).toDouble(),
    );
  }
}
