import 'dart:convert';

Analytics analyticsFromJson(String str) => Analytics.fromJson(json.decode(str));

String analyticsToJson(Analytics data) => json.encode(data.toJson());

class Analytics {
  bool status;
  String message;
  dynamic error;
  Data data;

  Analytics({
    required this.status,
    required this.message,
    required this.error,
    required this.data,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) => Analytics(
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
  List<Daily> daily;
  List<Weekly> weekly;
  List<Monthly> monthly;
  List<Yearly> yearly;

  Data({
    required this.daily,
    required this.weekly,
    required this.monthly,
    required this.yearly,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        daily: List<Daily>.from(json["daily"].map((x) => Daily.fromJson(x))),
        weekly: List<Weekly>.from(json["weekly"].map((x) => Weekly.fromJson(x))),
        monthly: List<Monthly>.from(json["monthly"].map((x) => Monthly.fromJson(x))),
        yearly: List<Yearly>.from(json["yearly"].map((x) => Yearly.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "daily": List<dynamic>.from(daily.map((x) => x.toJson())),
        "weekly": List<dynamic>.from(weekly.map((x) => x.toJson())),
        "monthly": List<dynamic>.from(monthly.map((x) => x.toJson())),
        "yearly": List<dynamic>.from(yearly.map((x) => x.toJson())),
      };
}

class Daily {
  String date;
  int amount;

  Daily({
    required this.date,
    required this.amount,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        date: json["date"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "amount": amount,
      };
}

class Weekly {
  String startDate;
  String endDate;
  int amount;

  Weekly({
    required this.startDate,
    required this.endDate,
    required this.amount,
  });

  factory Weekly.fromJson(Map<String, dynamic> json) => Weekly(
        startDate: json["start_date"],
        endDate: json["end_date"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "start_date": startDate,
        "end_date": endDate,
        "amount": amount,
      };
}

class Monthly {
  String month;
  int amount;

  Monthly({
    required this.month,
    required this.amount,
  });

  factory Monthly.fromJson(Map<String, dynamic> json) => Monthly(
        month: json["month"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "amount": amount,
      };
}

class Yearly {
  int year;
  int amount;

  Yearly({
    required this.year,
    required this.amount,
  });

  factory Yearly.fromJson(Map<String, dynamic> json) => Yearly(
        year: json["year"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "amount": amount,
      };
}