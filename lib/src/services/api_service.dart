import 'dart:convert';
import 'dart:developer';

import 'package:fast_parking_system/src/constants.dart';
import 'package:fast_parking_system/src/models/locations_model.dart';
import 'package:fast_parking_system/src/models/pokemon_model.dart';
import 'package:fast_parking_system/src/models/whoami_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();

class ApiService {
  final storage = const FlutterSecureStorage();
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
      String? token = await storage.read(key: 'token');
      print('token from locations:  $token');
      var url = Uri.parse(ApiConstants.url + ApiConstants.locations);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        Locations model = locationsFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<WhoAmI?> getWhoAmI() async {
    try {
      String? token = await storage.read(key: 'token');
      print('token from locations:  $token');
      var url = Uri.parse(ApiConstants.url + ApiConstants.whoami);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        WhoAmI model = whoAmIFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
