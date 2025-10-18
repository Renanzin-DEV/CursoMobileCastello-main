//& classe para gerenciar o relacionamento do modelo com a interface

import 'dart:io';

import 'package:cine_favorite/models/favorite_movie_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FavoriteMovieController {
  //* atributos
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  //* criar um user => método para buscar o usuário logado
  User? get currentUser => _auth.currentUser;

  //& métodos

  //* adicionar favorito
  void addFavorite(Map<String, dynamic> movieData) async {
    final imagemUrl =
        "https://image.tmdb.org/t/p/w500${movieData["poster_path"]}"; // https://image.tmdb.org/t/p/w500/6vbxUh6LWHGhfuPI7GrimQaXNsQ.jpg

    final responseImg = await http.get(Uri.parse(imagemUrl));
    // armazenar a imagem no dispositivo
    final imagemDir = await getApplicationDocumentsDirectory();
    final imagemFile = File("${imagemDir.path}/${movieData["id"]}.jpg");
    await imagemFile.writeAsBytes(responseImg.bodyBytes);

    // criar o OBJ no DB
    final movie = FavoriteMovie(
      id: movieData["id"], 
      title: movieData["title"], 
      posterPath: imagemFile.path.toString()); //arrumar o endereço da imagem

    // adicioanr o OBj ao FireStore
    await _db
        .collection("users")
        .doc(currentUser!.uid)
        .collection("favorite_movies")
        .doc(movie.id.toString())
        .set(movie.toMap());
  }

  //! deletar favorito
  void removeFavoriteMovie(int movieId) async {
    if (currentUser == null) return;
    await _db
        .collection("users")
        .doc(currentUser!.uid)
        .collection("favorite_movies")
        .doc(movieId.toString())
        .delete();

    final imagemPath = await getApplicationDocumentsDirectory();
    final imagemFile = File("${imagemPath.path}$movieId.jpg");
    try {
      await imagemFile.delete();
    } catch (e) {
      print("erro ao deletar img");
    }
  }

  //? atualizar avaliação de favorito
  void updateMovieRating (int movieId, double rating) async{
    if(currentUser == null) return;
    await _db.collection("users").doc(currentUser!.uid).collection("favorite_movies")
    .doc(movieId.toString()).update({"rating":rating});
  }

  //? listar favorito
  Stream<List<FavoriteMovie>> getFavoriteMovies() {
    // Stream => listener/ouvinte, pega a lista de favoritos sempre que ela for modificada
    // verifica se o usuário existe
    if (currentUser == null) return Stream.value([]); // retorna a lista vazia caso não tenha usuário

    return _db
        .collection("users")
        .doc(currentUser!.uid)
        .collection("favorite_movies")
        .snapshots()
        .map(
          (e) => e.docs.map((i) => FavoriteMovie.fromMap(i.data())).toList(),
        );
  }
}
