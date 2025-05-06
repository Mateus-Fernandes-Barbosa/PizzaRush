import '../constant_loaders/language_service.dart';
import 'languages.dart';

enum DrinkCatalog {
  cocaZeroCan(0, 'Coca Zero Lata 500ml', 'Coca-cola', null, Languages.ptBr),
  cocaCan(1, 'Coca Lata 500ml', 'Coca-cola', null, Languages.ptBr),
  cocaZeroGlassBottle(2, 'Coca Zero Bottle 550ml', 'Coca-cola', null, Languages.ptBr),
  guaranaGarrafaPet(3, 'Guarana garrafa 2L', 'Ambev', null, Languages.ptBr);

  final int id;
  final String name;
  final String brand;
  final String? description;
  final Languages langNameEnum;
  const DrinkCatalog(this.id, this.name, this.brand, this.description, this.langNameEnum);



  static List<String> acronyms() {
    return Languages.values.map((lang) => lang.acronym).toList();
  }

  Future<int> get langNameFk async => await StaticLanguageLoader.getIdFromEnum(langNameEnum);
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
  const DrinkPrices(this.id, this.price, this.startDateStr, this.endDateStr, this.fkDrinkEnum);

  int get startDate => DateTime.parse(startDateStr).millisecondsSinceEpoch;
  int? get endDate => endDateStr != null ? DateTime.parse(endDateStr!).millisecondsSinceEpoch : null;
  int get fkDrink => fkDrinkEnum.id;
}