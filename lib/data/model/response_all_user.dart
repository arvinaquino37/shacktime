// To parse this JSON data, do
//
//     final responseAllUser = responseAllUserFromJson(jsonString);

import 'dart:convert';

ResponseAllUser responseAllUserFromJson(String str) => ResponseAllUser.fromJson(json.decode(str));

String responseAllUserToJson(ResponseAllUser data) => json.encode(data.toJson());

class ResponseAllUser {
  ResponseAllUser({
    this.result,
    this.message,
    this.data,
  });

  bool? result;
  String? message;
  Data? data;

  factory ResponseAllUser.fromJson(Map<String, dynamic> json) => ResponseAllUser(
    result: json["result"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": data!.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponseAllUser &&
          runtimeType == other.runtimeType &&
          result == other.result &&
          message == other.message &&
          data == other.data;

  @override
  int get hashCode => result.hashCode ^ message.hashCode ^ data.hashCode;
}

class Data {
  Data({
    this.users,
  });

  List<User>? users;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(users!.map((x) => x.toJson())),
  };
}

class User {
  User({
    this.id,
    this.name,
    this.phone,
    this.designation,
    this.avatar,
  });

  int? id;
  String? name;
  String? phone;
  String? designation;
  String? avatar;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    designation: json["designation"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "designation": designation,
    "avatar": avatar,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          phone == other.phone &&
          designation == other.designation &&
          avatar == other.avatar;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      designation.hashCode ^
      avatar.hashCode;
}
