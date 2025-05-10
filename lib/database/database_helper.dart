import 'package:pizza_rush/database/constant_loaders/drink_catalog_service.dart';
import 'package:pizza_rush/database/constant_loaders/language_service.dart';
import 'package:pizza_rush/database/constant_loaders/pizza_catalog_service.dart';
import 'package:pizza_rush/database/constant_loaders/user_address.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_definitions.dart';

class DatabaseHelper {
  static Database? _db;

  // Open or create the database
  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await createTables(db);
      },
    );


    await ensureInitialization();

    return _db!;
  }

  // FOR NOW THE CODE IS NOT ENSURED UNLESS THIS IS ENSURED BEFORE ANY OPERATIONS
  static Future<void> ensureInitialization() async {
    AddressDefault.addAddressDefaults();
    UserDefault.addUserDefaults();

    StaticPizzaFlavorCatalog.addPizzasFromCatalog();
    StaticPizzaFlavorCatalog.addPizzaPriceCatalog();
    StaticPizzaFlavorCatalog.addPizzasBorders();

    StaticDrinkCatalog.addDrinksFromCatalog();
    StaticDrinkCatalog.addDrinkPriceCatalog();
  }

}