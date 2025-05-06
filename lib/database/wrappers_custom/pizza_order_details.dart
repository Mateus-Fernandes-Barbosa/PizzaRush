import '../wrappers_join/pizza_details.dart';

/* Description:
 *   Small response packet that couples details from pizza order to the details
 *   of their different flavorings
 */
class PizzaOrderDetailsEntry {
  final double price;
  final String? additionalAnnotations;
  final List<PizzaDescription> details;

  const PizzaOrderDetailsEntry(this.price, this.additionalAnnotations, this.details);
}

