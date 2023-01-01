import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_shop/screens/home_screen.dart';

import '../app_styles.dart';
import '../widgets/custom_app_drawer.dart';

import 'cart_screen.dart';
import './profile_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  const BottomNavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: white,
        showUnselectedLabels: true,
        fixedColor: black,
        showSelectedLabels: true,
        unselectedItemColor: grey,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.shifting,
        onTap: _onItemTap,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? SvgPicture.asset('assets/home_selected.svg')
                : SvgPicture.asset('assets/home_unselected.svg'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? SvgPicture.asset('assets/cart_selected.svg')
                : SvgPicture.asset('assets/cart_unselected.svg'),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? SvgPicture.asset('assets/profile_selected.svg')
                : SvgPicture.asset('assets/profile_unselected.svg'),
            label: 'Profile',
          ),
        ],
      ),
      body: _screens[_selectedIndex],
    );
  }
}
