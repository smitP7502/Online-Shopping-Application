import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  // final String title;

  // ProductDetailScreen(this.title);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final lodedProduct = Provider.of<Products>(
      context,
      listen:
          false, // if you don't have to rebuild the build methode if the data change then use listen: false by default is true.
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(lodedProduct.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Image.network(
              lodedProduct.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '\$${lodedProduct.price}',
            style: const TextStyle(
              fontSize: 23,
              color: Colors.grey,
            ),
          ),
          Text(
            lodedProduct.description,
            style: const TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }
}
