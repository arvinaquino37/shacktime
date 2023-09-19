// To parse this JSON data, do
//
//     final responseDepartment = responseDepartmentFromJson(jsonString);

import 'dart:convert';

ResponseDepartment responseDepartmentFromJson(String str) => ResponseDepartment.fromJson(json.decode(str));

String responseDepartmentToJson(ResponseDepartment data) => json.encode(data.toJson());

class ResponseDepartment {
  ResponseDepartment({
    this.result,
    this.message,
    this.data,
  });

  bool? result;
  String? message;
  Data? data;

  factory ResponseDepartment.fromJson(Map<String, dynamic> json) => ResponseDepartment(
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
    this.departments,
  });

  List<Department>? departments;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    departments: List<Department>.from(json["departments"].map((x) => Department.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "departments": List<dynamic>.from(departments!.map((x) => x.toJson())),
  };
}

class Department {
  Department({
    this.id,
    this.title,
  });

  int? id;
  String? title;

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}
