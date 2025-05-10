enum DefaultAddress {
  // Store locally without verification, but cant transfer to cloud
  placeholder(0, 'line1', 'line2', 'neighborhood', 'city', 'postal_code', 'state', 'country');

  final int id;
  final String line1;
  final String line2;
  final String neighborhood;
  final String city;
  final String postalCode;
  final String state;
  final String country;

  const DefaultAddress(
    this.id, this.line1, this.line2, this.neighborhood, this.city, this.postalCode, this.state, this.country
  );
}
