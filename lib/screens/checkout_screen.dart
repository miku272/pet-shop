import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app_styles.dart';

import '../services/database_service.dart';

import './address_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Check Out',
          style: sourceSansProRegular.copyWith(
            color: grey,
            fontSize: 30,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: widget.args == null
              ? Center(
                  child: Text(
                    'Something Went Wrong...',
                    style: sourceSansProBold.copyWith(
                      fontSize: 20,
                      color: grey,
                    ),
                  ),
                )
              : Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Original Price:',
                          style: sourceSansProMedium.copyWith(
                            fontSize: 23,
                          ),
                        ),
                        Text(
                            (widget.args!['originalPrice'] as double)
                                .toStringAsFixed(2),
                            style: sourceSansProMedium.copyWith(
                              fontSize: 23,
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total Price:',
                          style: sourceSansProMedium.copyWith(
                            fontSize: 23,
                          ),
                        ),
                        Text(
                          (widget.args!['discountPrice'] as double)
                              .toStringAsFixed(2),
                          style: sourceSansProMedium.copyWith(
                            fontSize: 23,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Your Savings:',
                          style: sourceSansProMedium.copyWith(
                            fontSize: 23,
                          ),
                        ),
                        Text(
                          (widget.args!['savings'] as double)
                              .toStringAsFixed(2),
                          style: sourceSansProMedium.copyWith(
                            fontSize: 23,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Divider(color: boxShadowColor),
                    const SizedBox(height: 15),
                    Text(
                      'Deliever to:',
                      style: sourceSansProRegular.copyWith(
                        fontSize: 18,
                        color: grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const DefaultAddress(),
                    const SizedBox(height: 15),
                    const Divider(color: boxShadowColor),
                    const SizedBox(height: 15),
                  ],
                ),
        ),
      ),
    );
  }
}

class DefaultAddress extends StatefulWidget {
  const DefaultAddress({super.key});

  @override
  State<DefaultAddress> createState() => _DefaultAddressState();
}

class _DefaultAddressState extends State<DefaultAddress> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseService().getDefaultAddress(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data == null) {
          return Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AddressScreen.routeName)
                    .then((value) {
                  setState(() {});
                });
              },
              child: Text(
                'Choose Address',
                style: sourceSansProRegular.copyWith(
                  color: boxShadowColor,
                  fontSize: 20,
                ),
              ),
            ),
          );
        }

        return FutureBuilder(
          future: DatabaseService().getAddressUsingUid(
              FirebaseAuth.instance.currentUser!.uid, snapshot.data!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            Map addr = snapshot.data!.data() as Map;

            return Column(
              children: <Widget>[
                Text(
                  '${addr['fullName']},\n${addr['addressLine1']}, ${addr['addressLine2']}, ${addr['city']}, ${addr['state']}, ${addr['pinCode']}\nMobile No.: ${addr['mobNumber']}',
                  style: sourceSansProRegular.copyWith(
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AddressScreen.routeName)
                        .then((value) {
                      setState(() {});
                    });
                  },
                  child: Text(
                    'Choose Address',
                    style: sourceSansProRegular.copyWith(
                      color: boxShadowColor,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
