import 'package:flutter/cupertino.dart';
import 'package:pizza_rush/database/constants/default_address.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/default_users.dart';
import '../database_definitions.dart';
import '../database_helper.dart';
import '../names/address.dart';
import '../names/user.dart';
import '../names/user_address.dart';

class AddressDefault {
  static Future<void> addAddressDefaults() async {
    Database db = await DatabaseHelper.getDatabase();
    Batch batch = db.batch();

    for (final address in DefaultAddress.values) {
      debugPrint(address.toString());
      batch.insert(
        SqlTable.address.name,
        {
          AddressNames.id: address.id,
          AddressNames.line1: address.line1,
          AddressNames.line2: address.line2,
          AddressNames.neighborhood: address.neighborhood,
          AddressNames.city: address.postalCode,
          AddressNames.state: address.state,
          AddressNames.country: address.country,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore, // Replaces if same `id` exists
      );
    }
    await batch.commit(noResult: true);
  }
}

class UserDefault {
  static Future<void> addUserDefaults() async {
    Database db = await DatabaseHelper.getDatabase();
    Batch batch = db.batch();

    for (final user in DefaultUsers.values) {
      debugPrint(user.toString());
      batch.insert(
        SqlTable.user.name,
        {
          UserNames.id: user.id,
          UserNames.email: user.email,
          UserNames.previewName: user.previewName,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore, // Replaces if same `id` exists
      );

      for (final int address in user.addressFkIds()) {
        debugPrint(address.toString());
        batch.insert(
          SqlTable.user_address.name,
          {
            UserAddressNames.fkUser: user.id,
            UserAddressNames.fkAddress: address,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore, // Replaces if same `id` exists
        );

      }
    }


    await batch.commit(noResult: true);
  }



}