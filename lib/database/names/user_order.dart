
class UserOrderNames {
  static const String id = 'id';
  static final String requestTime = "request_time";
  static final String confirmationTime = "confirmation_time";
  static final String deliveryTime = "delivery_time";
  static final String fkUser = "fk_user";
}


class UserOrderGets {
  static int id(Map<String, dynamic> data) =>
      data[UserOrderNames.id] as int;

  static int? requestTimeUnix(Map<String, dynamic> data) =>
      data[UserOrderNames.requestTime] as int?;

  static int? confirmationTimeUnix(Map<String, dynamic> data) =>
      data[UserOrderNames.confirmationTime] as int?;

  static int? deliveryTimeUnix(Map<String, dynamic> data) =>
      data[UserOrderNames.deliveryTime] as int?;

  static DateTime? requestTimeDateTime(Map<String, dynamic> data) {
      int? unix = data[UserOrderNames.requestTime] as int?;
      return unix == null ? null : DateTime.fromMillisecondsSinceEpoch(unix);
  }

  static DateTime? confirmationTimeDateTime(Map<String, dynamic> data) {
    int? unix = data[UserOrderNames.confirmationTime] as int?;
    return unix == null ? null : DateTime.fromMillisecondsSinceEpoch(unix);
  }

  static DateTime? deliveryTimeDateTime(Map<String, dynamic> data) {
    int? unix = data[UserOrderNames.deliveryTime] as int?;
    return unix == null ? null : DateTime.fromMillisecondsSinceEpoch(unix);
  }


  static int fkUser(Map<String, dynamic> data) =>
      data[UserOrderNames.fkUser] as int;
}



