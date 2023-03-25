import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../app_styles.dart';

import '../widgets/custom_app_drawer.dart';
import '../widgets/drawer_icon_button.dart';
import '../widgets/main_loading.dart';
import '../widgets/my_snackbar.dart';
import '../widgets/cart_list_container.dart';

import '../services/database_service.dart';

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
                child: FutureBuilder(
                  future: DatabaseService().getUserStaticCartData(
                    FirebaseAuth.instance.currentUser!.uid,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: MainLoading(),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Something Went Wrong...',
                              style: sourceSansProRegular.copyWith(
                                color: grey,
                                fontSize: 18,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {});
                              },
                              child: Text(
                                'Refresh',
                                style: sourceSansProSemiBold.copyWith(
                                  color: boxShadowColor,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'Nothing in your cart right now...',
                          style: sourceSansProBold.copyWith(
                            color: grey,
                            fontSize: 20,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return CartListContainer(
                          cartId: snapshot.data!.docs[index].id,
                          productId: snapshot.data!.docs[index]['productId'],
                          quantity: snapshot.data!.docs[index]['quantity'],
                          onIncrease: () async {
                            int qty =
                                snapshot.data!.docs[index]['quantity'] + 1;

                            final result = await DatabaseService()
                                .updateCartProductQuantity(
                              FirebaseAuth.instance.currentUser!.uid,
                              snapshot.data!.docs[index].id,
                              qty,
                            );

                            if (result) {
                              setState(() {});
                            } else {
                              if (mounted) {
                                MySnackbar.showSnackbar(
                                  context,
                                  black,
                                  'quantity can\'t be less than 1 or more than 5',
                                );
                              }
                            }
                          },
                          onDecrease: () async {
                            int qty =
                                snapshot.data!.docs[index]['quantity'] - 1;

                            final result = await DatabaseService()
                                .updateCartProductQuantity(
                              FirebaseAuth.instance.currentUser!.uid,
                              snapshot.data!.docs[index].id,
                              qty,
                            );

                            if (result) {
                              setState(() {});
                            } else {
                              if (mounted) {
                                MySnackbar.showSnackbar(
                                  context,
                                  black,
                                  'quantity can\'t be less than 1 or more than 5',
                                );
                              }
                            }
                          },
                          onRemove: () async {
                            showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              animationType:
                                  DialogTransitionType.slideFromBottom,
                              duration: const Duration(milliseconds: 300),
                              builder: (context) => AlertDialog(
                                elevation: 5,
                                alignment: Alignment.bottomCenter,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text('Remove?'),
                                content: Text(
                                  'Are you sure you want to remove this item from the cart?',
                                  style: sourceSansProRegular.copyWith(
                                    color: grey,
                                    fontSize: 18,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      await DatabaseService().removeFromCart(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        snapshot.data!.docs[index].id,
                                      );

                                      if (mounted) {
                                        MySnackbar.showSnackbar(
                                          context,
                                          black,
                                          'Item removed from the cart',
                                        );

                                        Navigator.of(context).pop();
                                      }

                                      setState(() {});
                                    },
                                    child: Text(
                                      'Yes',
                                      style: sourceSansProSemiBold.copyWith(
                                        color: orange,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'No',
                                      style: sourceSansProSemiBold.copyWith(
                                        color: orange,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              Divider(color: boxShadowColor.withOpacity(0.5)),
              const SizedBox(height: 30),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     Text(
              //       'Total:',
              //       style: sourceSansProRegular.copyWith(
              //         fontSize: 18,
              //       ),
              //     ),
              //     Text(
              //       '80',
              //       style: sourceSansProRegular.copyWith(
              //         fontSize: 18,
              //       ),
              //     ),
              //   ],
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     Text(
              //       'Delivery Charges:',
              //       style: sourceSansProRegular.copyWith(
              //         fontSize: 18,
              //       ),
              //     ),
              //     Text(
              //       '20',
              //       style: sourceSansProRegular.copyWith(
              //         fontSize: 18,
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     Text(
              //       'Grand Total:',
              //       style: sourceSansProSemiBold.copyWith(
              //         fontSize: 30,
              //         letterSpacing: 1,
              //       ),
              //     ),
              //     Text(
              //       '100',
              //       style: sourceSansProSemiBold.copyWith(
              //         fontSize: 40,
              //         letterSpacing: 1,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: FloatingActionButton.extended(
          onPressed: null,
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
