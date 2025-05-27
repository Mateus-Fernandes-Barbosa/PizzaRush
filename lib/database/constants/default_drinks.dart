import '../constant_loaders/language_service.dart';
import 'languages.dart';

enum DrinkCatalog {
  cocaBottle(6, 'Coca Cola 2L', 'Coca-cola', null, 'coca.png'),
  spriteBottle(7, 'Sprite 2L', 'Sprite', null, 'sprite.png'),
  waterBottle(8, 'Agua 1L', 'Agua', null, 'agua.png');

  final int id;
  final String name;
  final String brand;
  final String? description;
  final String imageUrl;
  const DrinkCatalog(
    this.id,
    this.name,
    this.brand,
    this.description,
    this.imageUrl,
  );
}

enum DrinkPrices {
  cocaBottlePrice1(6, 13.00, '2024-05-26', null, DrinkCatalog.cocaBottle),
  spriteBottlePrice1(7, 13.00, '2024-05-26', null, DrinkCatalog.spriteBottle),
  waterBottlePrice1(
    8,
    7.00,
    '2024-05-26',
    null,
    DrinkCatalog.waterBottle,
  );

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
    this.fkDrinkEnum,
  );

  int get startDate => DateTime.parse(startDateStr).millisecondsSinceEpoch;
  int? get endDate =>
      endDateStr != null
          ? DateTime.parse(endDateStr!).millisecondsSinceEpoch
          : null;
  int get fkDrink => fkDrinkEnum.id;
}
