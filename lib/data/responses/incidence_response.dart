import 'dart:convert';

import 'package:appwrite_incidence_supervisor/domain/model/incidence_model.dart';

Incidence incidenceFromString(String str) =>
    incidenceFromJson(json.decode(str));

String incidenceToString(Incidence data) => json.encode(incidenceToJson(data));

Incidence incidenceFromJson(Map<String, dynamic> json) => Incidence(
      name: json["name"] ?? '',
      description: json["description"] ?? '',
      dateCreate: json["date_create"] != null
          ? DateTime.parse(json["date_create"])
          : DateTime.now(),
      image: json["image"] ?? '',
      priority: json["priority"] ?? '',
      area: json["area"] ?? '',
      employe: json["employe"] ?? '',
      supervisor: json["supervisor"] ?? '',
      solution: json["solution"] ?? '',
      dateSolution: json["date_solution"] != 'null'
          ? DateTime.parse(json["date_solution"])
          : DateTime.now(),
      active: json["active"]??false,
      read: json["\u0024read"] != null
          ? List<String>.from(json["\u0024read"].map((x) => x))
          : [],
      write: json["\u0024write"] != null
          ? List<String>.from(json["\u0024write"].map((x) => x))
          : [],
      id: json["\u0024id"],
      collection: json["\u0024collection"],
    );

Map<String, dynamic> incidenceToJson(Incidence incidence) => {
      "name": incidence.name,
      "description": incidence.description,
      "date_create": incidence.dateCreate.toIso8601String(),
      "image": incidence.image,
      "priority": incidence.priority,
      "area": incidence.area,
      "employe": incidence.employe,
      "supervisor": incidence.supervisor,
      "solution": incidence.solution,
      "date_solution": incidence.dateSolution.toIso8601String(),
      "active":incidence.active,
      //"\u0024read": List<dynamic>.from(incidence.read.map((x) => x)),
      //"\u0024write": List<dynamic>.from(incidence.write.map((x) => x)),
      //"\u0024id": incidence.id,
      //"\u0024collection": incidence.collection,
    };
