import '../wrappers_table/address.dart';

class UserAddress {
  final int id;
  final String email;
  final String previewName;
  final List<Address> addresses;
  UserAddress(this.id, this.email, this.previewName, this.addresses);


  @override
  String toString() =>
      'User(id: $id, email: $email, previewName: $previewName, address:$addresses)';

}
