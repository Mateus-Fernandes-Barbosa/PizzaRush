import 'package:pizza_rush/database/names/user_address.dart';
import 'package:pizza_rush/database/names/user_order.dart';

import 'package:pizza_rush/database/database_helper.dart';
import 'package:pizza_rush/database/database_definitions.dart';
import 'package:pizza_rush/database/names/address.dart';

class SqlAddress {
  static List<String> columns = [
    AddressNames.id,
    AddressNames.line1,
    AddressNames.line2,
    AddressNames.neighborhood,
    AddressNames.city,
    AddressNames.postalCode,
    AddressNames.state,
    AddressNames.country,
  ];

  final Map<String, dynamic> _data;
  SqlAddress(this._data);

  int get id => AddressGets.id(_data);
  String get line1 => AddressGets.line1(_data);

  // Until proper implementation, this is aborted
  // String get line2 => AddressGets.line2(_data);
  // String get neighborhood => AddressGets.neighborhood(_data);
  // String get city => AddressGets.city(_data);
  // String get postalCode => AddressGets.postalCode(_data);
  // String get state => AddressGets.state(_data);
  // String get country => AddressGets.country(_data);

  Map<String, dynamic> toMap() => _data;

  @override
  String toString() => 'Address(id: $id, line1: $line1)';

  static List<SqlAddress> fromQuery(List<Map<String, dynamic>> rows) =>
      rows.map((row) => SqlAddress(row)).toList();

  static Future<List<SqlAddress>> getAddressesForUser(int userId) async {
    final db = await DatabaseHelper.getDatabase();

    String selectQuery = '''
      address.${AddressNames.id} AS ${AddressNames.id},
      address.${AddressNames.line1} AS ${AddressNames.line1},
      address.${AddressNames.line2} AS ${AddressNames.line2},
      address.${AddressNames.neighborhood} AS ${AddressNames.neighborhood},
      address.${AddressNames.city} AS ${AddressNames.city},
      address.${AddressNames.postalCode} AS ${AddressNames.postalCode},
      address.${AddressNames.state} AS ${AddressNames.state},
      address.${AddressNames.country} AS ${AddressNames.country},
    ''';

    String sql = '''
      SELECT $selectQuery
      FROM ${SqlTable.user_address.name} AS u_address
      
      JOIN ${SqlTable.address.name} AS address ON 
        address.${AddressNames.id} = address.${UserAddressNames.fkAddress}
        
      WHERE u_address.${UserAddressNames.fkUser} = ?
    ''';

    var res = await db.rawQuery(sql, [userId]);
    return SqlAddress.fromQuery(res);
  }

  static Future<SqlAddress> getAddressesForUserOrder(int orderId) async {
    final db = await DatabaseHelper.getDatabase();

    String sql = '''
      SELECT address.*
      FROM ${SqlTable.user_order.name} AS user_order
      JOIN ${SqlTable.address.name} AS address ON 
        address.${AddressNames.id} = user_order.${UserOrderNames.fkAddress}
        
      WHERE user_order.${UserOrderNames.id} = ?
    ''';

    final map = await db.rawQuery(sql, [orderId]);
    if (map.isNotEmpty) {
      return SqlAddress(map.first);
    } else {
      throw Exception('Address not found for order $orderId');
    }
  }

  static Future<int> addAddress({
    required int fkUser,
    required String line1,
    String? line2,
    String? neighborhood,
    String? city,
    String? postalCode,
    String? state,
    String? country,
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
