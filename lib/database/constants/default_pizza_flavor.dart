import 'languages.dart';

enum PizzaFlavorCatalog {
  calabresa(0, 'Calabresa', 'Pizza tradicional com calabresa', 'calabresa.jpg'),
  frango(1, 'Frango', 'Pizza saborosa com frango', 'frango.png'),
  portuguesa(
    2,
    'Portuguesa',
    'Pizza com ovos, presunto e azeitonas',
    'portuguesa.png',
  ),
  margueritta(3, 'Margherita', 'Pizza clássica italiana', 'marguerita.png'),
  quatroQueijos(
    4,
    'Quatro Queijos',
    'Pizza com 4 tipos de queijo',
    'quatroQueijos.png',
  ),
  pepperoni(5, 'Pepperoni', 'Pizza americana com pepperoni', 'pepperoni.png');

  final int id;
  final String name;
  final String? description;
  final String imageUrl;
  const PizzaFlavorCatalog(this.id, this.name, this.description, this.imageUrl);
}

enum PizzaFlavorPrices {
  calabresaPreco1(
    0,
    6.50,
    12.00,
    17.5,
    '2024-05-26',
    null,
    PizzaFlavorCatalog.calabresa,
  ),
  frangoPreco1(
    1,
    7.00,
    13.00,
    18.00,
    '2024-05-26',
    null,
    PizzaFlavorCatalog.frango,
  ),
  portuguesaPreco1(
    2,
    8.00,
    15.00,
    22.00,
    '2024-05-26',
    null,
    PizzaFlavorCatalog.portuguesa,
  ),
  marguerittaPreco1(
    3,
    7.00,
    14.00,
    21.00,
    '2024-05-26',
    null,
    PizzaFlavorCatalog.margueritta,
  ),
  quatroQueijosPreco1(
    4,
    8.00,
    15.00,
    21.00,
    '2024-05-26',
    null,
    PizzaFlavorCatalog.quatroQueijos,
  ),
  pepperoniPreco1(
    5,
    7.50,
    14.50,
    20.50,
    '2024-05-26',
    null,
    PizzaFlavorCatalog.pepperoni,
  );

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
    this.fkPizzaFlavorEnum,
  );

  int get startDate => DateTime.parse(startDateStr).millisecondsSinceEpoch;
  int? get endDate =>
      endDateStr != null
          ? DateTime.parse(endDateStr!).millisecondsSinceEpoch
          : null;
  int get fkPizzaFlavor => fkPizzaFlavorEnum.id;
}
