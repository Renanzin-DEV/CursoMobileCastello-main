import '../models/livro_model.dart';
import '../services/api_service.dart';

class UsuarioController {

  //métodos

  //GET - All
  Future<List<LivroModel>> fetchAll() async{
    final list = await ApiService.getList("livros?_sort=nome");//ordenando pelo nome A->Z
    //retorna a Lista de Usuários (Json) Convertida para Usuario Model(DART)
    return list.map<LivroModel>((item)=>LivroModel.fromJson(item)).toList(); 
  }

  //GET - One
  Future<LivroModel> fetchOne(String id) async{
    final livro = await ApiService.getOne("livros", id);
    return LivroModel.fromJson(livro);
  }

  //POST
  Future<LivroModel> create(LivroModel u) async{
    final created = await ApiService.post("livros", u.toJson());
    //adicionar o usuário e retorna o usuario adicionado
    return LivroModel.fromJson(created);
  }

  //PUT
  Future<LivroModel> update(LivroModel u) async{
    final updated = await ApiService.put("livros", u.toJson(), u.id!);
    //retorna o usuário atualizado
    return LivroModel.fromJson(updated);
  }

  //DELETE
  Future<void> delete(String id) async{
    await ApiService.delete("livros", id);
    //não tem retorno
  }
}