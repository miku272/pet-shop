import 'dart:io';

import 'package:flutter/material.dart';

class FileImageListTile extends StatelessWidget {
  final File image;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const FileImageListTile({
    required this.image,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: FileImage(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
