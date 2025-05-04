import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_helper.dart';
import 'database_definitions.dart';

class LanguageNames {
  static const String id = 'id';
  static final String lang = "lang";
}

class Language {
  final Map<String, dynamic> _data;
  Language(this._data);

  int get id => _data[LanguageNames.id] as int;
  String get lang => _data[LanguageNames.lang] as String;


  Map<String, dynamic> toMap() => _data;

  @override
  String toString() {
    return 'Language(id: $id, lang: $lang)';
  }

  static List<Language> fromQueryResult(List<Map<String, dynamic>> rows) {
    return rows.map((row) => Language(row)).toList();
  }
}
