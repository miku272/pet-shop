import 'package:flutter/material.dart';

import './screens/login_screen.dart';
import './screens/forget_password_screen.dart';
import './screens/registration_screen.dart';
import './screens/re_authantication_screen.dart';
import './screens/home_screen.dart';
import './screens/chat_list_screen.dart';
import './screens/chat_screen.dart';
import './screens/cart_screen.dart';
import './screens/profile_screen.dart';
import './screens/edit_profile_screen.dart';
import './screens/update_password_screen.dart';
import './screens/your_post_and_pet_screen.dart';
import './screens/address_screen.dart';
import './screens/address_editor_screen.dart';
import 'screens/pet_editor_screen.dart';
import './screens/pet_detail_screen.dart';
import './screens/product_list_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/wishlist_screen.dart';
import './screens/checkout_screen.dart';
import './screens/orders_screen.dart';

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

    case ReAuthanticationScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const ReAuthanticationScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const HomeScreen(),
      );

    case ChatListScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const ChatListScreen(),
      );

    case ChatScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const ChatScreen(),
      );

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

    case EditProfileScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const EditProfileScreen(),
      );

    case YourPostAndPetScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const YourPostAndPetScreen(),
      );

    case AddressScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const AddressScreen(),
      );

    case AddressEditorScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const AddressEditorScreen(),
      );

    case UpdatePasswordScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const UpdatePasswordScreen(),
      );

    case PetEditorScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const PetEditorScreen(),
      );

    case PetDetailScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const PetDetailScreen(),
      );

    case ProductListScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const ProductListScreen(),
      );

    case ProductDetailScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const ProductDetailScreen(),
      );

    case WishlistScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const WishlistScreen(),
      );

    case CheckoutScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const CheckoutScreen(),
      );

    case OrdersScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const OrdersScreen(),
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
