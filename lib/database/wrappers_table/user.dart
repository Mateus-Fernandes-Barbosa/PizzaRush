import 'package:sqflite/sqflite.dart';

import 'package:pizza_rush/database/database_helper.dart';
import 'package:pizza_rush/database/database_definitions.dart';
import 'package:pizza_rush/database/names/user.dart';



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

  //----------------------------------------------
  // Queries

  static Future<List<User>> getAll() async {
    final db = await DatabaseHelper.getDatabase();
    var res = await db.query(
      SqlTable.user.name,
      columns: User.columns,
    );
    return User.fromQuery(res);
  }

  static Future<int> add({
    required int id,
    required String email,
    required String previewName,
  }) async {
    final db = await DatabaseHelper.getDatabase();
    return await db.insert(
      SqlTable.user.name,
      {
        UserNames.id: id,
        UserNames.email: email,
        UserNames.previewName: previewName,
      },
      conflictAlgorithm: ConflictAlgorithm.fail, // Replaces if same `id` exists
    );
  }

  static Future<void> updateUser({
    required int id,
    String? email,
    String? previewName,
  }) async {
    final db = await DatabaseHelper.getDatabase();
    final Map<String, Object?> updates = {};
    if (email != null) updates[UserNames.email] = email;
    if (previewName != null) updates[UserNames.previewName] = previewName;

    if (updates.isNotEmpty) {
      await db.update(
        SqlTable.user.name,
        updates,
        where: '${UserNames.id} = ?',
        whereArgs: [id],
      );
    }
  }

  static Future<void> deleteUser(int id) async {
    final db = await DatabaseHelper.getDatabase();
    db.delete(SqlTable.user.name, where: '${UserNames.id} = ?', whereArgs: [id]);
  }


}
