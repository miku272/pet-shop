import 'package:flutter/material.dart';

import 'package:pet_shop/app_styles.dart';

import '../widgets/custom_app_drawer.dart';
import '../widgets/drawer_icon_button.dart';
import '../widgets/cart_list_container.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var counter = 1;

  void increaseCounter() {
    setState(() {
      counter++;
    });
  }

  void decreaseCounter() {
    if (counter == 1) {
      return;
    }

    setState(() {
      counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomAppDrawer(),
      appBar: AppBar(
        leadingWidth: 80,
        leading: const DrawerIconButton(),
        centerTitle: true,
        title: Text(
          'Your Cart',
          style: sourceSansProBold.copyWith(
            fontSize: 23,
            color: grey,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              const CartListContainer(),
              Divider(color: boxShadowColor.withOpacity(0.5)),
              const CartListContainer(),
              Divider(color: boxShadowColor.withOpacity(0.5)),
              const CartListContainer(),
            ],
          ),
        ),
      ),
    );
  }
}
