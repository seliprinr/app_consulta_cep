import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const ConsultaCepApp());
}

class ConsultaCepApp extends StatelessWidget {
  const ConsultaCepApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta de CEP',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.grey.shade100,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, fontFamily: 'OpenSans'),
        ),
      ),
      home: const ConsultaCepScreen(),
    );
  }
}

class ConsultaCepScreen extends StatefulWidget {
  const ConsultaCepScreen({Key? key}) : super(key: key);

  @override
  _ConsultaCepScreenState createState() => _ConsultaCepScreenState();
}

class _ConsultaCepScreenState extends State<ConsultaCepScreen> {
  final TextEditingController _cepController = TextEditingController();
  String _result = '';

  Future<void> _buscarCep(String cep) async {
    try {
      final url = 'https://viacep.com.br/ws/$cep/json/';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['erro'] != null) {
          setState(() {
            _result = '🚫 CEP inválido! Por favor, tente novamente.';
          });
        } else {
          setState(() {
            _result =
            'Endereço: ${data['logradouro']}, Bairro: ${data['bairro']}, Cidade: ${data['localidade']}, UF: ${data['uf']}';
          });
        }
      } else {
        setState(() {
          _result = '❌ Erro: Não foi possível buscar o CEP.';
        });
      }
    } catch (e) {
      setState(() {
        _result = '⚠️ Ocorreu um erro inesperado! Verifique sua conexão ou tente novamente mais tarde.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de CEP'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.amber.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _cepController,
                decoration: const InputDecoration(
                  labelText: 'Digite o CEP',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.map, color: Colors.amber),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                final cep = _cepController.text;
                if (cep.isNotEmpty) {
                  _buscarCep(cep);
                } else {
                  setState(() {
                    _result = '⚠️ Por favor, insira um CEP válido!';
                  });
                }
              },
              icon: const Icon(Icons.search),
              label: const Text('Consultar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade700,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade800,
                fontFamily: 'OpenSans',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
