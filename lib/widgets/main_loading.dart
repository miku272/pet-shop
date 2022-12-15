import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MainLoading extends StatelessWidget {
  const MainLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/loaders/animal-paws.json',
        height: 200,
        width: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}
