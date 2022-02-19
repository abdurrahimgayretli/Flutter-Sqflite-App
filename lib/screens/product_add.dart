import 'package:flutter/material.dart';
import 'package:flutter_sqflite/data/dbHelper.dart';
import 'package:flutter_sqflite/models/product.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProductAddState();
  }
}

class ProductAddState extends State {
  var dbHelper = DbHelper();
  var txtName = TextEditingController();
  var txtDescription = TextEditingController();
  var txtUnitPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Urun ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            buildNameFiled(),
            buildDescriptionField(),
            buildUnitPriceField(),
            buildSaveButton(),
          ],
        ),
      ),
    );
  }

  buildNameFiled() {
    return TextField(
      decoration: const InputDecoration(labelText: 'Urun adi'),
      controller: txtName,
    );
  }

  buildDescriptionField() {
    return TextField(
      decoration: const InputDecoration(labelText: 'Urun aciklamasi'),
      controller: txtDescription,
    );
  }

  buildUnitPriceField() {
    return TextField(
      decoration: const InputDecoration(labelText: 'Birim fiyati'),
      controller: txtUnitPrice,
    );
  }

  buildSaveButton() {
    return TextButton(
      child: const Text('Ekle'),
      onPressed: () {
        addProduct();
      },
    );
  }

  void addProduct() async {
    var result = await dbHelper.insert(Product(
        name: txtName.text,
        description: txtDescription.text,
        unitPrice: double.tryParse(txtUnitPrice.text)));
    Navigator.pop(context, true);
  }
}
