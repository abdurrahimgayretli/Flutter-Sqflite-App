// ignore_for_file: unnecessary_this, must_call_super

import 'package:flutter/material.dart';
import 'package:flutter_sqflite/data/dbHelper.dart';
import 'package:flutter_sqflite/models/product.dart';
import 'package:flutter_sqflite/screens/product_add.dart';
import 'package:flutter_sqflite/screens/product_detail.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProductListState();
  }
}

class _ProductListState extends State {
  var dbHelper = DbHelper();
  List<Product>? products;
  int productCount = 0;

  @override
  void initState() {
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Urun Listesi'),
      ),
      body: buildProductList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToProductAdd();
        },
        child: const Icon(Icons.add),
        tooltip: 'Yeni Urun Ekle',
      ),
    );
  }

  ListView buildProductList() {
    return ListView.builder(
        itemCount: productCount,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.cyan,
            elevation: 2,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.black12,
                child: Text('P'),
              ),
              title: Text(this.products![position].name.toString()),
              subtitle: Text(this.products![position].description.toString()),
              onTap: () {
                goToDetail(this.products![position]);
              },
            ),
          );
        });
  }

  void goToProductAdd() async {
    bool? result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProductAdd()));
    if (result != null) {
      if (result) {
        getProducts();
      }
    }
  }

  void getProducts() async {
    var productsFuture = dbHelper.getProducts();
    productsFuture.then((data) {
      setState(() {
        this.products = data;
        productCount = data.length;
      });
    });
  }

  void goToDetail(Product product) async {
    bool? result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProductDetail(product)));
    if (result != null) {
      if (result) {
        getProducts();
      }
    }
  }
}
