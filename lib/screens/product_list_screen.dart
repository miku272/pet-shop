import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../app_styles.dart';

import '../widgets/custom_app_drawer.dart';
import '../widgets/drawer_icon_button.dart';
import '../widgets/main_loading.dart';

import '../services/database_service.dart';

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
                        mainAxisExtent: 270,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: red,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Add to Cart',
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: lightOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  minimumSize: const Size.fromHeight(50),
                                ),
                                child: const Text(
                                  'Buy Now',
                                ),
                              ),
                            ],
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
        onPressed: () {},
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}
