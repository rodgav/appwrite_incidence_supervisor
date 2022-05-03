// To parse this JSON data, do
//
//     final name = nameFromJson(jsonString);

import 'package:appwrite_incidence_supervisor/domain/model/name_model.dart';
import 'dart:convert';

Name nameFromString(String str) => nameFromJson(json.decode(str));

String nameToString(Name data) => json.encode(nameToJson(data));

Name nameFromJson(Map<String, dynamic> json) => Name(
      name: json["name"],
      read: List<String>.from(json["\u0024read"].map((x) => x)),
      write: List<String>.from(json["\u0024write"].map((x) => x)),
      id: json["\u0024id"],
      collection: json["\u0024collection"],
    );

Map<String, dynamic> nameToJson(Name name) => {
      "name": name.name,
      //"\u0024read": List<dynamic>.from(name.read.map((x) => x)),
      //"\u0024write": List<dynamic>.from(name.write.map((x) => x)),
      //"\u0024id": name.id,
      //"\u0024collection": name.collection,
    };
