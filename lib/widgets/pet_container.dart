import 'package:flutter/material.dart';

import '../size_config.dart';
import '../app_styles.dart';

class PetContainer extends StatelessWidget {
  final int totalLength;
  final int index;
  final String petImageUrl;
  final String petName;
  final String petBreed;
  final String postingDate;

  const PetContainer({
    required this.totalLength,
    required this.index,
    required this.petImageUrl,
    required this.petName,
    required this.petBreed,
    required this.postingDate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenProps = MediaQuery.of(context);

    return Container(
      height: screenProps.orientation == Orientation.portrait ? 200 : 250,
      width: 180,
      margin: EdgeInsets.only(
        left: index == 0 ? 25 : 15,
        right: index == totalLength - 1 ? 25 : 0,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: boxShadowColor.withOpacity(0.18),
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: screenProps.orientation == Orientation.portrait ? 100 : 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Image.network(
                petImageUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                height: 20,
                decoration: BoxDecoration(
                  color: lightOrange,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Expanded(
                    child: Text(
                      petName,
                      style: sourceSansProBold.copyWith(
                        fontSize:
                            screenProps.orientation == Orientation.portrait
                                ? SizeConfig.blockSizeHorizontal! * 4
                                : SizeConfig.blockSizeHorizontal! * 2,
                        color: orange,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              const Icon(
                Icons.favorite_outline,
                color: red,
                size: 23,
              ),
            ],
          ),
          const SizedBox(height: 1),
          Row(
            children: [
              Expanded(
                child: Text(
                  petBreed,
                  maxLines: 1,
                  style: sourceSansProBold.copyWith(
                    fontSize: screenProps.orientation == Orientation.portrait
                        ? SizeConfig.blockSizeHorizontal! * 3.9
                        : SizeConfig.blockSizeHorizontal! * 2.5,
                    color: grey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  postingDate,
                  maxLines: 1,
                  style: sourceSansProRegular.copyWith(
                    fontSize: screenProps.orientation == Orientation.portrait
                        ? SizeConfig.blockSizeHorizontal! * 3.5
                        : SizeConfig.blockSizeHorizontal! * 2,
                    color: lightGrey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
