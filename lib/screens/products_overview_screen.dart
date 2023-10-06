// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../main_drawer.dart';

import '../widgets/products_grid.dart';
// import '../widgets/badge.dart';
import '../widgets/cart_badge.dart';

import '../providers/cart.dart';
import '../providers/products.dart';

enum FilterOption {
  favorite,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/product-overview-screen';

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  var _noData = false;

  // @override
  // void initState() {

  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        Provider.of<Products>(context).fetchAndSetProducts().then(
              (_) => setState(() {
                _isLoading = false;
              }),
            );
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
            ),
            onSelected: (selecteFilterValue) {
              if (selecteFilterValue == FilterOption.favorite) {
                setState(() {
                  _showOnlyFavorites = true;
                });
              } else {
                setState(() {
                  _showOnlyFavorites = false;
                });
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: FilterOption.favorite,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOption.all,
                child: Text('Show All'),
              ),
            ],
          ),
          // Consumer<Cart>(
          //   builder: (_, cart, ch) =>
          //       BadgeIcon(value: cart.itemCount.toString(), child: ch!),
          //   child: IconButton(
          //     icon: const Icon(Icons.shopping_cart),
          //     onPressed: () {},
          //   ),
          // ),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                CartBadge(value: cart.itemCount, child: ch!),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: _isLoading
          ? _noData
              ? const Center(
                  child: Text('No Products available'),
                )
              : const Center(child: CircularProgressIndicator())
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
