import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../database_helper.dart';
import '../database_definitions.dart';



class DrinkNames {
  static const String id = 'id';
  static final String name = "name";
  static final String brand = "brand";
  static final String description = "description";
  static final String fkNameLang = "fk_name_lang";
}


class Drink {
  final Map<String, dynamic> _data;
  Drink(this._data);

  int get id => _data[DrinkNames.id] as int;
  String get name => _data[DrinkNames.name] as String;
  String get brand => _data[DrinkNames.brand] as String;
  String get description => _data[DrinkNames.description] as String;
  int get fkNameLang => _data[DrinkNames.fkNameLang] as int;


  Map<String, dynamic> toMap() => _data;

  @override
  String toString() {
    return 'DrinkBasePrice(id: $id, name: $name)';
  }

  static List<Drink> fromQueryResult(List<Map<String, dynamic>> rows) {
    return rows.map((row) => Drink(row)).toList();
  }
}


