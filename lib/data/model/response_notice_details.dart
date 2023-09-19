// To parse this JSON data, do
//
//     final responseNoticeDetails = responseNoticeDetailsFromJson(jsonString);

import 'dart:convert';

ResponseNoticeDetails responseNoticeDetailsFromJson(String str) => ResponseNoticeDetails.fromJson(json.decode(str));

String responseNoticeDetailsToJson(ResponseNoticeDetails data) => json.encode(data.toJson());

class ResponseNoticeDetails {
  ResponseNoticeDetails({
    this.result,
    this.message,
    this.data,
  });

  bool? result;
  String? message;
  Data? data;

  factory ResponseNoticeDetails.fromJson(Map<String, dynamic> json) => ResponseNoticeDetails(
    result: json["result"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.subject,
    this.description,
    this.date,
    this.file,
  });

  int? id;
  String? subject;
  String? description;
  String? date;
  String? file;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    subject: json["subject"],
    description: json["description"],
    date: json["date"],
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subject": subject,
    "description": description,
    "date": date,
    "file": file,
  };
}
