// To parse this JSON data, do
//
//     final whoAmI = whoAmIFromJson(jsonString);

import 'dart:convert';

WhoAmI whoAmIFromJson(String str) => WhoAmI.fromJson(json.decode(str));

String whoAmIToJson(WhoAmI data) => json.encode(data.toJson());

class WhoAmI {
  bool status;
  String message;
  dynamic error;
  Data data;

  WhoAmI({
    required this.status,
    required this.message,
    required this.error,
    required this.data,
  });

  factory WhoAmI.fromJson(Map<String, dynamic> json) => WhoAmI(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "error": error,
        "data": data.toJson(),
      };
}

class Data {
  String id;
  String fullName;
  String mobile;
  String password;
  int locationId;
  String gender;
  int isAdmin;
  String qrCode;
  String location;

  Data({
    required this.id,
    required this.fullName,
    required this.mobile,
    required this.password,
    required this.locationId,
    required this.gender,
    required this.isAdmin,
    required this.qrCode,
    required this.location,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        fullName: json["full_name"],
        mobile: json["mobile"],
        password: json["password"],
        locationId: json["location_id"],
        gender: json["gender"],
        isAdmin: json["is_admin"],
        qrCode: json["qr_code"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "mobile": mobile,
        "password": password,
        "location_id": locationId,
        "gender": gender,
        "is_admin": isAdmin,
      };
}
