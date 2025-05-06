
class LanguageNames {
  static const String id = 'id';
  static final String lang = "lang";
}

class LanguageGets {
  static int id(Map<String, dynamic> data) =>
      data[LanguageNames.id] as int;

  static String lang(Map<String, dynamic> data) =>
      data[LanguageNames.lang] as String;
}

