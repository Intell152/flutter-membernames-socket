class Member {
  String id;
  String name;
  int cuanProyects;

  Member({
    this.id,
    this.name,
    this.cuanProyects
  });

  factory Member.fromMap(Map<String, dynamic> obj) => Member(
    id          : obj.containsKey('id') ? obj['id'] : 'no-id',
    name        : obj.containsKey('name') ? obj['name'] : 'no-name',
    cuanProyects: obj.containsKey('cuanProyects') ? obj['cuanProyects'] : 'no-cuanProyects'
  );
}
