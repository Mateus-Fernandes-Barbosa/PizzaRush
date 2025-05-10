

class PizzaBorderNames {
  static const String id = 'id';
  static final String name = "name";
  static final String description = "description";
  static final String imageUrl = "image_url";
}


class PizzaBorderGets {
  static int id(Map<String, dynamic> data) =>
      data[PizzaBorderNames.id] as int;

  static String name(Map<String, dynamic> data) =>
      data[PizzaBorderNames.name] as String;

  static String? description(Map<String, dynamic> data) =>
      data[PizzaBorderNames.description] as String?;

  static String? imageUrl(Map<String, dynamic> data) =>
      data[PizzaBorderNames.imageUrl] as String?;
}


