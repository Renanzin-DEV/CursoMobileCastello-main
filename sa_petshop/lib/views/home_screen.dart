import 'package:flutter/material.dart';
import 'package:sa_petshop/controllers/pet_controller.dart';
import 'package:sa_petshop/models/pet_model.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  //atributos
  final PetController _petController = PetController();
  List<Pet> _pets = [];
  bool _isLoading = true; //enquanto carrega info do BD

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  _carregarDados() async{
    setState(() {
      _isLoading = true;
    });
    try {
      _pets = await _petController.readPets();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e")));
    }finally{ //execução obrigatória
      setState(() {
        _isLoading = false;
      });
    }
  }

  //buildar a tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PetShop - Clientes"),),
      body: _isLoading
      ? Center(child: CircularProgressIndicator(),)
      : Padding(
        padding: EdgeInsets.all(16), child: ListView.builder(
          itemCount: _pets.length, itemBuilder: (context,index){
            final pet = _pets[index];
            return ListTile(
              title: Text("${pet.nome} - ${pet.raca}"),
              subtitle: Text("${pet.nomeDono} - ${pet.telefone}"),
              //* on tap -> para navegar para o pet
              //* onLongPress -> delete do Pet
            );  // item da lista
          }),
          ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Adicionar Novo Pet",
        child: Icon(Icons.add),
        onPressed: () async  {
          await Navigator.push(context, 
            MaterialPageRoute(builder: (context) => CadastroPetScreen()));
        },
      ),
    );
  }
}