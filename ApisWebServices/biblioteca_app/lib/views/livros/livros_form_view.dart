import 'package:biblioteca_2app/models/livro_model.dart';
import 'package:flutter/material.dart';

class LivroFormView extends StatefulWidget {
  //atributos da classe
  final LivroModel? user; //pode ser nulo

  const LivroFormView({
    super.key,
    this.user,
  }); //usuário não é obrigatório no construtor

  @override
  State<LivroFormView> createState() => _LivroFormViewState();
}

class _LivroFormViewState extends State<LivroFormView> {
  //atributos
  final _formKey = GlobalKey<FormState>(); // validações do formulário
  final _controller =  LivroController(); //comunicação entre view e model
  final _tituloField = TextEditingController(); //controle o campo nome
  final _autorField = TextEditingController(); //controla o campo email

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _tituloField.text = widget
          .user!
          .titulo; //atribui ao campo do formulário as informações do usuário que veio da tela anterior
      _autorField.text = widget.user!.autor;
    }
  }

  //criar novo usuario
  void _criar() async {
    if (_formKey.currentState!.validate()) {
      final livroNovo = LivroModel(
        id: DateTime.now().millisecond.toString(), //criar um ID
        titulo: _tituloField.text.trim(),
        autor: _autorField.text.trim(),
      );
      try {
        await _controller.create(livroNovo);
        //mensagem de criação do usuário
      } catch (e) {
        //tratar erro
      }
      Navigator.pop(context); //volta pra tela anterio
    }
  }

  //atualizar usuário
  void _atualizar() async {
    if (_formKey.currentState!.validate()) {
    final LivroAtualizado = LivroModel(
  id: widget.user?.id,
  titulo: _tituloField.text.trim(),
  autor: _autorField.text.trim(),

);

      try {
        await _controller.update(LivroAtualizado);
        //mensagem de atualização do usuário
      } catch (e) {
        //tratar erro
      }
      Navigator.pop(context); //volta pra tela anterio
    }
  }

  //build da Tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          //operador ternário
          widget.user == null ? "Novo Livro" : "Editar Livro",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _tituloField,
                decoration: InputDecoration(labelText: "titulo"),
                validator: (value) => value!.isEmpty ? "Informe o Nome" : null,
              ),
              TextFormField(
                controller: _autorField,
                decoration: InputDecoration(labelText: "autor"),
                validator: (value) => value!.isEmpty ? "Informe o Email" : null,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: widget.user == null ? _criar : _atualizar,
                child: Text(widget.user == null ? "Salvar" : "Atualizar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
