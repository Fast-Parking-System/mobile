import 'dart:developer';
import 'package:fast_parking_system/src/constants.dart';
import 'package:fast_parking_system/src/models/analytics_model.dart';
import 'package:fast_parking_system/src/models/attendants_model.dart';
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
        print(model);
        return model;
      }
    } catch (e) {
      log(e.toString());
      storage.delete(key: 'token');
    }
    return null;
  }

  Future<Locations?> getLocationsBySearch() async {
    // TODO: for getting location by search param
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

  Future<Attendants?> getAttendants() async {
    try {
      String? token = await storage.read(key: 'token');
      print('token from locations:  $token');
      var url = Uri.parse(ApiConstants.url + ApiConstants.attendants);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        Attendants model = attendantsFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
      storage.delete(key: 'token');
    }
    return null;
  }

  Future<Attendants?> getAttendantsByParams(
      {String? search, int? locationId}) async {
    try {
      String? token = await storage.read(key: 'token');

      // Build the base URL
      var url = Uri.parse('${ApiConstants.url}/api/attendants');

      // Add query parameters conditionally
      Map<String, String> queryParams = {};
      if (search != null) {
        queryParams['search'] = search;
      }
      if (locationId != null) {
        queryParams['location_id'] = locationId.toString();
      }
      if (queryParams.isNotEmpty) {
        url = Uri(
          scheme: url.scheme,
          host: url.host,
          path: url.path,
          queryParameters: queryParams,
        );
      }

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Attendants model = attendantsFromJson(response.body);
        print(model);
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

  Future<Analytics?> getAnalytics({userId}) async {
    try {
      String? token = await storage.read(key: 'token');
      String? userId = await storage.read(key: 'userId');

      var url =
          Uri.parse('${ApiConstants.url}/api/attendants/$userId/analytics');
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // print('response.body');
        // print(response.body);
        Analytics analyticsModel = analyticsFromJson(response.body);
        // print('analyticsModel');
        // print(analyticsModel.data.daily[0]);
        return analyticsModel;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<WhoAmI?> getAttendantDetail({userId}) async {
    try {
      String? token = await storage.read(key: 'token');

      var url = Uri.parse('${ApiConstants.url}/api/attendants/$userId');
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var response = await http.get(url, headers: headers);

      print("response.statusCode");
      print(response.statusCode);

      print("response.body");
      print(response.body);

      if (response.statusCode == 200) {
        print("before parse result");
        WhoAmI model = whoAmIFromJson(response.body);
        print("parse result");
        print(model);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
