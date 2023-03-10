import 'package:flutter/material.dart';

import 'package:pet_shop/app_styles.dart';

import '../widgets/custom_app_drawer.dart';
import '../widgets/drawer_icon_button.dart';

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
              SizedBox(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.red[200],
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1597843786411-a7fa8ad44a95?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
                          ),
                          fit: BoxFit.cover,
                          repeat: ImageRepeat.noRepeat,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Food',
                          style: sourceSansProSemiBold.copyWith(
                            color: grey,
                            fontSize: 20,
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: increaseCounter,
                              icon: const Icon(
                                Icons.add,
                                color: boxShadowColor,
                              ),
                            ),
                            Text(
                              counter.toString(),
                              style: sourceSansProSemiBold.copyWith(
                                fontSize: 18,
                                color: grey,
                              ),
                            ),
                            IconButton(
                              onPressed: decreaseCounter,
                              icon: const Icon(
                                Icons.horizontal_rule,
                                color: red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
