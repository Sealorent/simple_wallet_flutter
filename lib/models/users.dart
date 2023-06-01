class Users {
  final dynamic id;
  final String name;
  final String password;

  Users({this.id, required this.name, required this.password});

  Users.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        password = res["password"];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'password': password};
  }
}
