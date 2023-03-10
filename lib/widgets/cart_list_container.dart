import 'package:flutter/material.dart';

import '../app_styles.dart';

class CartListContainer extends StatefulWidget {
  const CartListContainer({super.key});

  @override
  State<CartListContainer> createState() => _CartListContainerState();
}

class _CartListContainerState extends State<CartListContainer> {
  var counter = 1;

  void increaseCounter() {
    setState(() {
      counter++;
    });
  }

  void decreaseCounter() {
    if (counter == 1) {
      return;
    }

    setState(() {
      counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.red[200],
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1597843786411-a7fa8ad44a95?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
                ),
                fit: BoxFit.cover,
                repeat: ImageRepeat.noRepeat,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Food',
                style: sourceSansProSemiBold.copyWith(
                  color: grey,
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: increaseCounter,
                    icon: const Icon(
                      Icons.add,
                      color: boxShadowColor,
                    ),
                  ),
                  Text(
                    counter.toString(),
                    style: sourceSansProSemiBold.copyWith(
                      fontSize: 18,
                      color: grey,
                    ),
                  ),
                  IconButton(
                    onPressed: decreaseCounter,
                    icon: const Icon(
                      Icons.horizontal_rule,
                      color: red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
