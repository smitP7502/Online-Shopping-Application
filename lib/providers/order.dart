import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> cartList;
  final DateTime date;

  OrderItem({
    required this.id,
    required this.amount,
    required this.cartList,
    required this.date,
  });
}

class Order with ChangeNotifier {
  final String? authToken;
  final String? userId;

  Order(this.authToken, this.userId, this._orders);

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndsetOrders() async {
    final url =
        "https://my-shop-1af19-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";

    final response = await http.get(Uri.parse(url));
    final List<OrderItem> lodedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    try {
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        lodedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            cartList: (orderData['cartList'] as List<dynamic>).map((item) {
              {
                return CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity'],
                );
              }
            }).toList(),
            date: DateTime.parse(
              orderData['date'],
            ),
          ),
        );
      });
      _orders = lodedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        "https://my-shop-1af19-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    final timeStemp = DateTime.now();

    // try {
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': total,
        'date': timeStemp.toIso8601String(),
        'cartList': cartProducts
            .map(
              (cp) => {
                'id': cp.id,
                'price': cp.price,
                'title': cp.title,
                'quantity': cp.quantity,
              },
            )
            .toList(),
      }),
    );
    if (total != 0) {
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          cartList: cartProducts,
          date: DateTime.now(),
        ),
      );
      notifyListeners();
      // print('done');
    }
    // } catch (error) {
    //   print(error);
    //   rethrow;
    // }
  }
}
