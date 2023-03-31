import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  static const routeName = '/checkout-screen';

  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
    return CheckOut(args);
  }
}

class CheckOut extends StatefulWidget {
  final Map? args;

  const CheckOut(this.args, {super.key});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
