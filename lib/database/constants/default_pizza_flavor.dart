
import 'languages.dart';

enum PizzaFlavorCatalog {
  margueritta(0, 'margueritta', null, 'margueritta.png'),
  quatroQueijos(1, 'quatro queijos', null, 'margueritta.png'),
  calabresa(2, 'Calabresa', null, 'margueritta.png');

  final int id;
  final String name;
  final String? description;
  final String imageUrl;
  const PizzaFlavorCatalog(this.id, this.name, this.description, this.imageUrl);

}

enum PizzaFlavorPrices {
  marguerittaPreco1(0, 7.00, 14.00, 21.00, '2024-05-26', null, PizzaFlavorCatalog.margueritta),
  quatroQueijosPreco1(1, 8.00, 15.00, 21.00, '2024-05-26', null, PizzaFlavorCatalog.quatroQueijos),
  calabresaPreco1(2, 6.50, 12.00, 17.5, '2024-05-26', null, PizzaFlavorCatalog.calabresa);

  final int id;
  final double priceSmall;
  final double priceMedium;
  final double priceLarge;
  final String startDateStr;
  final String? endDateStr;
  final PizzaFlavorCatalog fkPizzaFlavorEnum;
  const PizzaFlavorPrices(
      this.id,
      this.priceSmall,
      this.priceMedium,
      this.priceLarge,
      this.startDateStr,
      this.endDateStr,
      this.fkPizzaFlavorEnum
    );

  int get startDate => DateTime.parse(startDateStr).millisecondsSinceEpoch;
  int? get endDate => endDateStr != null ? DateTime.parse(endDateStr!).millisecondsSinceEpoch : null;
  int get fkPizzaFlavor => fkPizzaFlavorEnum.id;
}

