import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../size_config.dart';
import '../app_styles.dart';

import '../services/database_service.dart';

class PetContainer extends StatefulWidget {
  final int totalLength;
  final int index;
  final String petId;
  final String petImageUrl;
  final String petName;
  final String petBreed;
  final String postingDate;

  const PetContainer({
    required this.totalLength,
    required this.index,
    required this.petId,
    required this.petImageUrl,
    required this.petName,
    required this.petBreed,
    required this.postingDate,
    Key? key,
  }) : super(key: key);

  @override
  State<PetContainer> createState() => _PetContainerState();
}

class _PetContainerState extends State<PetContainer> {
  var likedIcon = Icons.favorite_outline;

  Future initFavIcon() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    final snapshot =
        await DatabaseService().getPetDataUsinguid(widget.petId) as Map?;

    if (snapshot?['likedBy'].contains(FirebaseAuth.instance.currentUser!.uid)) {
      setState(() {
        likedIcon = Icons.favorite;
      });
    }
  }

  onFavTap() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    final snapshot =
        await DatabaseService().getPetDataUsinguid(widget.petId) as Map?;

    if (snapshot?['likedBy'].contains(FirebaseAuth.instance.currentUser!.uid)) {
      await DatabaseService().removeLike(
        widget.petId,
        FirebaseAuth.instance.currentUser!.uid,
      );

      setState(() {
        likedIcon = Icons.favorite_outline;
      });
    } else if (!(snapshot?['likedBy']
        .contains(FirebaseAuth.instance.currentUser!.uid))) {
      await DatabaseService().likePost(
        widget.petId,
        FirebaseAuth.instance.currentUser!.uid,
      );

      setState(() {
        likedIcon = Icons.favorite;
      });
    }
  }

  @override
  void initState() {
    initFavIcon();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenProps = MediaQuery.of(context);

    return Container(
      height: screenProps.orientation == Orientation.portrait ? 200 : 250,
      width: 180,
      margin: EdgeInsets.only(
        left: widget.index == 0 ? 25 : 15,
        right: widget.index == widget.totalLength - 1 ? 25 : 0,
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
                widget.petImageUrl,
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
                      widget.petName,
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
              InkWell(
                onTap: onFavTap,
                child: Icon(
                  likedIcon,
                  color: red,
                  size: 23,
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.petBreed,
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
                  widget.postingDate,
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
