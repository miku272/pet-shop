import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../firebase_options.dart';
import '../app_styles.dart';

import '../widgets/my_snackbar.dart';

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
  final _razorPay = Razorpay();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });

    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(response);

    // verifySignature(
    //   signature: response.signature!,
    //   paymentId: response.paymentId!,
    //   orderId: response.orderId!,
    // );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    MySnackbar.showSnackbar(
      context,
      red,
      'Payment failed due to unknown error. Please try again',
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  Future<void> verifySignature({
    required String signature,
    required String paymentId,
    required String orderId,
  }) async {
    Map<String, dynamic> body = {
      'razorpay_signature': signature,
      'razorpay_payment_id': paymentId,
      'razorpay_order_id': orderId,
    };

    var parts = [];
    body.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value)}');
    });

    var formData = parts.join('&');

    print('Form Data: $formData');

    var res = await http.post(
      Uri.parse('http://192.168.81.153:3000/verifyOrder'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: formData,
    );

    print('Signature verification: ${res.body}');

    if (res.statusCode == 200) {
      if (mounted) {
        MySnackbar.showSnackbar(context, black, res.body);
      }
    }
  }

  Future<void> createOrder(int amount) async {
    String userName = razorPayKeyId;
    String password = razorPaySecretKey;
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$userName:$password'))}';

    Map<String, dynamic> body = {
      'amount': amount,
      'currency': 'INR',
    };

    var res = await http.post(
      Uri.https('api.razorpay.com', 'v1/orders'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': basicAuth,
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      openGateway(
        jsonDecode(res.body)['id'],
        amount * 100,
      );
    }

    print(jsonDecode(res.body));
  }

  void openGateway(String orderId, int amount) {
    var options = {
      'key': razorPayKeyId,
      'order_id': orderId,
      'amount': amount * 100,
      'name': 'Paw Pals',
      'timeout': 60 * 5,
      'prefill': {
        'contact': '+918347386059',
        'email': FirebaseAuth.instance.currentUser!.email,
      },
    };

    _razorPay.open(options);
  }

  @override
  void dispose() {
    _razorPay.clear();

    super.dispose();
  }

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
                    Text(
                      'Select payment method',
                      style: sourceSansProRegular.copyWith(
                        fontSize: 18,
                        color: grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        String strAmt =
                            (widget.args!['discountPrice'] as double)
                                .toStringAsFixed(2);

                        double dblAmt = double.parse(strAmt) * 100;
                        int amount = dblAmt.toInt();

                        createOrder(amount);
                      },
                      child: Text(
                        'Pay ${(widget.args!['discountPrice'] as double).toStringAsFixed(2)}',
                      ),
                    ),
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
            child: CircularProgressIndicator(
              color: boxShadowColor,
            ),
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
                child: CircularProgressIndicator(
                  color: boxShadowColor,
                ),
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
