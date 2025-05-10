enum PizzaBorderCatalog {
  normal(0, 'normal', null, 'margueritta.png'),
  cheddar(1, 'cheddar', null, 'margueritta.png'),
  queijo(2, 'queijo', null, 'margueritta.png');

  final int id;
  final String name;
  final String? description;
  final String imageUrl;
  const PizzaBorderCatalog(this.id, this.name, this.description, this.imageUrl);

}
