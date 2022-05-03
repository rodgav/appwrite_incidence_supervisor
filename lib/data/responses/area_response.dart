import 'dart:convert';

import 'package:appwrite_incidence_supervisor/domain/model/area_model.dart';

Area areaFromString(String str) => areaFromJson(json.decode(str));

String areaToString(Area data) => json.encode(areaToJson(data));


Area areaFromJson(Map<String, dynamic> json) =>
    Area(
      name: json["name"],
      description: json["description"],
      read: List<String>.from(json["\u0024read"].map((x) => x)),
      write: List<String>.from(json["\u0024write"].map((x) => x)),
      id: json["\u0024id"],
      collection: json["\u0024collection"],
    );

Map<String, dynamic> areaToJson(Area area) =>
    {
      "name": area.name,
      "description": area.description,
      //"\u0024read": List<dynamic>.from(area.read.map((x) => x)),
      //"\u0024write": List<dynamic>.from(area.write.map((x) => x)),
      //"\u0024id": area.id,
      //"\u0024collection": area.collection,
    };
