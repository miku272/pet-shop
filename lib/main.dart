import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'router.dart';
import './screens/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
