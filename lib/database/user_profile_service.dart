import 'package:pizza_rush/database/names/user.dart';
import 'package:pizza_rush/database/wrappers_table/address.dart';
import 'package:pizza_rush/database/wrappers_table/user.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';
import 'constants/default_users.dart';
import 'names/address.dart';
import 'database_definitions.dart';



class UserSqlService {
  static Future<List<User>> getAllUsers() async {
    final db = await DatabaseHelper.getDatabase();
    var res = await db.query(
      SqlTable.user.name,
      columns: User.columns,
    );
    return User.fromQuery(res);
  }

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


  // --------------------------------------------------------
  // Addresses

  static Future<List<Address>> getAddressesForUser(int userId) async {
    final db = await DatabaseHelper.getDatabase();
    var res = await db.query(
      SqlTable.address.name,
      where: '${AddressNames.fkUser} = ?',
      whereArgs: [userId],
    );
    return Address.fromQuery(res);
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
    required String line1,
    String? line2,
    String? neighborhood,
    String? city,
    String? postalCode,
    String? state,
    String? country,
  }) async {
    final db = await DatabaseHelper.getDatabase();

    final Map<String, Object?> updates = {};
    updates[AddressNames.line1] = line1;
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