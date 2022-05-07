class Incidence {
  Incidence({
    required this.name,
    required this.description,
    required this.dateCreate,
    required this.image,
    required this.priority,
    required this.area,
    required this.employe,
    required this.supervisor,
    required this.solution,
    required this.dateSolution,
    required this.active,
    required this.read,
    required this.write,
    required this.id,
    required this.collection,
  });

  String name;
  String description;
  DateTime dateCreate;
  String image;
  String priority;
  String area;
  String employe;
  String supervisor;
  String solution;
  DateTime dateSolution;
  bool active;
  List<String> read;
  List<String> write;
  String id;
  String collection;
}

class Incidences {
  List<Incidence> incidences;
  int total;

  Incidences({required this.incidences, required this.total});
}
