import 'package:flutter/material.dart';

import '../app_styles.dart';

import '../services/database_service.dart';

class CartListContainer extends StatefulWidget {
  final String cartId;
  final String productId;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartListContainer({
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    super.key,
  });

  @override
  State<CartListContainer> createState() => _CartListContainerState();
}

class _CartListContainerState extends State<CartListContainer> {
  var counter = 0;

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
    return FutureBuilder(
      future: DatabaseService().getProductDataUsingUid(widget.productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: boxShadowColor,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text(
              'Something went wrong...',
              style: sourceSansProSemiBold.copyWith(
                color: grey,
                fontSize: 18,
              ),
            ),
          );
        }

        final productData = snapshot.data!.data() as Map;
        final discountedPrice = productData['price'] -
            (productData['price'] * (productData['discount'] / 100));

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(
                      productData['imageList'][0],
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Expanded(
                      child: Text(
                        productData['productName'],
                        maxLines: 2,
                        style: sourceSansProSemiBold.copyWith(
                          color: grey,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: widget.onIncrease,
                        icon: const Icon(
                          Icons.add,
                          color: boxShadowColor,
                        ),
                      ),
                      Text(
                        widget.quantity.toString(),
                        style: sourceSansProSemiBold.copyWith(
                          fontSize: 18,
                          color: grey,
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onDecrease,
                        icon: const Icon(
                          Icons.horizontal_rule,
                          color: red,
                        ),
                      ),
                      InkWell(
                        onTap: widget.onRemove,
                        child: const Icon(
                          Icons.delete,
                          color: red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: <Widget>[
                  Text(
                    'Price: ${discountedPrice.toString()}',
                    style: sourceSansProRegular.copyWith(
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total: ${(discountedPrice * widget.quantity).toString()}',
                    style: sourceSansProRegular.copyWith(
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
