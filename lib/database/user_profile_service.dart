import 'package:pizza_rush/database/internal/user.dart';
import 'package:sqflite/sqflite.dart';

import 'internal/address.dart';
import 'internal/database_definitions.dart';
import 'internal/database_helper.dart';


enum DefaultUsers {
  // Store locally without verification, but cant transfer to cloud
  visitor(0, 'visitor@gmail.com', 'visitor user');

  final int id;
  final String email;
  final String previewName;
  const DefaultUsers(this.id, this.email, this.previewName);
}

class UserSqlService {
  // CRUD ON USER
  static Future<int> addUser({
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



  // --------------------------------------------------------
  // Addresses

  static Future<List<Address>> getAddressesForUser(int userId) async {
    final db = await DatabaseHelper.getDatabase();
    var res = await db.query(
      SqlTable.address.name,
      where: '${AddressNames.fkUser} = ?',
      whereArgs: [userId],
    );
    return Address.fromQueryResult(res);
  }


  static Future<int> addAddress({
    required int fkUser,
    required String line1,
    required String line2,
    required String neighborhood,
    required String city,
    required String postalCode,
    required String state,
    required String country,
  }) async {
    final db = await DatabaseHelper.getDatabase();
    return await db.insert(SqlTable.address.name, {
      AddressNames.line1: line1,
      AddressNames.line2: line2,
      AddressNames.neighborhood: neighborhood,
      AddressNames.city: city,
      AddressNames.postalCode: postalCode,
      AddressNames.state: state,
      AddressNames.country: country,
      AddressNames.fkUser: fkUser,
    });
  }

  static Future<void> updateAddress({
    required int addressId,
    String? line1,
    String? line2,
    String? neighborhood,
    String? city,
    String? postalCode,
    String? state,
    String? country,
  }) async {
    final db = await DatabaseHelper.getDatabase();

    final Map<String, Object?> updates = {};
    if (line1 != null) updates[AddressNames.line1] = line1;
    if (line2 != null) updates[AddressNames.line2] = line2;
    if (neighborhood != null) updates[AddressNames.neighborhood] = neighborhood;
    if (city != null) updates[AddressNames.city] = city;
    if (postalCode != null) updates[AddressNames.postalCode] = postalCode;
    if (state != null) updates[AddressNames.state] = state;
    if (country != null) updates[AddressNames.country] = country;

    if (updates.isNotEmpty) {
      await db.update(
        SqlTable.address.name,
        updates,
        where: '${AddressNames.id} = ?',
        whereArgs: [addressId],
      );
    }
  }

  static Future<void> deleteAddress(int addressId) async {
    final db = await DatabaseHelper.getDatabase();
    await db.delete(
      SqlTable.address.name,
      where: '${AddressNames.id} = ?',
      whereArgs: [addressId],
    );
  }


}