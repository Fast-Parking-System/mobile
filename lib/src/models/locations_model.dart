// To parse this JSON data, do
//
//     final locations = locationsFromJson(jsonString);

import 'dart:convert';

Locations locationsFromJson(String str) => Locations.fromJson(json.decode(str));

String locationsToJson(Locations data) => json.encode(data.toJson());

class Locations {
    bool status;
    String message;
    dynamic error;
    List<Datum> data;

    Locations({
        required this.status,
        required this.message,
        required this.error,
        required this.data,
    });

    factory Locations.fromJson(Map<String, dynamic> json) => Locations(
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
    int id;
    String name;
    String tags;

    Datum({
        required this.id,
        required this.name,
        required this.tags,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        tags: json["tags"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tags": tags,
    };
}
