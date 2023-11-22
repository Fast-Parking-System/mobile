import 'package:fast_parking_system/src/models/pokemon_model.dart';
import 'package:fast_parking_system/src/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Pokemon? _pokemon = null;
  @override
  void initState() {
    super.initState();
    getPokemons();
  }
  void getPokemons() async {
    _pokemon = (await ApiService().getPokemons())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST API Example'),
      ),
      body: _pokemon == null 
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _pokemon!.results.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(_pokemon!.results[index].name),
                          Text(_pokemon!.results[index].url),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(_pokemon!.results[index].name),
                          Text(_pokemon!.results[index].url),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
