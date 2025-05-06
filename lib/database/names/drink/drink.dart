
class DrinkNames {
  static const String id = 'id';
  static final String name = "name";
  static final String brand = "brand";
  static final String description = "description";
  static final String fkNameLang = "fk_name_lang";
}


class DrinkGets {
  static int id(Map<String, dynamic> data) =>
      data[DrinkNames.id] as int;

  static String name(Map<String, dynamic> data) =>
      data[DrinkNames.name] as String;

  static String brand(Map<String, dynamic> data) =>
      data[DrinkNames.brand] as String;

  static String description(Map<String, dynamic> data) =>
      data[DrinkNames.description] as String;

  static int fkNameLang(Map<String, dynamic> data) =>
      data[DrinkNames.fkNameLang] as int;
}


