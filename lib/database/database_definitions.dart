// database_helper.dart
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

/* Some systems may not support multiple sql commands
 * As such each execute can only take in one command at a time
 */

enum SqlTable {
  /* Defined by admins. An array is used to store the indexes on startup.
   * This is a feature to be thought of in the future, when non regional
   * names are to be included (for example call the english name for the pizza)
   * Names are by default given by the regional language (PT-BR) for drinks,
   * pizza and pizza borders, and auxiliar tables with language links can be used
   * Auxiliar additional naming tables are not implemented as of now
   */
  language(''' 
    CREATE TABLE `language` (
      `id` integer primary key NOT NULL UNIQUE,
      `lang` TEXT NOT NULL UNIQUE
    );
  '''),

  user('''
    CREATE TABLE `user` (
      `id` integer primary key NOT NULL UNIQUE,
      `email` TEXT NOT NULL,
      `preview_name` TEXT NOT NULL
    );
  '''),

  // Those field would be better off as not null, but a non blocking parser
  // from written single liner is too complicated for this prototype
  address('''
    CREATE TABLE `address` (
      `id` integer primary key NOT NULL UNIQUE,
      `line_1` TEXT NOT NULL,
      `line_2` TEXT NULL,
      `neighborhood` TEXT NULL,
      `city` TEXT NULL,
      `postal_code` TEXT NULL,
      `state` TEXT NULL,
      `country` TEXT NULL
    );
  '''),

  user_address('''
    CREATE TABLE `user_address` (
      `fk_user` INTEGER NOT NULL,
      `fk_address` INTEGER NOT NULL,
      FOREIGN KEY(`fk_user`) REFERENCES `user`(`id`),
      FOREIGN KEY(`fk_address`) REFERENCES `address`(`id`)
    );
  '''),

  drink('''
    CREATE TABLE `drink` (
      `id` integer primary key NOT NULL UNIQUE,
      `name` TEXT NOT NULL UNIQUE,
      `brand` TEXT NOT NULL,
      `description` TEXT NULL,
      `image_url` TEXT NULL
       
    );
  '''),

  drink_price('''
    CREATE TABLE `drink_price` (
      `id` integer primary key NOT NULL UNIQUE,
      `price` DECIMAL(10, 2) NOT NULL,
      `start_date` INTEGER NOT NULL,
      `fk_drink` INTEGER NOT NULL,
      `end_date` INTEGER NULL,
      FOREIGN KEY(`fk_drink`) REFERENCES `drink`(`id`)
    );
  '''),

  //TODO: FINISH HERE
  user_order('''
    CREATE TABLE `user_order` (
      `id` integer primary key NOT NULL UNIQUE,
      `request_time` INTEGER NULL,
      `confirmation_time` INTEGER NULL,
      `delivery_time` INTEGER NULL,
      `fk_user` INTEGER NOT NULL,
      `fk_address` INTEGER NOT NULL,
      
      `primary_contact_phone` TEXT NULL,
      `primary_contact_name` TEXT NULL,
      `primary_contact_observations` TEXT NULL,
      
      FOREIGN KEY(`fk_user`) REFERENCES `user`(`id`),
      FOREIGN KEY(`fk_address`) REFERENCES `address`(`id`)
    );
  '''),

  order_drink('''
    CREATE TABLE `order_drink` (
      `fk_user_order` INTEGER NOT NULL,
      `fk_drink_price` INTEGER NOT NULL,
      `price` DECIMAL(10, 2) NOT NULL,
      FOREIGN KEY(`fk_user_order`) REFERENCES `user_order`(`id`),
      FOREIGN KEY(`fk_drink_price`) REFERENCES `drink_price`(`id`)
    );
  '''),

  order_pizza('''
    CREATE TABLE 'order_pizza' (
      `id` integer primary key NOT NULL UNIQUE,
      `fk_user_order` INTEGER NOT NULL,
      `additional_requests` TEXT NULL,
      `price` DECIMAL(10, 2) NOT NULL,
      FOREIGN KEY(`fk_user_order`) REFERENCES "user_order"(`id`)
    );
  '''),

  pizza_flavor('''
    CREATE TABLE "pizza_flavor" (
      `id` integer primary key NOT NULL UNIQUE,
      `name` TEXT NOT NULL,
      `description` TEXT NULL,
      `image_url` TEXT NULL
    );
  '''),
  pizza_border('''
    CREATE TABLE "pizza_border" (
      `id` integer primary key NOT NULL UNIQUE,
      `name` TEXT NOT NULL,
      `description` TEXT NULL,
      `image_url` TEXT NULL
    );
  '''),

  pizza_flavor_price('''
    CREATE TABLE `pizza_flavor_price` (
      `id` integer primary key NOT NULL UNIQUE,
      `price_small` DECIMAL(10, 2) NOT NULL,
      `price_medium` DECIMAL(10, 2) NOT NULL,
      `price_large` DECIMAL(10, 2) NOT NULL,
      `start_date` INTEGER NOT NULL,
      `end_date` INTEGER NULL,
      `fk_pizza_flavor` INTEGER NOT NULL,
      FOREIGN KEY(`fk_pizza_flavor`) REFERENCES `pizza_flavor`(`id`)
    ); 
  '''),

  // BORDER WOULD BE BETTER AS A TABLE
  pizza_flavor_percentage('''
    CREATE TABLE 'pizza_flavor_percentage' (
      'percentage' INTEGER NOT NULL,
      'fk_pizza_flavor_price' INTEGER NOT NULL,
      'fk_pizza_border' INTEGER NOT NULL,
      'fk_order_pizza' INTEGER NOT NULL,
      
      FOREIGN KEY('fk_pizza_flavor_price') REFERENCES "pizza_flavor_price"('id'),
      FOREIGN KEY('fk_pizza_border') REFERENCES "pizza_border"('id'),
      FOREIGN KEY('fk_order_pizza') REFERENCES "order_pizza"('id')
    );
  ''');


  final String createScript;
  const SqlTable(this.createScript);
}


Future<void> createTables(Database db) async {
  for (var table in SqlTable.values) {
    await db.execute(table.createScript);
    debugPrint("Created Table: ${table.name}");
  }
}



Future<void> storeBaseLanguages(Database db) async {
  debugPrint('Initializing new data');

  // LOGIN NOT USED ANYMORE, BUT THIS IS USED TO FULFILL FKEY REQUIREMENTS
  await db.execute('''
        INSERT INTO language (lang) 
        VALUES ('pt-BR'); -- linked to login
    ''');
}

// Example data
Future<void> initTestData(Database db) async {
  debugPrint('Initializing new data');

}
