import 'package:flutter/material.dart';

import './screens/pet_detail_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
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
