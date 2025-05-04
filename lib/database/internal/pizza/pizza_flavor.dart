import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../database_helper.dart';
import '../database_definitions.dart';



class PizzaFlavorNames {
  static const String id = 'id';
  static final String name = "name";
  static final String description = "description";
  static final String fkNameLang = "fk_name_lang";
}


class PizzaFlavor {
  final Map<String, dynamic> _data;
  PizzaFlavor(this._data);

  int get id => _data[PizzaFlavorNames.id] as int;
  String get name => _data[PizzaFlavorNames.name] as String;
  String get description => _data[PizzaFlavorNames.description] as String;
  int get fkNameLang => _data[PizzaFlavorNames.fkNameLang] as int;


  Map<String, dynamic> toMap() => _data;

  @override
  String toString() {
    return 'DrinkBasePrice(id: $id, name: $name)';
  }

  static List<PizzaFlavor> fromQueryResult(List<Map<String, dynamic>> rows) {
    return rows.map((row) => PizzaFlavor(row)).toList();
  }
}


