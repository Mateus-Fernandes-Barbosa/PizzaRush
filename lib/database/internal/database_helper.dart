import 'package:pizza_rush/database/drink_catalog_service.dart';
import 'package:pizza_rush/database/language_service.dart';
import 'package:pizza_rush/database/pizza_catalog_service.dart';
import 'package:pizza_rush/database/user_profile_service.dart';
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

    DatabaseLanguage.getLangIdMap();

    UserSqlService.addUserDefaults();


    PizzaFlavorCatalogService.addPizzasFromCatalog();
    PizzaFlavorCatalogService.addPizzaPriceCatalog();

    DrinkCatalogService.addDrinksFromCatalog();
    DrinkCatalogService.addDrinkPriceCatalog();



  }

}