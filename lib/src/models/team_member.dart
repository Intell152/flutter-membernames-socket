class Member {
  String id;
  String name;
  int cuanProyects;

  Member({this.id, this.name, this.cuanProyects});

  factory Member.fromMap(Map<String, dynamic> obj) => Member(
    id: obj['id'],
    name: obj['name'],
    cuanProyects: obj['cuanProyects']
  );
}
