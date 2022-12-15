import 'package:flutter/material.dart';

import 'router.dart';
// import './screens/home_screen.dart';
// import './screens/login_screen.dart';
import './screens/registration_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (routeSettings) => generateRoute(routeSettings),
      // home: const HomeScreen(),
      // home: const LoginScreen(),
      home: const RegistrationScreen(),
    );
  }
}
