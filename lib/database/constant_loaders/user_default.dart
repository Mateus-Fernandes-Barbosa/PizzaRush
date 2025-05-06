import 'package:sqflite/sqflite.dart';

import '../constants/default_users.dart';
import '../database_definitions.dart';
import '../database_helper.dart';
import '../names/user.dart';

class UserDefault {
  static Future<void> addUserDefaults() async {
    Database db = await DatabaseHelper.getDatabase();
    Batch batch = db.batch();

    for (final user in DefaultUsers.values) {
      print(user);
      batch.insert(
        SqlTable.user.name,
        {
          UserNames.id: user.id,
          UserNames.email: user.email,
          UserNames.previewName: user.previewName,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore, // Replaces if same `id` exists
      );
    }
    await batch.commit(noResult: true);
  }

}