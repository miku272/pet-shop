import 'package:flutter/material.dart';
import 'package:pet_shop/app_styles.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text(
            'Cart Screen',
            style: sourceSansProBold.copyWith(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
