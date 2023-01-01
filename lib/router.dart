import 'package:flutter/material.dart';

import './screens/login_screen.dart';
import './screens/forget_password_screen.dart';
import './screens/registration_screen.dart';
import 'screens/bottom_navigation_bar_screen.dart';
import './screens/home_screen.dart';
import './screens/cart_screen.dart';
import './screens/profile_screen.dart';
import './screens/pet_detail_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const LoginScreen(),
      );

    case ForgetPasswordScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const ForgetPasswordScreen(),
      );

    case RegistrationScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const RegistrationScreen(),
      );

    case BottomNavigationBarScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const BottomNavigationBarScreen(),
      );

    // case HomeScreen.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (context) => const HomeScreen(),
    //   );

    case CartScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const CartScreen(),
      );

    case ProfileScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const ProfileScreen(),
      );

    case PetDetailScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const PetDetailScreen(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
