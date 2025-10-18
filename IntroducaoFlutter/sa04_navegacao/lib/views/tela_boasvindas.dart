import 'package:flutter/material.dart';

class TelaBoasVindas extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem vindo!"),
        centerTitle: true,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Agradecemos pelo acesso, por favor faça seu cadastro:", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()=> Navigator.pushNamed(context, "/cadastro"), 
              child: Text("Cadastrar"))
          ],
        ),
      ),
    );
  }
}