
import 'package:sqflite/sqflite.dart';

import 'internal/database_definitions.dart';
import 'internal/database_helper.dart';
import 'internal/language.dart';

// Stored locally and refreshed on updates
enum Languages {
  ptBr(0, 'pt-BR'),
  enUs(1, 'en-US');

  final int id;
  final String acronym;
  const Languages(this.id, this.acronym);

  static List<String> acronyms() {
    return Languages.values.map((lang) => lang.acronym).toList();
  }
}

class DatabaseLanguage extends DatabaseHelper {
  // Insert example languages (optional)
  static Map<String, int>? _langMap;

  static Future<Map<String, int>> getLangIdMap() async {
    _langMap ??= await _getLangIdMap();
    return _langMap!;
  }

  // Fetch all languages and return as Map<lang, id>
  static Future<Map<String, int>> _getLangIdMap() async {
    final db = await DatabaseHelper.getDatabase();

    // Ensures enums are loaded. if they are the conflicts will be ignored with no duplicate
    _addLanguagesEnum();

    final List<Map<String, dynamic>> rows = await db.query(SqlTable.language.name);
    final Map<String, int> result = {
      for (var row in rows) row[LanguageNames.lang] as String: row[LanguageNames.id] as int
    };


    return result;
  }

  static Future<int> getIdFromEnum(Languages lang) async {
    _langMap ??= await _getLangIdMap();
    return _langMap![lang.acronym]!;
  }


  static Future<void> _addLanguages(List<String> langs) async {
    final db = await DatabaseHelper.getDatabase();
    final batch = db.batch();
    for (var lang in langs) {
      batch.insert(
        SqlTable.language.name,
        {LanguageNames.lang: lang},
        conflictAlgorithm: ConflictAlgorithm.ignore, // Avoid duplicate insert
      );
    }
    await batch.commit(noResult: true);
  }

  // Must always be true
  static Future<void> _addLanguagesEnum() async {
    final db = await DatabaseHelper.getDatabase();
    final batch = db.batch();
    for (var lang in Languages.values) {
      batch.insert(
        SqlTable.language.name,
        {LanguageNames.id: lang.id, LanguageNames.lang: lang.acronym},
        conflictAlgorithm: ConflictAlgorithm.ignore
      );
    }
    await batch.commit(noResult: true);
  }



}