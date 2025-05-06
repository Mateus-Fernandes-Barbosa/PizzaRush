import '../names/address.dart';

class Address {
  static List<String> columns = [
    AddressNames.id,
    AddressNames.fkUser,
    AddressNames.line1,
    AddressNames.line2,
    AddressNames.neighborhood,
    AddressNames.city,
    AddressNames.postalCode,
    AddressNames.state,
    AddressNames.country,
  ];

  final Map<String, dynamic> _data;
  Address(this._data);

  int get id => AddressGets.id(_data);
  int get fkUser => AddressGets.fkUser(_data);
  String get line1 => AddressGets.line1(_data);
  String get line2 => AddressGets.line2(_data);
  String get neighborhood => AddressGets.neighborhood(_data);
  String get city => AddressGets.city(_data);
  String get postalCode => AddressGets.postalCode(_data);
  String get state => AddressGets.state(_data);
  String get country => AddressGets.country(_data);

  Map<String, dynamic> toMap() => _data;

  @override
  String toString() =>
      'Address(id: $id, fk_user: $fkUser, line1: $line1, line2: $line2, '
          'neighborhood: $neighborhood, city: $city, postalCode: $postalCode, '
          'state: $state, country: $country)';

  static List<Address> fromQuery(List<Map<String, dynamic>> rows) =>
      rows.map((row) => Address(row)).toList();
}
