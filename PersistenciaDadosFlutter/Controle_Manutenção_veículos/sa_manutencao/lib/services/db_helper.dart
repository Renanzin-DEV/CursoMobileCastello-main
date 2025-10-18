//clase de apoio a conexões do banco de dados
//classe Singleton -> de objeto unico




import 'package:path/path.dart';
import 'package:sa_manutencao/models/manutencao_model.dart';
import 'package:sa_manutencao/models/veiculo_model.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _database; //obj para criar as conexões com o BD
  //transformar a classe em Singleton
  // não permite instanciar outro objeto enquanto um obj estiver ativo
  static final DbHelper _instance = DbHelper._internal();
  //construtor para o singleton
  DbHelper._internal();
  factory DbHelper() => _instance;

  //fazer as conexões com o BD
  Future<Database> get database  async{
    if (_database != null){
      return _database!;
    }else{
      _database =  await _initDatabase();
      return _database!;
    }
  }

  Future<Database> _initDatabase() async{
    //pegar o endereco do Banco de Dados
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,"petshop.db");//caminho completo para o BD

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateDB
    );
  }

  Future<void> _onCreateDB(Database db, int version) async{
    //Criar a Tabel dos pets
    await db.execute(
      """CREATE TABLE IF NOT EXISTS veiculos(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      raca TEXT NOT NULL,
      nome_dono TEXT NOT NULL,
      telefone TEXT NOT NULL
      )"""
    );
    print("tabela pet criada");
    //criar a tabela das Consultas
    await db.execute(
      """CREATE TABLE IF NOT EXISTS consultas(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      pet_id INTEGER NOT NULL,
      data_hora TEXT NOT NULL,
      tipo_servico TEXT NOT NULL,
      observacao TEXT,
      FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE
      )"""
    );
    print("tabela consultas criada");
  }

  // métodos CRUD para pets
  Future<int> insertPet(Veiculo veiculo) async{
    final db = await database;
    return await db.insert("veiculos", veiculo.toMap()); //retorna o id do Pet
  }

  Future<List<Veiculo>> getPets() async{
    final db = await database;
    final List<Map<String,dynamic>> maps = await db.query("pets"); //receber as info do BD
    //converter os valores para obj
    return maps.map((e)=>Veiculo.fromMap(e)).toList();
  }

  Future<Veiculo?> getPetbyId(int id) async{
    final db = await database;
    final List<Map<String,dynamic>> maps = 
      await db.query("veiculos", where: "id=?", whereArgs: [id]);
    //se Encontrado
    if(maps.isNotEmpty){
      return Veiculo.fromMap(maps.first); //cria o obj com 1º elemento da lista
    }else{
      return null;
    }
  }

  Future<int> deleteVeiculos(int id) async{
    final db = await database;
    return await db.delete("veiculos", where: "id=?",whereArgs: [id]);
    //deleta o pet da tabela que tenha o id igual o enviado como parâmetro
  }

  // métodos crud para Consultas
  //Create Consulta
  Future<int> insertConsulta(Manutencao manutencao) async{
    final db = await database;
    return await db.insert("manutencoes", manutencao.toMap());
  }

  //Get Consulta -> By Pet
  Future<List<Manutencao>> getConsultaByPetId(int petId) async{
    final db = await database;
    final List<Map<String,dynamic>> maps = await db.query(
      "consultas",
      where: "pet_id = ?",
      whereArgs: [petId],
      orderBy: "data_hora ASC" //ordenar por data e hora da Consulta
    ); //select from consultas where pet_id = ?, Pet_id, order by data_hora ASC
    //converter a Maps em Obj
    return maps.map((e)=>Manutencao.fromMap(e)).toList();
  }

  //Delete Consulta
  Future<int> deleteManutencao(int id) async{
    final db = await database;
    return await db.delete("manutencao", where: "id=?", whereArgs: [id]);
  }

 
}