// ignore_for_file: prefer_conditional_assignment, file_names

import 'dart:async';

import 'package:flutter_sqflite/models/product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database?> initializeDb() async {
    String dbPath = join(await getDatabasesPath(), 'etrade.db');
    var eTrade = openDatabase(dbPath, version: 1, onCreate: createDb);
    return eTrade;
  }

  void createDb(Database db, int version) async {
    await db.execute(
        'Create table products(id integer primary key, name text, description text, unitPrice integer)');
  }

  Future<List<Product>> getProducts() async {
    Database? db = await this.db;
    var result = await db!.query('products');
    return List.generate(result.length, (i) {
      return Product.fromObject(result[i]);
    });
  }

  Future<int> insert(Product product) async {
    Database? db = await this.db;
    var result = await db!.insert('products', product.toMap()!);
    return result;
  }

  Future<int> delete(int id) async {
    Database? db = await this.db;
    var result = await db!.rawDelete('delete from products where id= $id');
    return result;
  }

  Future<int> update(Product product) async {
    Database? db = await this.db;
    var result = await db!.update('products', product.toMap()!,
        where: 'id=?', whereArgs: [product.id]);
    return result;
  }
}
