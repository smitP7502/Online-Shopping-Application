import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;

  OrderItem(this.orderItem);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expaned = false;

  Widget _buildDivider(BuildContext ctx) {
    return Divider(
      // color: Theme.of(ctx).colorScheme.primary,
      height: 0,
      thickness: _expaned ? 2 : 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expaned = !_expaned;
        });
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text("\$${widget.orderItem.amount.toStringAsFixed(2)}"),
              subtitle: Text(
                "Order Time : ${DateFormat('dd/MM/yyyy-hh:mm').format(widget.orderItem.date)}",
              ),
              trailing: Icon(
                _expaned ? Icons.expand_less : Icons.expand_more,
                color: Colors.black,
              ),
            ),
            _buildDivider(context),
            if (_expaned)
              Column(
                children: [
                  SizedBox(
                    height:
                        min(widget.orderItem.cartList.length * 20.0 + 120, 150),
                    child: ListView.builder(
                        itemCount: widget.orderItem.cartList.length,
                        itemBuilder: (context, index) {
                          final item = widget.orderItem.cartList[index];
                          return Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${(index + 1)}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                Text("\$${item.quantity} x ${item.price}"),
                              ],
                            ),
                          );
                        }
                        // children: widget.orderItem.cartList
                        //     .map(
                        //       (item) => ,
                        //     )
                        //     .toList(),
                        ),
                  ),
                  _buildDivider(context),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
