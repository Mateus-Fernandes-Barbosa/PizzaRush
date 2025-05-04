import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_helper.dart';
import 'database_definitions.dart';



class AddressNames {
  static const String id = 'id';
  static final String line1 = "line1";
  static final String line2 = "line2";
  static final String neighborhood = "neighborhood";
  static final String city = "city";
  static final String postalCode = "postalCode";
  static final String state = "state";
  static final String country = "country";
  static final String fkUser = "fkUser";
}


class Address {
  final Map<String, dynamic> _data;
  Address(this._data);

  int get id => _data[AddressNames.id] as int;
  int get fkUser => _data[AddressNames.fkUser] as int;
  String get line1 => _data[AddressNames.line1] as String;
  String get line2 => _data[AddressNames.line2] as String;
  String get neighborhood => _data[AddressNames.neighborhood] as String;
  String get city => _data[AddressNames.city] as String;
  String get postalCode => _data[AddressNames.postalCode] as String;
  String get state => _data[AddressNames.state] as String;
  String get country => _data[AddressNames.country] as String;

  Map<String, dynamic> toMap() => _data;

  @override
  String toString() {
    return 'Address(id: $id, city: $city, line1: $line1)';
  }

  static List<Address> fromQueryResult(List<Map<String, dynamic>> rows) {
    return rows.map((row) => Address(row)).toList();
  }
}



