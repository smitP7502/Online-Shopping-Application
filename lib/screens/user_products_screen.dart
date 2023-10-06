import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main_drawer.dart';
import '../screens/edit_product_screen.dart';

import '../widgets/user_product_item.dart';

import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    print('build methoed of userp product');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.namedRoute);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refresh(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, child) => Padding(
                        padding: const EdgeInsets.all(10),
                        child: productsData.items.isEmpty
                            ? const Center(
                                child: Text('No Products yet added'),
                              )
                            : ListView.builder(
                                itemBuilder: (_, index) => Column(
                                  children: [
                                    UserProductItem(
                                      productsData.items[index].id,
                                      productsData.items[index].title,
                                      productsData.items[index].imageUrl,
                                    ),
                                    const Divider(),
                                  ],
                                ),
                                itemCount: productsData.items.length,
                              ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
