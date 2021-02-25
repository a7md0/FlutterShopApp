import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsProvider.items.length,
          itemBuilder: (_, idx) => UserProductItem(productsProvider.items[idx]),
        ),
      ),
    );
  }
}
