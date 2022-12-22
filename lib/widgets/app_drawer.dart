import 'package:flutter/material.dart';
import 'package:pet_shop/app_styles.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            color: lightOrange,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(
                      top: 30,
                      bottom: 10,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://i.pinimg.com/736x/8d/86/6a/8d866a5494c2374372fe6ad82c32cdf2.jpg',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const Text(
                    'SUII JGHSGV',
                    style: TextStyle(
                      fontSize: 22,
                      color: lightGrey,
                    ),
                  ),
                  const Text(
                    'sui@gmail.com',
                    style: TextStyle(
                      fontSize: 22,
                      color: lightGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Profile',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: null,
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: null,
          ),
          const ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Log Out',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: null,
          ),
        ],
      ),
    );
  }
}
