import 'package:sa_manutencao/models/veiculo_model.dart';
import 'package:sa_manutencao/services/db_helper.dart';

class VeiculoController {
  final DbHelper _dbHelper = DbHelper();

  //métodos do controller - Slim (magros)
  Future<int> createPet(Veiculo pet) async{
    return await _dbHelper.insertVeiculo(veiculo);
  }

  Future<List<Veiculo>> readPets() async{
    return await _dbHelper.getPets();
  }

  Future<Veiculo?> readVeiculobyId(int id) async{
    return await _dbHelper.getVeiculobyId(id);
  }

  Future<int> deletePet(int id) async{
    return await _dbHelper.deleteVeiculo(id);
  }
}
