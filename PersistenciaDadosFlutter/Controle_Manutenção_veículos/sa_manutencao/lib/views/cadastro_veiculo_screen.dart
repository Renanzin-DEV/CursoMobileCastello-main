import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Veiculo {
  String marca;
  String modelo;
  String ano;
  String placa;
  String kmInicial;

  Veiculo({
    required this.marca,
    required this.modelo,
    required this.ano,
    required this.placa,
    required this.kmInicial,
  });

  Map<String, dynamic> toMap() {
    return {
      'marca': marca,
      'modelo': modelo,
      'ano': ano,
      'placa': placa,
      'kmInicial': kmInicial,
    };
  }
}

class VeiculoController {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'veiculos.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE veiculos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            marca TEXT,
            modelo TEXT,
            ano TEXT,
            placa TEXT,
            kmInicial TEXT
          )
        ''');
      },
    );
  }

  Future<void> createVeiculo(Veiculo veiculo) async {
    final db = await database;
    await db.insert(
      'veiculos',
      veiculo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

// --------------------- TELA DE CADASTRO ---------------------

void main() {
  runApp(MaterialApp(
    home: CadastroVeiculoScreen(),
  ));
}

class CadastroVeiculoScreen extends StatefulWidget {
  const CadastroVeiculoScreen({super.key});

  @override
  State<CadastroVeiculoScreen> createState() => _CadastroVeiculoScreenState();
}

class _CadastroVeiculoScreenState extends State<CadastroVeiculoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _veiculosController = VeiculoController();

  late String _marca;
  late String _modelo;
  late String _ano;
  late String _placa;
  late String _kmInicial;

  Future<void> _salvarVeiculo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newVeiculo = Veiculo(
        marca: _marca,
        modelo: _modelo,
        ano: _ano,
        placa: _placa,
        kmInicial: _kmInicial,
      );

      await _veiculosController.createVeiculo(newVeiculo);

      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Veículo salvo com sucesso!')),
      );

      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro de Veículo")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Marca do Veículo"),
                validator: (value) =>
                    value!.isEmpty ? "Campo Não Preenchido" : null,
                onSaved: (value) => _marca = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Modelo do Veículo"),
                validator: (value) =>
                    value!.isEmpty ? "Campo Não Preenchido" : null,
                onSaved: (value) => _modelo = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Ano do Veículo"),
                validator: (value) =>
                    value!.isEmpty ? "Campo Não Preenchido" : null,
                onSaved: (value) => _ano = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Placa do Veículo"),
                validator: (value) =>
                    value!.isEmpty ? "Campo Não Preenchido" : null,
                onSaved: (value) => _placa = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "KM Inicial"),
                validator: (value) =>
                    value!.isEmpty ? "Campo Não Preenchido" : null,
                onSaved: (value) => _kmInicial = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarVeiculo,
                child: Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
