import 'package:flutter/material.dart';

import '../app_styles.dart';

import '../widgets/my_snackbar.dart';

class WishlistContainer extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String productPrice;
  final bool outOfStock;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const WishlistContainer({
    required this.imageUrl,
    required this.productName,
    required this.productPrice,
    required this.outOfStock,
    required this.onRemove,
    required this.onAddToCart,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        productName,
        maxLines: 3,
        style: sourceSansProRegular.copyWith(
          color: outOfStock ? red : grey,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Text(
        'Price: $productPrice',
        style: sourceSansProSemiBold,
      ),
      trailing: SizedBox(
        width: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: onRemove,
              child: const Icon(
                Icons.delete,
                color: red,
              ),
            ),
            InkWell(
              onTap: outOfStock
                  ? () {
                      MySnackbar.showSnackbar(
                        context,
                        red,
                        'Item currenctly out of stock',
                      );
                    }
                  : onAddToCart,
              child: const Icon(
                Icons.shopping_bag,
                color: black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
