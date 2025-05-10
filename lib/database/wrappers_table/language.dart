import 'package:pizza_rush/database/names/language.dart';

// ABORTED UNTIL ADDITIONAL NAMES ARE ADDED

class Language {
  static List<String> columns = [
    LanguageNames.id,
    LanguageNames.lang,
  ];

  final Map<String, dynamic> _data;
  Language(this._data);

  int get id => LanguageGets.id(_data);
  String get lang => LanguageGets.lang(_data);

  Map<String, dynamic> toMap() => _data;

  static List<Language> fromQuery(List<Map<String, dynamic>> rows) =>
      rows.map((row) => Language(row)).toList();
}
