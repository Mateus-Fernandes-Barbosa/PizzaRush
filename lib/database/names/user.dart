
class UserNames {
  static const String id = 'id';
  static final String email = "email";
  static final String previewName = "preview_name";
}

class UserGets {
  static int id(Map<String, dynamic> data) =>
      data[UserNames.id] as int;

  static String email(Map<String, dynamic> data) =>
      data[UserNames.email] as String;

  static String previewName(Map<String, dynamic> data) =>
      data[UserNames.previewName] as String;

}

