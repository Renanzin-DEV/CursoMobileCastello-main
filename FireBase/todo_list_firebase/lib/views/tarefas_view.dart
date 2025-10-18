import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TarefasView extends StatefulWidget {
  const TarefasView({super.key});

  @override
  State<TarefasView> createState() => _TarefasViewState();
}

class _TarefasViewState extends State<TarefasView> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? _user;
  final TextEditingController _tarefaField = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _tarefaField.dispose();
    super.dispose();
  }

  Future<void> _addTarefa() async {
    final texto = _tarefaField.text.trim();
    if (texto.isEmpty || _user == null) return;

    try {
      await _db
          .collection('usuarios')
          .doc(_user!.uid)
          .collection('tarefas')
          .add({
        'titulo': texto,
        'concluida': false,
        'dataCriacao': Timestamp.now(),
      });
      _tarefaField.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao adicionar: $e')));
    }
  }

  Future<void> _atualizarTarefa(String tarefaID, bool status) async {
    if (_user == null) return;
    await _db
        .collection('usuarios')
        .doc(_user!.uid)
        .collection('tarefas')
        .doc(tarefaID)
        .update({'concluida': status});
  }

  Future<void> _deleteTarefa(String tarefaID) async {
    if (_user == null) return;
    await _db
        .collection('usuarios')
        .doc(_user!.uid)
        .collection('tarefas')
        .doc(tarefaID)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    // Proteção caso o usuário não esteja logado (evita usar _user!.uid antes do tempo)
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Minha Tarefas')),
        body: Center(child: Text('Usuário não autenticado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Tarefas'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tarefaField,
              decoration: InputDecoration(
                labelText: 'Nova Tarefa',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: _addTarefa,
                  icon: Icon(Icons.add, color: Colors.green),
                ),
              ),
              onSubmitted: (_) => _addTarefa(),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _db
                    .collection('usuarios')
                    .doc(_user!.uid)
                    .collection('tarefas')
                    .orderBy('dataCriacao', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  // 1) aguardando conexão
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // 2) erro ao carregar
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar tarefas.'));
                  }

                  // 3) sem dados
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Sem Tarefa Por Enquanto'));
                  }

                  // 4) dados disponíveis -> lista
                  final tarefas = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: tarefas.length,
                    itemBuilder: (context, index) {
                      final tarefa = tarefas[index];
                      final tarefaMap =
                          tarefa.data() as Map<String, dynamic>? ?? {};
                      final titulo = tarefaMap['titulo'] as String? ?? '';
                      final concluida =
                          (tarefaMap['concluida'] as bool?) ?? false;

                      return ListTile(
                        title: Text(
                          titulo,
                          style: concluida
                              ? const TextStyle(
                                  decoration: TextDecoration.lineThrough)
                              : null,
                        ),
                        leading: Checkbox(
                          value: concluida,
                          onChanged: (value) {
                            // usa o valor enviado (ou inverte caso seja nulo)
                            _atualizarTarefa(tarefa.id, value ?? !concluida);
                          },
                        ),
                        trailing: IconButton(
                          onPressed: () => _deleteTarefa(tarefa.id),
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
