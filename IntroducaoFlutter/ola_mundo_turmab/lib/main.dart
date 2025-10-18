import 'package:flutter/material.dart';

void main() {
  runApp(MyApp()); //classe principal da aplicação
}

//criar a classe principal
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: text("Exemplo de uso do PubSpec"),
        ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            Fluttertoast
          }, 
          child: Text(clique aqui!!!)),
          ),
    ),
    );
  }
}
