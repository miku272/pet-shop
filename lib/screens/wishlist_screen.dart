import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_styles.dart';

import '../widgets/custom_app_drawer.dart';
import '../widgets/drawer_icon_button.dart';
import '../widgets/main_loading.dart';
import '../widgets/wishlist_container.dart';

import '../services/database_service.dart';

class WishlistScreen extends StatefulWidget {
  static const routeName = '/wishlist-screen';

  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomAppDrawer(),
      appBar: AppBar(
        leading: const DrawerIconButton(),
        leadingWidth: 80,
        title: Text(
          'Your Wishlist',
          style: sourceSansProBold.copyWith(
            color: grey,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: FutureBuilder(
            future: DatabaseService().getUserDataUsingUid(
              FirebaseAuth.instance.currentUser!.uid,
            ),
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

              if (snapshot.data.docs[0].data()['wishlist'].length < 1) {
                return Center(
                  child: Text(
                    'Nothing in wishlist for now...',
                    textAlign: TextAlign.center,
                    style: sourceSansProSemiBold.copyWith(
                      color: grey,
                      fontSize: 18,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data.docs[0].data()['wishlist'].length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: DatabaseService().getProductDataUsingUid(
                      snapshot.data.docs[0].data()['wishlist'][index],
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: boxShadowColor,
                          ),
                        );
                      }

                      if (snapshot.data == null) {
                        return Center(
                          child: Text(
                            'The product has either been removed or not available',
                            style: sourceSansProBold.copyWith(
                              color: grey,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }

                      final productData = snapshot.data!.data() as Map;
                      final price = productData['price'] -
                          (productData['price'] *
                              (productData['discount'] / 100));

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: WishlistContainer(
                          imageUrl: productData['imageList'][0],
                          productName: productData['productName'],
                          productPrice: price.toString(),
                          onRemove: () async {
                            final result =
                                await DatabaseService().removeItemFromWishlist(
                              FirebaseAuth.instance.currentUser!.uid,
                              productData['uid'],
                            );

                            if (result) {
                              setState(() {});
                            }
                          },
                          onAddToCart: () {},
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: orange,
        onPressed: () {},
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}
