import 'package:flutter/material.dart';

import 'router.dart';
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
      home: const RegistrationScreen(),
    );
  }
}
