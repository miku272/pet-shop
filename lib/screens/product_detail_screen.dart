import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../app_styles.dart';

import '../services/database_service.dart';

import '../widgets/main_loading.dart';
import '../widgets/my_snackbar.dart';

import './cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail-screen';

  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    String productId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: lighterOrange.withOpacity(0.5),
        leadingWidth: 100,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              color: lighterOrange.withOpacity(0.5),
              child: ImageViewer(productId),
            ),
            ProductDetail(productId),
          ],
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

class ImageViewer extends StatefulWidget {
  final String productId;

  const ImageViewer(this.productId, {super.key});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseService().getProductDataUsingUid(widget.productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: boxShadowColor,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }

        Map productData = snapshot.data!.data() as Map;
        List productImageList = productData['imageList'];

        return CarouselSlider.builder(
          itemCount: productImageList.length,
          options: CarouselOptions(
            height: 200,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 10),
          ),
          itemBuilder: (context, itemIndex, pageViewIndex) {
            return Image.network(
              productImageList[itemIndex],
              fit: BoxFit.fill,
            );
          },
        );
      },
    );
  }
}

class ProductDetail extends StatefulWidget {
  final String productId;

  const ProductDetail(this.productId, {super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 1,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 5,
                        width: 35,
                        decoration: BoxDecoration(
                          color: black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder(
                    future: DatabaseService().getProductDataUsingUid(
                      widget.productId,
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

                      Map productData = snapshot.data!.data() as Map;
                      int originalPrice = productData['price'];
                      var discountedPrice = originalPrice -
                          (originalPrice * (productData['discount'] / 100));

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  productData['productName'],
                                  maxLines: 5,
                                  style: sourceSansProBold.copyWith(
                                    fontSize: 25,
                                    overflow: TextOverflow.ellipsis,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
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

                                  final result =
                                      await DatabaseService().addItemToWishlist(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    productData['uid'],
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
                                  size: 30,
                                  color: red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Text(
                                'Price: ',
                                style: sourceSansProSemiBold.copyWith(
                                  fontSize: 18,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                originalPrice.toString(),
                                style: sourceSansProSemiBold.copyWith(
                                  fontSize: 18,
                                  letterSpacing: 0.5,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                discountedPrice.toStringAsFixed(2),
                                style: sourceSansProSemiBold.copyWith(
                                  fontSize: 18,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${productData['discount']}% off!',
                            style: sourceSansProSemiBold.copyWith(
                              fontSize: 25,
                              color: red,
                              letterSpacing: 0.5,
                            ),
                          ),
                          productData['stock'] < 1
                              ? const SizedBox(height: 10)
                              : const SizedBox(),
                          productData['stock'] < 1
                              ? Text(
                                  'Item currently out of stock',
                                  style: sourceSansProRegular.copyWith(
                                    color: red,
                                    fontSize: 18,
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 10),
                          const Divider(),
                          const SizedBox(height: 10),
                          Text(
                            'Description',
                            style: sourceSansProBold.copyWith(
                              color: black,
                              fontSize: 20,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            productData['detail'],
                            style: sourceSansProSemiBold.copyWith(
                              color: grey,
                              fontSize: 18,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: productData['stock'] < 1
                                ? null
                                : () async {
                                    if (FirebaseAuth.instance.currentUser ==
                                        null) {
                                      MySnackbar.showSnackbar(
                                        context,
                                        black,
                                        'Please login first',
                                      );

                                      return;
                                    }

                                    final response =
                                        await DatabaseService().addToCart(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      productData['uid'],
                                    );

                                    if (mounted) {
                                      MySnackbar.showSnackbar(
                                          context, black, response);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: grey,
                              foregroundColor: boxShadowColor,
                            ),
                            child: Text(
                              'Add to cart',
                              style: sourceSansProSemiBold.copyWith(
                                fontSize: 18,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
