// To parse this JSON data, do
//
//     final attendants = attendantsFromJson(jsonString);

import 'dart:convert';

Attendants attendantsFromJson(String str) => Attendants.fromJson(json.decode(str));

String attendantsToJson(Attendants data) => json.encode(data.toJson());

class Attendants {
    bool status;
    String message;
    dynamic error;
    List<Datum> data;

    Attendants({
        required this.status,
        required this.message,
        required this.error,
        required this.data,
    });

    factory Attendants.fromJson(Map<String, dynamic> json) => Attendants(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "error": error,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String id;
    String fullName;
    String location;
    String qrCode;

    Datum({
        required this.id,
        required this.fullName,
        required this.location,
        required this.qrCode,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        fullName: json["full_name"],
        location: json["location"],
        qrCode: json["qr_code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "location": location,
        "qr_code": qrCode,
    };
}
