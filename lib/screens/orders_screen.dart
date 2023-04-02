import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_styles.dart';

import '../services/database_service.dart';

import '../widgets/custom_app_drawer.dart';
import '../widgets/drawer_icon_button.dart';
import '../widgets/main_loading.dart';

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

              return Container();
            },
          ),
        ),
      ),
    );
  }
}
