import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_shared_preferences/tela_inicial.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(home: ConfigPage()));
}

class ConfigPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConfigPageState();
  }
}

class _ConfigPageState extends State<ConfigPage> {
  //* atributos
  bool temaEscuro = false;
  String nomeUsuario = ""; // texto vazio

  //* método que roda antes de carregar a página
  @override
  void initState() {
    super.initState();
    carregarPreferencias();
  }


  //* método para carregar as infromações do sharedPreferences
  void carregarPreferencias() async {
    final prefs =
        await SharedPreferences.getInstance(); // conexão com o sharedPreferences
    String? jsonString = prefs.getString(
      "config",
    ); // estou recebendo os valores referentes a chave "config" do SP
    if (jsonString != null) {
      Map<String, dynamic> config = jsonDecode(jsonString);
      setState(() {
        //* método para mudança de estado (mudanças literais, modo, cor, nome)
        temaEscuro =
            config["temaEscuro"] ??
            false; // .?? operador para elemento null => atribui um valor caso o elemento seja nulo
        nomeUsuario = config["nome"] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App de Configuração",
      theme: temaEscuro
          ? ThemeData.dark()
          : ThemeData.light(), // operador ternário ()
      home: TelaInicial(temaEscuro: temaEscuro, 
      nomeUsuario: nomeUsuario)
    );
  }
}
