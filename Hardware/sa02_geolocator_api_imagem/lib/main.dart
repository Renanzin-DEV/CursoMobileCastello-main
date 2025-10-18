import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:open_weather_client/open_weather.dart';

void main() {
  runApp(MaterialApp(
    home: ImagePickerScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class ImagemInfo {
  final File arquivo;
  final DateTime data;
  final double latitude;
  final double longitude;
  final String cidade;

  ImagemInfo({
    required this.arquivo,
    required this.data,
    required this.latitude,
    required this.longitude,
    required this.cidade,
  });
}

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<ImagemInfo> _imagens = [];

  // ⚙️ Coloque aqui sua API Key do OpenWeather
  final String _apiKey = '4b274608044c15223aa388e22cfd44e7';
  late OpenWeather _openWeather;

  @override
  void initState() {
    super.initState();
    _initWeather();
  }

  Future<void> _initWeather() async {
    _openWeather = OpenWeather(apiKey: _apiKey);
  }

  Future<Position> _getPosicao() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      await Geolocator.openLocationSettings();
      throw Exception("Serviço de localização desativado");
    }

    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        throw Exception("Permissão de localização negada");
      }
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> _getCidade(double lat, double lon) async {
    try {
      final clima = await _openWeather.currentWeatherByLocation(
        latitude: lat,
        longitude: lon,
      );
      return clima.name ?? "Desconhecida";
    } catch (e) {
      return "Desconhecida";
    }
  }

  Future<void> _pegarDaGaleria() async {
    final List<XFile>? imagensSelecionadas = await _picker.pickMultiImage();
    if (imagensSelecionadas == null) return;

    final pos = await _getPosicao();
    final cidade = await _getCidade(pos.latitude, pos.longitude);

    for (var img in imagensSelecionadas) {
      setState(() {
        _imagens.add(
          ImagemInfo(
            arquivo: File(img.path),
            data: DateTime.now(),
            latitude: pos.latitude,
            longitude: pos.longitude,
            cidade: cidade,
          ),
        );
      });
    }
  }

  Future<void> _tirarFoto() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.camera);
    if (foto == null) return;

    final pos = await _getPosicao();
    final cidade = await _getCidade(pos.latitude, pos.longitude);

    setState(() {
      _imagens.add(
        ImagemInfo(
          arquivo: File(foto.path),
          data: DateTime.now(),
          latitude: pos.latitude,
          longitude: pos.longitude,
          cidade: cidade,
        ),
      );
    });
  }

  void _mostrarInfoImagem(ImagemInfo imagem) {
    final dataFormatada = DateFormat('dd/MM/yyyy HH:mm').format(imagem.data);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Informações da Imagem"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(imagem.arquivo, height: 150),
            const SizedBox(height: 10),
            Text("📅 Data: $dataFormatada"),
            Text("🏙️ Cidade: ${imagem.cidade}"),
            Text("🌍 Lat: ${imagem.latitude.toStringAsFixed(4)}"),
            Text("🌎 Lon: ${imagem.longitude.toStringAsFixed(4)}"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Fechar"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Galeria com Localização")),
      body: _imagens.isEmpty
          ? const Center(child: Text("Nenhuma imagem adicionada"))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _imagens.length,
              itemBuilder: (context, index) {
                final imagem = _imagens[index];
                return GestureDetector(
                  onTap: () => _mostrarInfoImagem(imagem),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(imagem.arquivo, fit: BoxFit.cover),
                  ),
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "foto",
            onPressed: _tirarFoto,
            label: const Text("Câmera"),
            icon: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: "galeria",
            onPressed: _pegarDaGaleria,
            label: const Text("Galeria"),
            icon: const Icon(Icons.photo_library),
          ),
        ],
      ),
    );
  }
}
