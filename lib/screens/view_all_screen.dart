import 'package:flutter/material.dart';

import '../app_styles.dart';

import '../widgets/custom_app_drawer.dart';
import '../widgets/drawer_icon_button.dart';
import '../widgets/main_loading.dart';

import '../services/database_service.dart';

class ViewAllScreen extends StatefulWidget {
  static const routeName = '/view-all-screen';

  const ViewAllScreen({super.key});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  @override
  Widget build(BuildContext context) {
    final Map? modalArgs =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;

    String filter = 'view all';

    void handleClick(int item) {
      switch (item) {
        case 0:
          setState(() {
            filter = 'view all';
          });
          break;

        case 1:
          setState(() {
            filter = 'dog';
          });
          break;

        case 2:
          setState(() {
            filter = 'cat';
          });
          break;

        default:
          setState(() {
            filter = 'view all';
          });
      }
    }

    return Scaffold(
      drawer: const CustomAppDrawer(),
      appBar: AppBar(
        leading: const DrawerIconButton(),
        leadingWidth: 80,
        centerTitle: true,
        title: Text(
          'Products',
          style: sourceSansProBold.copyWith(
            color: grey,
            fontSize: 23,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) => handleClick(value),
            itemBuilder: (context) => [
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
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: FutureBuilder(
            future: DatabaseService().getAllProducts(),
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

              return GridView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  if (filter != 'view all') {
                    if (snapshot.data!.docs[index]['category'] == filter) {
                      return Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    }
                  }

                  return Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: red,
                      borderRadius: BorderRadius.circular(12),
                    ),
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
