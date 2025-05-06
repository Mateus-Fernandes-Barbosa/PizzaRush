

class PizzaFlavorNames {
  static const String id = 'id';
  static final String name = "name";
  static final String description = "description";
  static final String fkNameLang = "fk_name_lang";
}


class PizzaFlavorGets {
  static int id(Map<String, dynamic> data) =>
      data[PizzaFlavorNames.id] as int;

  static String name(Map<String, dynamic> data) =>
      data[PizzaFlavorNames.name] as String;

  static String description(Map<String, dynamic> data) =>
      data[PizzaFlavorNames.description] as String;

  static int fkNameLang(Map<String, dynamic> data) =>
      data[PizzaFlavorNames.fkNameLang] as int;
}


