import 'dart:convert';

ChangePassword changePasswordFromJson(String str) =>
    ChangePassword.fromJson(json.decode(str));

String changePasswordToJson(ChangePassword data) => json.encode(data.toJson());

class ChangePassword {
  bool status;
  String message;
  dynamic error;
  Data data;

  ChangePassword({
    required this.status,
    required this.message,
    required this.error,
    required this.data,
  });

  factory ChangePassword.fromJson(Map<String, dynamic> json) => ChangePassword(
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
  bool isUpdated;

  Data({
    required this.isUpdated,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isUpdated: json["is_updated"],
      );

  Map<String, dynamic> toJson() => {
        "is_updated": isUpdated,
      };
}
