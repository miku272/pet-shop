import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SubLoading extends StatelessWidget {
  const SubLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/loaders/cat-paw-loading.json',
        height: 200,
        width: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}
