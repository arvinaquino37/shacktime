// To parse this JSON data, do
//
//     final responseSupportDetails = responseSupportDetailsFromJson(jsonString);

import 'dart:convert';

ResponseSupportDetails responseSupportDetailsFromJson(String str) =>
    ResponseSupportDetails.fromJson(json.decode(str));

String responseSupportDetailsToJson(ResponseSupportDetails data) =>
    json.encode(data.toJson());

class ResponseSupportDetails {
  ResponseSupportDetails({
    this.result,
    this.message,
    this.data,
  });

  bool? result;
  String? message;
  Data? data;

  factory ResponseSupportDetails.fromJson(Map<String, dynamic> json) =>
      ResponseSupportDetails(
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
    this.code,
    this.subject,
    this.description,
    this.typeName,
    this.typeColor,
    this.priorityName,
    this.priorityColor,
    this.date,
    this.file,
  });

  String? code;
  String? subject;
  String? description;
  String? typeName;
  String? typeColor;
  String? priorityName;
  String? priorityColor;
  String? date;
  String? file;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        code: json["code"],
        subject: json["subject"],
        description: json["description"],
        typeName: json["type_name"],
        typeColor: json["type_color"],
        priorityName: json["priority_name"],
        priorityColor: json["priority_color"],
        date: json["date"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "subject": subject,
        "description": description,
        "type_name": typeName,
        "type_color": typeColor,
        "priority_name": priorityName,
        "priority_color": priorityColor,
        "date": date,
        "file": file,
      };
}
