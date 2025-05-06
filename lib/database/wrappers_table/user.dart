import '../names/user.dart';

class User {
  static List<String> columns = [
    UserNames.id,
    UserNames.email,
    UserNames.previewName
  ];

  final Map<String, dynamic> _data;
  User(this._data);

  int get id => UserGets.id(_data);
  String get email => UserGets.email(_data);
  String get previewName => UserGets.previewName(_data);


  Map<String, dynamic> toMap() => _data;

  @override
  String toString() =>
      'User(id: $id, email: $email, previewName: $previewName)';

  static List<User> fromQuery(List<Map<String, dynamic>> rows) =>
      rows.map((row) => User(row)).toList();
}
