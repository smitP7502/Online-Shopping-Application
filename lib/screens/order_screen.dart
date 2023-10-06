// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main_drawer.dart';

import '../widgets/order_item.dart';

import '../providers/order.dart' show Order;

// class OrderScreen extends StatefulWidget {
class OrderScreen extends StatefulWidget {
  static const routeName = '/order';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future _obtainFuture;

  Future _obtainedFuture() {
    return Provider.of<Order>(context, listen: false).fetchAndsetOrders();
  }

  @override
  void initState() {
    _obtainFuture = _obtainedFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('order build run');
    // final orderData = Provider.of<Order>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: const MainDrawer(),
        body: FutureBuilder(
          future: _obtainFuture,
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapShot.error != null) {
                print(snapShot.error);
                return const Center(child: Text('No Order place yet!'));
              } else {
                return Consumer<Order>(
                  builder: (ctx, orderData, child) {
                    return ListView.builder(
                      itemBuilder: (_, index) {
                        return OrderItem(orderData.orders[index]);
                      },
                      itemCount: orderData.orders.length,
                    );
                  },
                );
              }
            }
          },
        ));
  }
}
