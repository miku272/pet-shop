import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../app_styles.dart';

import '../services/database_service.dart';

import '../widgets/custom_app_drawer.dart';
import '../widgets/drawer_icon_button.dart';
import '../widgets/main_loading.dart';
import '../widgets/my_snackbar.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomAppDrawer(),
      appBar: AppBar(
        leading: const DrawerIconButton(),
        leadingWidth: 100,
        title: Text(
          'Your Orders',
          style: sourceSansProBold.copyWith(
            fontSize: 23,
            color: grey,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: FutureBuilder(
            future: DatabaseService().getUserOrders(
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
                    'You Don\'t have any orders yet...',
                    style: sourceSansProSemiBold.copyWith(
                      fontSize: 20,
                      color: grey,
                      letterSpacing: 1,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  String orderUid = snapshot.data!.docs[index]['uid'];
                  String orderDate = snapshot.data!.docs[index]['orderDate'];
                  int quantity = snapshot.data!.docs[index]['quantity'];
                  bool isOrderDelievered =
                      snapshot.data!.docs[index]['isOrderDelivered'];
                  bool isOrderCancelled =
                      snapshot.data!.docs[index]['isOrderCancelled'];

                  return FutureBuilder(
                    future: DatabaseService().getProductDataUsingUid(
                      snapshot.data!.docs[index]['productId'],
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: boxShadowColor,
                          ),
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
                            ],
                          ),
                        );
                      }

                      Map productData = snapshot.data!.data() as Map;

                      double productPrice = productData['price'] -
                          (productData['price'] *
                              (productData['discount'] / 100));

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Card(
                          elevation: 1,
                          color: lighterOrange,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Image.network(
                                productData['imageList'][0],
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              productData['productName'],
                              maxLines: 2,
                              style: sourceSansProSemiBold.copyWith(
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Ordered on : $orderDate',
                                ),
                                Text(
                                  'Total Price: ${productPrice.toStringAsFixed(2)} X $quantity',
                                ),
                                !isOrderCancelled
                                    ? Text(
                                        isOrderDelievered
                                            ? 'Status: Delivered'
                                            : 'Status: In transit',
                                        style: sourceSansProBold.copyWith(
                                          color: isOrderDelievered
                                              ? Colors.greenAccent
                                              : null,
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            trailing: isOrderCancelled
                                ? Text(
                                    'Cancelled',
                                    style: sourceSansProSemiBold.copyWith(
                                      color: red,
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: isOrderDelievered
                                        ? null
                                        : () async {
                                            showAnimatedDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              animationType:
                                                  DialogTransitionType
                                                      .slideFromBottom,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              builder: (context) => AlertDialog(
                                                elevation: 5,
                                                alignment:
                                                    Alignment.bottomCenter,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                title: const Text('Cancel?'),
                                                content: Text(
                                                  'Are you sure you want to cancel this order?',
                                                  style: sourceSansProRegular
                                                      .copyWith(
                                                    color: grey,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () async {
                                                      await DatabaseService()
                                                          .cancelOrder(
                                                        orderUid,
                                                      );

                                                      if (mounted) {
                                                        MySnackbar.showSnackbar(
                                                          context,
                                                          red,
                                                          'Order cancelled',
                                                        );

                                                        Navigator.of(context)
                                                            .pop();
                                                      }

                                                      setState(() {});
                                                    },
                                                    child: Text(
                                                      'Yes',
                                                      style:
                                                          sourceSansProSemiBold
                                                              .copyWith(
                                                        color: orange,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      'No',
                                                      style:
                                                          sourceSansProSemiBold
                                                              .copyWith(
                                                        color: orange,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                    child: Text(
                                      'Cancel',
                                      style: sourceSansProRegular,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
