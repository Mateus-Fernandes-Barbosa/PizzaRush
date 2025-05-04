// database_helper.dart
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

/* Some systems may not support multiple sql commands
 * As such each execute can only take in one command at a time
 */

enum SqlTable {
  // Defined by admins. An array is used to store the indexes on startup
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

  address('''
    CREATE TABLE `address` (
      `id` integer primary key NOT NULL UNIQUE,
      `line_1` TEXT NOT NULL,
      `line_2` TEXT NOT NULL,
      `neighborhood` TEXT NOT NULL,
      `city` TEXT NOT NULL,
      `postal_code` TEXT NOT NULL,
      `state` TEXT NOT NULL,
      `country` TEXT NOT NULL,
      `fk_user` INTEGER NOT NULL,
      FOREIGN KEY(`fk_user`) REFERENCES `user`(`id`)
    );
  '''),

  drink('''
    CREATE TABLE `drink` (
      `id` integer primary key NOT NULL UNIQUE,
      `name` TEXT NOT NULL UNIQUE,
      `brand` TEXT NOT NULL,
      `description` TEXT NULL,
      `fk_name_lang` INTEGER NOT NULL,
      FOREIGN KEY(`fk_name_lang`) REFERENCES `language`(`id`)
    );
  '''),

  drink_price('''
    CREATE TABLE `drink_price` (
      `id` integer primary key NOT NULL UNIQUE,
      `price` INTEGER NOT NULL,
      `start_date` INTEGER NOT NULL,
      `fk_drink` INTEGER NOT NULL,
      `end_date` INTEGER NULL,
      FOREIGN KEY(`fk_drink`) REFERENCES `drink`(`id`)
    );
  '''),

  user_order('''
    CREATE TABLE `user_order` (
      `id` integer primary key NOT NULL UNIQUE,
      `request_time` REAL NULL,
      `confirmation_time` REAL NULL,
      `delivery_time` REAL NULL,
      `fk_user` INTEGER NOT NULL,
      FOREIGN KEY(`fk_user`) REFERENCES `user`(`id`)
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
      `fk_name_lang` INTEGER NOT NULL,
      FOREIGN KEY(`fk_name_lang`) REFERENCES `language`(`id`)
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

  pizza_flavor_percentage('''
    CREATE TABLE 'pizza_flavor_percentage' (
      'percentage' INTEGER NOT NULL,
      'fk_pizza_flavor_price' INTEGER NOT NULL,
      'fk_order_pizza' INTEGER NOT NULL,
      FOREIGN KEY('fk_pizza_flavor_price') REFERENCES "pizza_flavor_price"('id'),
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
