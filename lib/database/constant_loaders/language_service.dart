
import 'package:sqflite/sqflite.dart';

import '../database_definitions.dart';
import '../database_helper.dart';
import '../constants/languages.dart';
import '../names/language.dart';


/* Description:
 *   Loads languages from database and map their id to acronyms
 *   Used for displaying respective language of the label of a product
 *
 * Warning: Might not be needed as all languages follow static enum of program
 */
class StaticLanguageLoader extends DatabaseHelper {
  // Insert example languages (optional)
  static Map<String, int>? _langMap;


  // DISABLED FOR NOW

  // static Future<int> getIdFromEnum(Languages lang) async {
  //   _langMap ??= await _getLangIdMap();
  //   return _langMap![lang.acronym]!;
  // }
  //
  // static Future<Map<String, int>> getLangIdMap() async {
  //   _langMap ??= await _getLangIdMap();
  //   return _langMap!;
  // }

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