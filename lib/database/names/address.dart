
class AddressNames {
  static const String id = 'id';
  static final String line1 = "line1";
  static final String line2 = "line2";
  static final String neighborhood = "neighborhood";
  static final String city = "city";
  static final String postalCode = "postalCode";
  static final String state = "state";
  static final String country = "country";
  static final String fkUser = "fkUser";
}


class AddressGets {
  static int id(Map<String, dynamic> data) =>
      data[AddressNames.id] as int;

  static int fkUser(Map<String, dynamic> data) =>
      data[AddressNames.fkUser] as int;

  static String line1(Map<String, dynamic> data) =>
      data[AddressNames.line1] as String;

  static String line2(Map<String, dynamic> data) =>
      data[AddressNames.line2] as String;

  static String neighborhood(Map<String, dynamic> data) =>
      data[AddressNames.neighborhood] as String;

  static String city(Map<String, dynamic> data) =>
      data[AddressNames.city] as String;

  static String postalCode(Map<String, dynamic> data) =>
      data[AddressNames.postalCode] as String;

  static String state(Map<String, dynamic> data) =>
      data[AddressNames.state] as String;

  static String country(Map<String, dynamic> data) =>
      data[AddressNames.country] as String;
}



