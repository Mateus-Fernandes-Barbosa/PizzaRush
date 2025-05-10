
class UserAddressNames {
  static const String fkUser = 'fk_user';
  static const String fkAddress = 'fk_address';

}


class UserAddressGets {
  static int fkUser(Map<String, dynamic> data) =>
      data[UserAddressNames.fkUser] as int;

  static int fkAddress(Map<String, dynamic> data) =>
      data[UserAddressNames.fkAddress] as int;
  
}



