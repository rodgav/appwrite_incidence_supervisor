class IncidenceSel {
  String area, priority;
  bool? active;
  String? image;

  IncidenceSel({String? area, String? priority, this.active,this.image})
      : area = area ?? '',
        priority = priority ?? '';
}
