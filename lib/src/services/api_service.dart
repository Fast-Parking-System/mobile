import 'dart:developer';

import 'package:fast_parking_system/src/constants.dart';
import 'package:fast_parking_system/src/models/pokemon_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Pokemon?> getPokemons() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.pokemonEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Pokemon model = pokemonFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
