import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// --------------------------- MODEL ---------------------------
class Manutencao {
  final String tipo;
  final String data;
  final String observacao;
  final String horario;
  final String veiculoId;

  Manutencao({
    required this.tipo,
    required this.data,
    required this.observacao,
    required this.horario,
    required this.veiculoId,
  });

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'data': data,
      'observacao': observacao,
      'horario': horario,
      'veiculoId': veiculoId,
    };
  }
}

// --------------------------- CONTROLLER ---------------------------
class ManutencaoController {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'manutencao.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE manutencoes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tipo TEXT,
            data TEXT,
            observacao TEXT,
            horario TEXT,
            veiculoId TEXT
          )
        ''');
      },
    );
  }

  Future<void> createManutencao(Manutencao manutencao) async {
    final db = await database;
    await db.insert(
      'manutencoes',
      manutencao.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

// --------------------------- TELA DE CADASTRO ---------------------------

class CadastroManutencaoScreen extends StatefulWidget {
  final String veiculoId; // ID do veículo associado à manutenção
  const CadastroManutencaoScreen({super.key, required this.veiculoId});

  @override
  State<CadastroManutencaoScreen> createState() => _CadastroManutencaoScreenState();
}

class _CadastroManutencaoScreenState extends State<CadastroManutencaoScreen> {
  final _formKey = GlobalKey<FormState>();
  final manutencaoController = ManutencaoController();

  late String _tipo;
  late String _observacao;
  late String _dataSelecionada;
  late String _horaSelecionada;

  @override
  void initState() {
    super.initState();
    _dataSelecionada = DateTime.now().toString().split(' ')[0];
    _horaSelecionada = TimeOfDay.now().format(context as BuildContext);
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dataSelecionada = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> _selecionarHora(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _horaSelecionada = picked.format(context);
      });
    }
  }

  Future<void> _salvarManutencao() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final manutencao = Manutencao(
        tipo: _tipo,
        data: _dataSelecionada,
        observacao: _observacao,
        horario: _horaSelecionada,
        veiculoId: widget.veiculoId,
      );

      await manutencaoController.createManutencao(manutencao);

      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text("Manutenção cadastrada com sucesso!")),
      );

      Navigator.pop(context as BuildContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nova Manutenção")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Tipo de serviço"),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (value) => _tipo = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Observações"),
                onSaved: (value) => _observacao = value ?? '',
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Text("Data: $_dataSelecionada")),
                  TextButton(
                    onPressed: () => _selecionarData(context),
                    child: Text("Selecionar Data"),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text("Horário: $_horaSelecionada")),
                  TextButton(
                    onPressed: () => _selecionarHora(context),
                    child: Text("Selecionar Hora"),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarManutencao,
                child: Text("Salvar Manutenção"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------- MAIN PARA TESTE ---------------------------

void main() {
  runApp(MaterialApp(
    home: CadastroManutencaoScreen(veiculoId: '1'), // simulação de ID
  ));
}
