import 'package:flutter/material.dart';

import '../app_styles.dart';

class ProfileScreenListTile extends StatelessWidget {
  final IconData leadIcon;
  final IconData? trailIcon;
  final String title;
  final Color? titleColor;
  final VoidCallback? onPress;

  const ProfileScreenListTile({
    required this.leadIcon,
    required this.title,
    this.titleColor,
    this.trailIcon,
    this.onPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: CircleAvatar(
        child: Icon(leadIcon),
      ),
      title: Text(
        title,
        style: sourceSansProRegular.copyWith(
          fontSize: 18,
          color: titleColor,
        ),
      ),
      trailing: Icon(
        trailIcon,
        size: 50,
        color: lightGrey,
      ),
    );
  }
}
