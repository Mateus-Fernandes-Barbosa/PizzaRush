class UserOrderNames {
  static const String id = 'id';
  static final String requestTime = "request_time";
  static final String confirmationTime = "confirmation_time";
  static final String deliveryTime = "delivery_time";
  static final String fkUser = "fk_user";
  static final String fkAddress = "fk_address";
  static final String primaryContactPhone = "primary_contact_phone";
  static final String primaryContactName = "primary_contact_name";
  static final String primaryContactObservations =
      "primary_contact_observations";
  static final String totalAmount = "total_amount";
  static final String paymentMethod = "payment_method";
}

class UserOrderGets {
  static int id(Map<String, dynamic> data) => data[UserOrderNames.id] as int;

  static int requestTimeUnix(Map<String, dynamic> data) =>
      data[UserOrderNames.requestTime] as int;

  static int confirmationTimeUnix(Map<String, dynamic> data) =>
      data[UserOrderNames.confirmationTime] as int;

  static int deliveryTimeUnix(Map<String, dynamic> data) =>
      data[UserOrderNames.deliveryTime] as int;

  static DateTime requestTimeDateTime(Map<String, dynamic> data) {
    int unix = data[UserOrderNames.requestTime] as int;
    return DateTime.fromMillisecondsSinceEpoch(unix);
  }

  static DateTime confirmationTimeDateTime(Map<String, dynamic> data) {
    int unix = data[UserOrderNames.confirmationTime] as int;
    return DateTime.fromMillisecondsSinceEpoch(unix);
  }

  static DateTime deliveryTimeDateTime(Map<String, dynamic> data) {
    int unix = data[UserOrderNames.deliveryTime] as int;
    return DateTime.fromMillisecondsSinceEpoch(unix);
  }

  static int fkUser(Map<String, dynamic> data) =>
      data[UserOrderNames.fkUser] as int;

  static int fkAddress(Map<String, dynamic> data) =>
      data[UserOrderNames.fkAddress] as int;

  static String primaryContactPhone(Map<String, dynamic> data) =>
      data[UserOrderNames.primaryContactPhone] as String;

  static String primaryContactName(Map<String, dynamic> data) =>
      data[UserOrderNames.primaryContactName] as String;

  static String? primaryContactObservations(Map<String, dynamic> data) =>
      data[UserOrderNames.primaryContactObservations] as String?;

  static double? totalAmount(Map<String, dynamic> data) =>
      data[UserOrderNames.totalAmount] != null
          ? (data[UserOrderNames.totalAmount] as num).toDouble()
          : null;

  static String? paymentMethod(Map<String, dynamic> data) =>
      data[UserOrderNames.paymentMethod] as String?;
}
