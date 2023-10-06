import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';

import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  const ProductsGrid(this.showFavs, {super.key});

  @override
  Widget build(BuildContext context) {
    // in <> this bracket you have to provide which data you have to use for this widget
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    // print(showFavs);
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        // if you are use provider with grid and list then it is good to use .value methode insted of builder methode and it does not create new instace but reuse the instace so which is more fiseible in .value
        return ChangeNotifierProvider.value(
          // create: (ctx) => products[index],
          value: products[index],
          child: ProductItem(
              // id: product.id,
              // title: product.title,
              // imageUrl: product.imageUrl,
              ),
        );
      },
    );
  }
}
