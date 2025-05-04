import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_helper.dart';
import 'database_definitions.dart';

class UserNames {
  static const String id = 'id';
  static final String email = "email";
  static final String previewName = "preview_name";
}

class User {
  final Map<String, dynamic> _data;
  User(this._data);

  int get id => _data[UserNames.id] as int;
  String get email => _data[UserNames.email] as String;
  String get previewName => _data[UserNames.previewName] as String;


  Map<String, dynamic> toMap() => _data;

  @override
  String toString() {
    return 'User(id: $id, email: $email, preview_name: $previewName)';
  }

  static List<User> fromQueryResult(List<Map<String, dynamic>> rows) {
    return rows.map((row) => User(row)).toList();
  }
}

