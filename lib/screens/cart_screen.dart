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
        elevation: 0,
        shadowColor: white,
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
              const SizedBox(height: 40),
              SizedBox(
                height: 300,
                width: double.infinity,
                child: ListView(
                  children: const <Widget>[
                    CartListContainer(),
                    CartListContainer(),
                    CartListContainer(),
                    CartListContainer(),
                    CartListContainer(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Divider(color: boxShadowColor.withOpacity(0.5)),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total:',
                    style: sourceSansProRegular.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '80',
                    style: sourceSansProRegular.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Delivery Charges:',
                    style: sourceSansProRegular.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '20',
                    style: sourceSansProRegular.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Grand Total:',
                    style: sourceSansProSemiBold.copyWith(
                      fontSize: 30,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    '100',
                    style: sourceSansProSemiBold.copyWith(
                      fontSize: 40,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: FloatingActionButton.extended(
          onPressed: () {},
          extendedPadding: const EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: grey,
          label: Text(
            'Proceed to checkout',
            style: sourceSansProSemiBold.copyWith(
              fontSize: 25,
              color: boxShadowColor,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
