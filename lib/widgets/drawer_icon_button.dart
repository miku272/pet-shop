import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerIconButton extends StatelessWidget {
  const DrawerIconButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        'assets/nav_icon.svg',
        width: 18,
      ),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}
