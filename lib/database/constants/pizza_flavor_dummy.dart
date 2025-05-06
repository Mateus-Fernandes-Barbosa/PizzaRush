
import 'languages.dart';

enum PizzaFlavorCatalog {
  margueritta(0, 'margueritta', null, Languages.ptBr),
  quatroQueijos(1, 'quatro queijos', null, Languages.ptBr),
  calabresa(2, 'Calabresa', null, Languages.ptBr);

  final int id;
  final String name;
  final String? description;
  final Languages nameLang;
  const PizzaFlavorCatalog(this.id, this.name, this.description, this.nameLang);

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
  final PizzaFlavorCatalog fkPizzaFlavor;
  const PizzaFlavorPrices(this.id, this.priceSmall, this.priceMedium, this.priceLarge, this.startDateStr, this.endDateStr, this.fkPizzaFlavor);

  int get startDate => DateTime.parse(startDateStr).millisecondsSinceEpoch;
  int? get endDate => endDateStr != null ? DateTime.parse(endDateStr!).millisecondsSinceEpoch : null;
}

