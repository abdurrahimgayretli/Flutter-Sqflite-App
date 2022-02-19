// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_sqflite/data/dbHelper.dart';
import 'package:flutter_sqflite/models/product.dart';

class ProductDetail extends StatefulWidget {
  Product product;
  ProductDetail(this.product, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ProductDetailState(product);
  }
}

enum Options { delete, update }

class _ProductDetailState extends State {
  Product product;
  _ProductDetailState(this.product);
  var dbHelper = DbHelper();
  var txtName = TextEditingController();
  var txtDescription = TextEditingController();
  var txtUnitPrice = TextEditingController();

  @override
  void initState() {
    txtName.text = product.name!;
    txtDescription.text = product.description!;
    txtUnitPrice.text = product.unitPrice!.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Urun Detayi : ${product.name}'),
        actions: [
          PopupMenuButton<Options>(
            onSelected: selectProcess,
            itemBuilder: (context) => <PopupMenuEntry<Options>>[
              const PopupMenuItem<Options>(
                value: Options.delete,
                child: Text('Sil'),
              ),
              const PopupMenuItem<Options>(
                value: Options.update,
                child: Text('Guncelle'),
              )
            ],
          ),
        ],
      ),
      body: buildProductDetail(),
    );
  }

  buildProductDetail() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          buildNameFiled(),
          buildDescriptionField(),
          buildUnitPriceField(),
        ],
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

  void selectProcess(Options value) async {
    switch (value) {
      case Options.delete:
        await dbHelper.delete(product.id!);
        Navigator.pop(context, true);
        break;
      case Options.update:
        await dbHelper.update(Product.withId(
            id: product.id,
            name: txtName.text,
            description: txtDescription.text,
            unitPrice: double.tryParse(txtUnitPrice.text)));
        Navigator.pop(context, true);
        break;
      default:
    }
  }
}
