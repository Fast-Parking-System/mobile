import 'dart:developer';

import 'package:fast_parking_system/src/constants.dart';
import 'package:fast_parking_system/src/models/locations_model.dart';
import 'package:fast_parking_system/src/models/pokemon_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();

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
    return null;
  }

  Future<Locations?> getLocations() async {
    try {
      var url = Uri.parse(ApiConstants.url + ApiConstants.locations);
      // Get token from storage
      String? token = await storage.read(key: 'token');

      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Add the authorization header
        },
      );

      if (response.statusCode == 200) {
        Locations model = locationsFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
