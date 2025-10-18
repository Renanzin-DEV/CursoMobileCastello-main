//construir a Janela de Detalhe do Veiculo

import 'package:flutter/material.dart';
import 'package:sa_manutencao/controllers/veiculo_controller.dart';
import 'package:sa_manutencao/models/manutencao_model.dart';
import 'package:sa_manutencao/models/Veiculo_model.dart';
import 'package:sa_manutencao/views/criar_manutencao_screen.dart';

//mudança de State
class DetalheVeiculoScreen extends StatefulWidget {
  final int veiculoId; //receber o id do Veiculo

  const DetalheVeiculoScreen({super.key, required this.veiculoId}); // pega o Id Veiculo

  @override
  State<StatefulWidget> createState() {
    return _DetalheVeiculoScreenState();
  }
}

//build da Tela
class _DetalheVeiculoScreenState extends State<DetalheVeiculoScreen> {
  // das info do Veiculo // das info da Manutencao do Veiculo
  final _veiculoControl = VeiculoController();
  final _manutencaoControl = ManutencaoC();
  Veiculo? _veiculo; //pode ser nulo

  List<Manutencao> _manutencoes = [];

  bool _isLoading = true;

  //carregar as info initSTate
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    setState(() {
      _isLoading = true;
      _manutencoes = [];
    });
    try {
      _veiculo = await _veiculoControl.readVeiculobyId(widget.veiculoId);
      _manutencoes = await _manutencaoControl.readManutencaoByVeiculo(widget.VeiculoId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e"))
      );
    } finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  //build da Tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalhe do Veiculo"),),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : _veiculo == null 
          ? Center(child: Text("Erro ao Carregar o Veiculo, Verifique o ID"),) 
          : Padding(padding: EdgeInsets.all(16),child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Marca: ${_veiculo!.marca}", style: TextStyle(fontSize: 20),),
              Text("Modelo: ${_veiculo!.modelo}"),
              Text("Ano: ${_veiculo!.ano}"),
              Text("Placa: ${_veiculo!.placa}"),
              Text("kmInicial: ${_veiculo!.kmInicial}"),
              Divider(), //hr-html
              Text("Manutencoes:", style: TextStyle(fontSize: 18),),
              //operador Ternário
              _manutencoes.isEmpty
                ? Center(child: Text("Não Existe Manutencoes Agendadas"),)
                : Expanded(child: ListView.builder(
                  itemCount: _manutencoes.length,
                  itemBuilder: (context,index){
                    final manutencao = _manutencoes[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(manutencao.tipoServico),
                        subtitle: Text(manutencao.dataHoraLocal),
                        //trailing: //delete da Manutencao
                      ),
                    );
                  }))
            ],
          ),),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.push(context, 
            MaterialPageRoute(builder: (context)=> CriarManutencaoScreen(veiculoId: widget.veiculoId)));
          _carregarDados();
        },
        child: Icon(Icons.add),
      ), 
    );
  }
}
