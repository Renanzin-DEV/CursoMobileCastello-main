import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  
  late bool _logado;
  late bool _darkMode;
  String _nome = "";

  @override
  void initState() {
    super.initState();
    _logado = false;
    _darkMode = false;
    carregarPreferencias();
  }

  Future<void> carregarPreferencias() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() {
      _nome = prefs.getString("nome") ?? "";
      _controllerNome.text = _nome;
      _controllerSenha.text = prefs.getString("senha") ?? "";
      _logado = prefs.getBool("logado") ?? false;
      _darkMode = prefs.getBool("darkMode") ?? false;
    });
  }

  Future<void> logar() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String nome = _controllerNome.text;
    String senha = _controllerSenha.text;

    if (nome == "admin" && senha == "123") {
      await prefs.setString("nome", nome);
      await prefs.setString("senha", senha);
      await prefs.setBool("logado", true);
      await prefs.setBool("darkMode", _darkMode);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login realizado com sucesso!"))
      );

      Navigator.pushReplacementNamed(context, "/principal");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login ou senha inválido!"))
      );
    }
  }

  void mudarTema(bool valor) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _darkMode = valor;
    });

    await prefs.setBool("darkMode", _darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _darkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_nome.isEmpty ? "Visitante" : _nome),
          actions: [
            Switch(
              value: _darkMode,
              onChanged: mudarTema,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Login",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _controllerNome,
                decoration: InputDecoration(labelText: "Nome"),
              ),
              TextField(
                controller: _controllerSenha,
                obscureText: true,
                decoration: InputDecoration(labelText: "Senha"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: logar,
                child: Text("Entrar"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/cadastro");
                },
                child: Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
