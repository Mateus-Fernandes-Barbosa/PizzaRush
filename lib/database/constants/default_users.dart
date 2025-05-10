import 'package:pizza_rush/database/constants/default_address.dart';

enum DefaultUsers {
  // Store locally without verification, but cant transfer to cloud
  visitor(0, 'visitor@gmail.com', 'visitor user', [DefaultAddress.placeholder]);

  final int id;
  final String email;
  final String previewName;
  final List<DefaultAddress> addressesFkEnum;
  const DefaultUsers(this.id, this.email, this.previewName, this.addressesFkEnum);

  List<int> addressFkIds() => addressesFkEnum.map((address) => address.id).toList();
}
