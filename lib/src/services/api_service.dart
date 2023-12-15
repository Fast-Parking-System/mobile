import 'dart:developer';
import 'dart:convert';
import 'package:fast_parking_system/src/constants.dart';
import 'package:fast_parking_system/src/models/analytics_model.dart';
import 'package:fast_parking_system/src/models/attendants_model.dart';
import 'package:fast_parking_system/src/models/locations_model.dart';
import 'package:fast_parking_system/src/models/whoami_model.dart';
import 'package:fast_parking_system/src/models/change_password_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();

class ApiService {
  final storage = const FlutterSecureStorage();

  Future<Locations?> getLocations({String? search}) async {
    try {
      String? token = await storage.read(key: 'token');
      var url = Uri.parse(ApiConstants.url +
          ApiConstants.locations +
          (search != null && search.isNotEmpty ? '?search=$search' : ''));
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

  Future<Locations?> getLocationsBySearch() async {
    try {
      String? token = await storage.read(key: 'token');
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
    }
    return null;
  }

  Future<Attendants?> getAttendantsByParams(
      {String? search, int? locationId}) async {
    try {
      String? token = await storage.read(key: 'token');

      var url = Uri.parse('${ApiConstants.url}/api/attendants');

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

      var url =
          Uri.parse('${ApiConstants.url}/api/attendants/$userId/analytics');
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Analytics analyticsModel = analyticsFromJson(response.body);
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

      if (response.statusCode == 200) {
        WhoAmI model = whoAmIFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<ChangePassword?> sendChangePasswordRequest({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      String? token = await storage.read(key: 'token');

      var url = Uri.parse(ApiConstants.url + ApiConstants.changePassword);
      var headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          "old_password": oldPassword,
          "new_password": newPassword,
          "confirm_new_password": confirmNewPassword,
        }),
      );

      if (response.statusCode == 200) {
        return ChangePassword.fromJson(json.decode(response.body));
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
