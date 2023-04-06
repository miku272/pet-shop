import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../app_styles.dart';

import '../widgets/custom_app_drawer.dart';
import '../widgets/drawer_icon_button.dart';
import '../widgets/main_loading.dart';
import '../widgets/my_snackbar.dart';

import '../services/database_service.dart';

import './product_detail_screen.dart';
import './cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  static const routeName = '/product-list-screen';

  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  int filterValue = 0;

  Future<QuerySnapshot> displayData(int value) {
    if (value == 1) {
      return DatabaseService().getDogProducts();
    }

    if (value == 2) {
      return DatabaseService().getCatProducts();
    }

    return DatabaseService().getAllProducts();
  }

  String filterMessage() {
    if (filterValue == 1) {
      return 'Dog care products';
    }

    if (filterValue == 2) {
      return 'Cat care products';
    }

    return 'Viewing all products ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomAppDrawer(),
      appBar: AppBar(
        leading: const DrawerIconButton(),
        leadingWidth: 80,
        title: Text(
          'Products',
          style: sourceSansProBold.copyWith(
            color: grey,
            fontSize: 23,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(onSelected: (value) {
            setState(() {
              filterValue = value;
            });
          }, itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 0,
                child: Text(
                  'View All',
                  style: sourceSansProSemiBold.copyWith(
                    color: grey,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  'Dogs',
                  style: sourceSansProSemiBold.copyWith(
                    color: grey,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(
                  'Cats',
                  style: sourceSansProSemiBold.copyWith(
                    color: grey,
                  ),
                ),
              ),
            ];
          }),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: FutureBuilder(
            future: displayData(filterValue),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: MainLoading(),
                );
              }

              if (snapshot.data == null) {
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

              return Column(
                children: [
                  Text(
                    filterMessage(),
                    style: sourceSansProRegular.copyWith(
                      color: grey,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: double.infinity,
                    child: GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 250,
                      ),
                      itemBuilder: (context, index) {
                        int originalPrice = snapshot.data!.docs[index]['price'];

                        var discountPrice = originalPrice -
                            (originalPrice *
                                (snapshot.data!.docs[index]['discount'] / 100));

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              ProductDetailScreen.routeName,
                              arguments: snapshot.data!.docs[index]['uid'],
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 100,
                                  child: Image.network(
                                    snapshot.data!.docs[index]['imageList'][0],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  '${snapshot.data!.docs[index]['productName']}\n',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: sourceSansProRegular.copyWith(
                                    color: grey,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Price: ',
                                      style: sourceSansProSemiBold,
                                    ),
                                    Text(
                                      originalPrice.toString(),
                                      style: sourceSansProSemiBold.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      discountPrice.toStringAsFixed(2),
                                      style: sourceSansProSemiBold,
                                    ),
                                  ],
                                ),
                                snapshot.data!.docs[index]['stock'] < 1
                                    ? Text(
                                        'Item currently out of stock',
                                        style: sourceSansProRegular.copyWith(
                                          color: red,
                                        ),
                                      )
                                    : const SizedBox(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () async {
                                        if (FirebaseAuth.instance.currentUser ==
                                            null) {
                                          MySnackbar.showSnackbar(
                                            context,
                                            black,
                                            'Please login first',
                                          );

                                          return;
                                        }

                                        final result = await DatabaseService()
                                            .addItemToWishlist(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          snapshot.data!.docs[index]['uid'],
                                        );

                                        if (result) {
                                          if (mounted) {
                                            MySnackbar.showSnackbar(
                                              context,
                                              black,
                                              'Item added to wishlist',
                                            );
                                          }
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.favorite,
                                        color: red,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: snapshot.data!.docs[index]
                                                  ['stock'] <
                                              1
                                          ? null
                                          : () async {
                                              if (FirebaseAuth
                                                      .instance.currentUser ==
                                                  null) {
                                                MySnackbar.showSnackbar(
                                                  context,
                                                  black,
                                                  'Please login first',
                                                );

                                                return;
                                              }

                                              final response =
                                                  await DatabaseService()
                                                      .addToCart(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                snapshot.data!.docs[index]
                                                    ['uid'],
                                              );

                                              if (mounted) {
                                                MySnackbar.showSnackbar(
                                                    context, black, response);
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'Add to Cart',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: orange,
        onPressed: () {
          if (FirebaseAuth.instance.currentUser == null) {
            MySnackbar.showSnackbar(context, black, 'Please login first');

            return;
          }

          Navigator.of(context).pushNamed(CartScreen.routeName);
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            FirebaseAuth.instance.currentUser != null
                ? StreamBuilder(
                    stream: DatabaseService().getUserCartData(
                      FirebaseAuth.instance.currentUser!.uid,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      }

                      if (!snapshot.hasData ||
                          snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        return const SizedBox();
                      }

                      return Positioned(
                        bottom: 10,
                        left: 20,
                        child: Text(
                          snapshot.data!.docs.length.toString(),
                          style: sourceSansProBold.copyWith(
                            color: grey,
                            fontSize: 20,
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox(),
            const Icon(Icons.shopping_bag_outlined),
          ],
        ),
      ),
    );
  }
}
