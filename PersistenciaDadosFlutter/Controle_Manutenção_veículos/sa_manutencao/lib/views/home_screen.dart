import 'package:flutter/material.dart';
import 'package:sa_manutencao/controllers/veiculo_controller.dart';
import 'package:sa_manutencao/models/veiculo_model.dart';
import 'package:sa_manutencao/views/cadastro_veiculo_screen.dart';
import 'package:sa_manutencao/views/detalhe_veiculo_screen.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  //atributos
  final VeiculoController _veiculoController = VeiculoController();
  List<Veiculo> _veiculos = [];
  bool _isLoading = true; //enquanto carrega info do BD

  @override
  void initState() { //método para rodar antes de qualquer coisa
    super.initState();
    _carregarDados();
  }

  _carregarDados() async{
    setState(() {
      _isLoading = true;
    });
    try {
      _veiculos = await _veiculoController.readPets();
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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Manutencao - Clientes"),),
      body: _isLoading //operador ternário
        ? Center(child: CircularProgressIndicator(),) // enquanto estiver carrregado as info do BD ,vai mostrar uma barra circular
        : Padding(
            padding: EdgeInsets.all(16), // espaçamento da parede do aplicativo de 16 px
            child: ListView.builder( //construtor da lista
              itemCount: _veiculos.length, // tamanho da lista
              itemBuilder: (context,index){ //método de construção da lista
                final pet = _veiculos[index];
                return ListTile(
                  title: Text("${veiculo.marca} - ${veiculo.modelo}"),
                  subtitle: Text("${veiculo.ano} - ${veiculo.placa}"),
                  //on tap -> para navegar para os Detalhes do pet
                  onTap: () => Navigator.push(context, 
                    MaterialPageRoute(builder: (context)=>DetalheVeiculoScreen(veiculoId: veiculo.id!))),
                  //onlongPress -> delete do Pet
                );//item da lista
              }),
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Adicionar Novo Pet",
        child: Icon(Icons.add),
        onPressed: () async  {
          await Navigator.push(context, 
            MaterialPageRoute(builder: (context) => CadastroVeiculoScreen()));
        },
      ),
    );
  }
}