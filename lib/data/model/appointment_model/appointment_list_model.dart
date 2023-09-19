// To parse this JSON data, do
//
//     final appointmentListModel = appointmentListModelFromJson(jsonString);

import 'dart:convert';

AppointmentListModel appointmentListModelFromJson(String str) => AppointmentListModel.fromJson(json.decode(str));

class AppointmentListModel {
  AppointmentListModel({
    // this.data,
    this.env,
    this.result,
    this.message,
    this.status,
  });

  // Data? data;
  String? env;
  bool? result;
  String? message;
  int? status;

  factory AppointmentListModel.fromJson(Map<String, dynamic> json) => AppointmentListModel(
    // data: Data.fromJson(json["data"]),
    env: json["env"],
    result: json["result"],
    message: json["message"],
    status: json["status"],
  );
}

// class Data {
//   Data({
//     this.items,
//   });
//
//   List<Item>? items;
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
//   );
// }

class Item {
  Item({
    this.id,
    this.title,
    this.date,
    this.day,
    this.time,
    this.location,
    this.appointmentWith,
    this.participants,
  });

  int? id;
  String? title;
  String? date;
  String? day;
  String? time;
  String? location;
  String? appointmentWith;
  List<Participant>? participants;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    title: json["title"],
    date: json["date"],
    day: json["day"],
    time: json["time"],
    location: json["location"],
    appointmentWith: json["appoinmentWith"],
    participants: List<Participant>.from(json["participants"].map((x) => Participant.fromJson(x))),
  );
}

class Participant {
  Participant({
    this.name,
    this.isAgree,
    this.isPresent,
    this.presentAt,
    this.appointmentStartedAt,
    this.appointmentEndedAt,
    this.appointmentDuration,
  });

  String? name;
  String? isAgree;
  String? isPresent;
  dynamic presentAt;
  dynamic appointmentStartedAt;
  dynamic appointmentEndedAt;
  dynamic appointmentDuration;

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
    name: json["name"],
    isAgree: json["is_agree"],
    isPresent: json["is_present"],
    presentAt: json["present_at"],
    appointmentStartedAt: json["appoinment_started_at"],
    appointmentEndedAt: json["appoinment_ended_at"],
    appointmentDuration: json["appoinment_duration"],
  );
}
