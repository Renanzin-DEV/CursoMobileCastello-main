import 'package:biblioteca_2app/models/livro_model.dart';
import 'package:biblioteca_2app/views/livros/livros_form_view.dart';
import 'package:biblioteca_2app/views/livros/livro_form_view.dart';
import 'package:flutter/material.dart';

class LivroListView extends StatefulWidget {
  const LivroListView({super.key});

  @override
  _LivroListViewState createState() => _LivroListViewState();
}

class _LivroListViewState extends State<LivroFormView> {
  //atributos
  final _buscarField = TextEditingController();
  final List<LivroModel> _usuariosFiltrados = [];
  final _controller = Livro(); //controller para conectar movel/view
  List<LivroModel> _livros = []; //lista par guardar os usuário
  bool _carregando = true; //bool par usar no view

  @override
  void initState() {
    // carregar os dados antes da contrução da tela
    super.initState();
    _load(); //método par carregar dados da api
  }

  _load() async {
    setState(() {
      _carregando = true;
    });
    try {
      _livros = await _controller
          .fetchAll(); //preenche a lista de usuário com os usuario do BD
      _livrosFiltrados = _livros;
    } catch (e) {
      //caso erro mostra para o usuário
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() {
      // modifica a variável para false - terminou de carregar
      _carregando = false;
    });
  }

  //método para filtrar usuários pelo nome e pelo email
  void _filtrar() {
    //filtar da lista já carregada
    final busca = _buscarField.text.toLowerCase();
    setState(() {
      _livrosFiltrados = _livros.where((user) {
        return user.titulo.toLowerCase().contains(busca) || //filta pelo nome
            user.autor.toLowerCase().contains(busca); //filtra pelo email
      }).toList(); //converte em Lista
    });
  }

  //criar método deletar
  void _delete(LivroModel user) async {
    if (user.id == null) return; //interrompe o método
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirma Exclusão"),
        content: Text("Deseja Realmente Excluir o Usuário ${user.titulo}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Ok"),
          ),
        ],
      ),
    );
    if (confirme == true) {
      try {
        await _controller.delete(user.id!);
        _load();
        //mensagem de confirmação
      } catch (e) {
        //tratar erro
      }
    }
  }

  //método para navegar para Tela User_form_view

  void _openForm({LivroModel? user}) async {
    //usuário entra no parametro, mas não é obrigatório
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LivroFormView(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // operador ternário
      body: _carregando
          ? Center(
              child: CircularProgressIndicator(),
            ) // mostra uma barra circular
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _buscarField,
                    decoration: InputDecoration(labelText: "Pesquisar Usuário"),
                    onChanged: (value) => _filtrar(),
                  ),
                ),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    // ,mostra a lista de usuário
                    padding: EdgeInsets.all(8),
                    itemCount: _usuariosFiltrados.length,
                    itemBuilder: (context, index) {
                      final usuario = _usuariosFiltrados[index];
                      return Card(
                        child: ListTile(
                          //leading
                          leading: IconButton(
                            onPressed: () => _openForm(user: usuario),
                            icon: Icon(Icons.edit),
                          ),
                          title: Text(usuario.titulo),
                          subtitle: Text(usuario.autor),
                          //trailing para deletar usuario
                          trailing: IconButton(
                            onPressed: () => _delete(usuario),
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
