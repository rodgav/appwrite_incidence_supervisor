class Area {
  Area({
    required this.name,
    required this.description,
    required this.read,
    required this.write,
    required this.id,
    required this.collection,
  });

  String name;
  String description;
  List<String> read;
  List<String> write;
  String id;
  String collection;
}
