import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  //lista de imagens
  List<String> imagens = [
    "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
    "https://images.unsplash.com/photo-1521747116042-5a810fda9664",
    "https://images.unsplash.com/photo-1504384308090-c894fdcc538d",
    "https://images.unsplash.com/photo-1518837695005-2083093ee35b",
    "https://images.unsplash.com/photo-1501594907352-04cda38ebc29",
    "https://images.unsplash.com/photo-1519681393784-d120267933ba",
    "https://images.unsplash.com/photo-1531259683007-016a7b628fc3",
    "https://images.unsplash.com/photo-1506619216599-9d16d0903dfd",
    "https://images.unsplash.com/photo-1494172961521-33799ddd43a5",
    "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4",
  ];

  MyApp({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Galeria de Imagens"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 300, 
                autoPlay: true
              ),
              items: imagens.map(
                ((url)=> Container(
                  margin: EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(url,fit: BoxFit.cover,width:1000)),
                ))).toList(),),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8),
              itemCount: imagens.length, 
              itemBuilder: (context,index)=>
                GestureDetector(
                  onTap: () => _mostrarImagem(context,imagens[index]),
                  child: ClipRRect(borderRadius: BorderRadius.circular(10),
                  child: Image.network(imagens[index],fit: BoxFit.cover)),
                ))),
          SizedBox(height: 10,),
            ElevatedButton(
              onPressed: _adicionarTarefa, 
              child: Text("Adicionar Tarefa")
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context,index)=>ListTile(
                  title: Text(_tarefas[index]["titulo"], style: TextStyle(
                    decoration: _tarefas[index]["concluida"] ? TextDecoration.lineThrough : null //operador ternário
                  ),),
                  leading: Checkbox(
                    value: _tarefas[index]["concluida"], 
                    onChanged: (bool? valor)=> setState(() {
                      _tarefas[index]["concluida"] = valor!;
                    })),
                ))
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _removerTarefasConcluidas,
        backgroundColor: Colors.red,
        child: Text("Remover"),
        ),
    );
  }


  void _adicionarTarefa() {
    if(_tarefaController.text.trim().isNotEmpty){
      setState(() {
        _tarefas.add({"titulo":_tarefaController.text,"concluida":false});
        _tarefaController.clear();
      });
    }
  }

  void _removerTarefasConcluidas() {
    setState(() {
      _tarefas.removeWhere((tarefa)=>tarefa["concluida"]);
    });
  }
  
  void setState(Null Function() param0) {}
  }
  
  class _tarefaController {
  }
  
  void _mostrarImagem(BuildContext context, String imagem) {
    showDialog(
      context: context, 
      builder: (context) => Dialog(
        child: Image.network(imagem),
      ));
  }
  
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
  
  // ignore: non_constant_identifier_names
  CarouselSlider({required options, required List<Container> items}) {}
  
  // ignore: non_constant_identifier_names
  CarouselOptions({required int height, required bool autoPlay}) {}
}
