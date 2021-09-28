import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:conversor_moedas/shared/widgets/input_text_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _realController = TextEditingController();
  final _dollarController = TextEditingController();
  final _euroController = TextEditingController();

  double _dollar = 0.0;
  double _euro = 0.0;

  Future<Map> _getData() async {
    const url = "https://api.hgbrasil.com/finance?format=json&key=1adfe53b";
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    var data = json.decode(response.body);

    return data;
  }

  void _clearAll() {
    _realController.text = "";
    _dollarController.text = "";
    _euroController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    var real = double.parse(text);

    _dollarController.text = (real / _dollar).toStringAsFixed(2);
    _euroController.text = (real / _euro).toStringAsFixed(2);
  }

  void _dollarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    var dollar = double.parse(text);

    _realController.text = (dollar * _dollar).toStringAsFixed(2);
    _euroController.text = (dollar * _dollar / _euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    var euro = double.parse(text);

    _realController.text = (euro * _euro).toStringAsFixed(2);
    _dollarController.text = (euro * _euro / _dollar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Conversor"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: _getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator(
                color: Colors.amber,
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Erro ao carregar dados :(",
                    style: TextStyle(color: Colors.amber, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                _dollar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                _euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputTextWidget(
                        label: "Reais",
                        prefix: "R\$ ",
                        controller: _realController,
                        onChanged: _realChanged,
                      ),
                      InputTextWidget(
                        label: "Dólares",
                        prefix: "\$ ",
                        controller: _dollarController,
                        onChanged: _dollarChanged,
                      ),
                      InputTextWidget(
                        label: "Euros",
                        prefix: "€ ",
                        controller: _euroController,
                        onChanged: _euroChanged,
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
