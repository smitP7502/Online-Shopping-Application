import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  late List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String? authToken;
  final String? userId;

  Products(this.authToken, this.userId, this._items);

  // var _showFavoriteOnly = false;

  // List of products
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  Product findById(String productId) {
    return _items.firstWhere((prod) => prod.id == productId);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    _items = [];
    print("Value of Filter String is $filterByUser");
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    // print(filterString);
    var url1 =
        'https://my-shop-1af19-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    print(url1);

    try {
      final response = await http.get(Uri.parse(url1));
      final extrectedData = json.decode(response.body);
      // print(extrectedData);
      final List<Product> lodedProducts = [];

      var url =
          "https://my-shop-1af19-default-rtdb.firebaseio.com/isFavorite/$userId.json?auth=$authToken";

      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(favoriteResponse.body);

      if (extrectedData == null) {
        return;
      }

      (extrectedData as Map<String, dynamic>).forEach((prodId, prodData) {
        lodedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
        _items = lodedProducts;
        print(_items);
        notifyListeners();
      });
    } catch (error) {
      print('error Occured');
      // print(error.toString());
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    // Future<void> addProduct(Product product)  {
    final url =
        'https://my-shop-1af19-default-rtdb.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          },
        ),
      );

      final id = json.decode(response.body)['name'];
      final newProduct = Product(
        id: id,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }

    // return http
    //     .post(
    //   Uri.parse(url),
    //   body: json.encode(
    //     {
    //       'title': product.title,
    //       'description': product.description,
    //       'price': product.price,
    //       'imageUrl': product.imageUrl,
    //       'isFavorite': product.isFavorite,
    //     },
    //   ),
    // )
    //     .then(
    //   (response) {
    //     final id = json.decode(response.body)['name'];
    //     final newProduct = Product(
    //       id: id,
    //       title: product.title,
    //       description: product.description,
    //       price: product.price,
    //       imageUrl: product.imageUrl,
    //     );
    //     _items.add(newProduct);
    //     notifyListeners();
    //   },
    // ).catchError(
    //   (error) {
    //     print(error.toString());
    //     throw error;
    //   },
    // );
  }

  Future<void> updateProduct(String id, Product product) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    final url =
        'https://my-shop-1af19-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    if (productIndex >= 0) {
      try {
        await http.patch(Uri.parse(url),
            body: json.encode({
              'title': product.title,
              'price': product.price,
              'description': product.description,
              'imageUrl': product.imageUrl,
            }));
        _items[productIndex] = product;
      } catch (error) {
        rethrow;
      }
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://my-shop-1af19-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete the product.');
    }

    existingProduct = null;
  }
}
