// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

import 'package:appwrite_incidence_supervisor/domain/model/user_model.dart';

UsersModel usersFromString(String str) => usersFromJson(json.decode(str));

String usersToString(UsersModel data) => json.encode(usersToJson(data));

UsersModel usersFromJson(Map<String, dynamic> json) => UsersModel(
      name: json["name"],
      area: json["area"],
      active: json["active"],
      typeUser: json["type_user"],
      read: List<String>.from(json["\u0024read"].map((x) => x)),
      write: List<String>.from(json["\u0024write"].map((x) => x)),
      id: json["\u0024id"],
      collection: json["\u0024collection"],
    );

Map<String, dynamic> usersToJson(UsersModel users) => {
      "name": users.name,
      "area": users.area,
      "active": users.active,
      "type_user": users.typeUser,
      //"\u0024read": List<dynamic>.from(users.read.map((x) => x)),
      //"\u0024write": List<dynamic>.from(users.write.map((x) => x)),
      //"\u0024id": users.id,
      //"\u0024collection": users.collection,
    };
