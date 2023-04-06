import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_options.dart';
import '../app_styles.dart';

import '../widgets/my_snackbar.dart';

import '../services/database_service.dart';

import './address_screen.dart';
import './cart_screen.dart';
import './orders_screen.dart';

bool userHasAddress = false;
String userAddressId = '';

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

  int selectedRadioTile = 0;
  int totalAmount = 0;
  bool isLoading = false;
  bool decreaseStockAgain = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });

    super.initState();
  }

  Future<void> _handlePayOnDelivery() async {
    QuerySnapshot cart = await DatabaseService().getUserStaticCartData(
      FirebaseAuth.instance.currentUser!.uid,
    );

    DocumentSnapshot userAddress = await DatabaseService().getAddressUsingUid(
      FirebaseAuth.instance.currentUser!.uid,
      userAddressId,
    );

    Map userAddressData = userAddress.data() as Map;

    String day = DateTime.now().day.toString();
    String month = DateTime.now().month.toString();
    String year = DateTime.now().year.toString();

    for (var cartData in cart.docs) {
      int quantity = cartData['quantity'];

      if (decreaseStockAgain) {
        await DatabaseService().decreaseProductStock(
          cartData['productId'],
          quantity,
        );
      }

      await DatabaseService().addOrder(
        FirebaseAuth.instance.currentUser!.uid,
        null,
        null,
        cartData['productId'],
        totalAmount,
        cartData['quantity'],
        false,
        false,
        '$day-$month-$year',
        'payOnDelivery',
        userAddressData['fullName'],
        userAddressData['addressLine1'],
        userAddressData['addressLine2'],
        userAddressData['city'],
        userAddressData['state'],
        userAddressData['pinCode'],
        userAddressData['mobNumber'],
      );

      await DatabaseService().clearCart(
        FirebaseAuth.instance.currentUser!.uid,
      );
    }

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        OrdersScreen.routeName,
        ModalRoute.withName(CartScreen.routeName),
      );
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final cart = await DatabaseService().getUserStaticCartData(
      FirebaseAuth.instance.currentUser!.uid,
    );

    DocumentSnapshot userAddress = await DatabaseService().getAddressUsingUid(
      FirebaseAuth.instance.currentUser!.uid,
      userAddressId,
    );

    Map userAddressData = userAddress.data() as Map;

    String day = DateTime.now().day.toString();
    String month = DateTime.now().month.toString();
    String year = DateTime.now().year.toString();

    for (var element in cart.docs) {
      Map cartData = element.data() as Map;
      int quantity = cartData['quantity'];

      if (decreaseStockAgain) {
        await DatabaseService().decreaseProductStock(
          cartData['productId'],
          quantity,
        );
      }

      await DatabaseService().addOrder(
        FirebaseAuth.instance.currentUser!.uid,
        response.paymentId,
        response.orderId,
        cartData['productId'],
        totalAmount,
        cartData['quantity'],
        false,
        false,
        '$day-$month-$year',
        'razorpay',
        userAddressData['fullName'],
        userAddressData['addressLine1'],
        userAddressData['addressLine2'],
        userAddressData['city'],
        userAddressData['state'],
        userAddressData['pinCode'],
        userAddressData['mobNumber'],
      );

      await DatabaseService().clearCart(
        FirebaseAuth.instance.currentUser!.uid,
      );
    }

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        OrdersScreen.routeName,
        ModalRoute.withName(CartScreen.routeName),
      );
    }
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    decreaseStockAgain = true;

    MySnackbar.showSnackbar(
      context,
      red,
      'Payment failed due to unknown error. Please try again',
    );

    QuerySnapshot cartData = await DatabaseService().getUserStaticCartData(
      FirebaseAuth.instance.currentUser!.uid,
    );

    for (var element in cartData.docs) {
      int quantity = element['quantity'];

      await DatabaseService().increaseProductStock(
        element['productId'],
        quantity,
      );
    }
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

    // print('Form Data: $formData');

    var res = await http.post(
      Uri.parse('http://192.168.81.153:3000/verifyOrder'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: formData,
    );

    // print('Signature verification: ${res.body}');

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

    if (decreaseStockAgain) {
      QuerySnapshot cartData = await DatabaseService().getUserStaticCartData(
        FirebaseAuth.instance.currentUser!.uid,
      );

      for (var element in cartData.docs) {
        int quantity = element['quantity'];

        await DatabaseService().decreaseProductStock(
          element['productId'],
          quantity,
        );
      }
    }

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

    // print(jsonDecode(res.body));
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
                    RadioListTile(
                      value: 1,
                      groupValue: selectedRadioTile,
                      activeColor: boxShadowColor,
                      title: const Text(
                        'Pay on Delivery',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      subtitle: const Text(
                        'Pay using cash when you receive your product',
                        style: TextStyle(
                          color: grey,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            selectedRadioTile = value;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 5),
                    RadioListTile(
                      value: 2,
                      groupValue: selectedRadioTile,
                      title: const Text(
                        'Pay online',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      subtitle: const Text(
                        'Pay online on razorpay using cards, UPI, wallet or netbanking',
                        style: TextStyle(
                          color: grey,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            selectedRadioTile = value;
                          }
                        });
                      },
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: FloatingActionButton.extended(
          onPressed: isLoading
              ? null
              : () async {
                  if (!userHasAddress) {
                    MySnackbar.showSnackbar(
                      context,
                      black,
                      'Please select an address',
                    );

                    return;
                  }

                  if (selectedRadioTile == 0) {
                    MySnackbar.showSnackbar(
                      context,
                      black,
                      'Please choose a payment method',
                    );

                    return;
                  }

                  if (selectedRadioTile == 1) {
                    String strAmt = (widget.args!['discountPrice'] as double)
                        .toStringAsFixed(2);

                    double dblAmt = double.parse(strAmt) * 100;
                    int amount = dblAmt.toInt();

                    totalAmount = amount;
                    await _handlePayOnDelivery();
                  }

                  if (selectedRadioTile == 2) {
                    String strAmt = (widget.args!['discountPrice'] as double)
                        .toStringAsFixed(2);

                    double dblAmt = double.parse(strAmt) * 100;
                    int amount = dblAmt.toInt();

                    totalAmount = amount;

                    await createOrder(amount);
                  }
                },
          extendedPadding: const EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: grey,
          label: Text(
            'Make Payment',
            style: sourceSansProSemiBold.copyWith(
              fontSize: 25,
              color: boxShadowColor,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

        if (!snapshot.hasData || snapshot.data == null || snapshot.data == '') {
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

        userAddressId = snapshot.data!;
        userHasAddress = true;

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
