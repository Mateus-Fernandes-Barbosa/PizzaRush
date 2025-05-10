import '../constant_loaders/language_service.dart';
import 'languages.dart';

enum DrinkCatalog {
  cocaZeroCan(0, 'Coca Zero Lata 500ml', 'Coca-cola', null, 'coca-cola.png'),
  cocaCan(1, 'Coca Lata 500ml', 'Coca-cola', null, 'coca-cola.png'),
  cocaZeroGlassBottle(2, 'Coca Zero Bottle 550ml', 'Coca-cola', null, 'coca-cola.png'),
  guaranaGarrafaPet(3, 'Guarana garrafa 2L', 'Ambev', null, 'coca-cola.png');

  final int id;
  final String name;
  final String brand;
  final String? description;
  final String imageUrl;
  const DrinkCatalog(this.id, this.name, this.brand, this.description, this.imageUrl);



}

enum DrinkPrices {
  cocaZeroCanPrice1(0, 7.00, '2024-05-26', null, DrinkCatalog.cocaZeroCan),
  cocaCanPrice1(1, 7.00, '2024-05-26', null, DrinkCatalog.cocaCan),
  cocaZeroGlassBottlePrice1(2, 14.00, '2024-05-26', null, DrinkCatalog.cocaZeroGlassBottle),
  guarafaGarrafaPetPrice1(3, 20.00, '2024-05-26', null, DrinkCatalog.guaranaGarrafaPet);

  final int id;
  final double price;
  final String startDateStr;
  final String? endDateStr;
  final DrinkCatalog fkDrinkEnum;
  const DrinkPrices(
      this.id,
      this.price,
      this.startDateStr,
      this.endDateStr,
      this.fkDrinkEnum
  );

  int get startDate => DateTime.parse(startDateStr).millisecondsSinceEpoch;
  int? get endDate => endDateStr != null ? DateTime.parse(endDateStr!).millisecondsSinceEpoch : null;
  int get fkDrink => fkDrinkEnum.id;
}