import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class roundedImageNetwork extends StatelessWidget {
  final String imagePath;
  final double size;

  roundedImageNetwork({
    required Key key,
    required this.imagePath,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(size),
          ),
          color: Colors.yellow),
    );
  }
}

class roundedImageFile extends StatelessWidget {
  final PlatformFile image;
  final double size;

  roundedImageFile({
    required Key key,
    required this.image,
    required this.size,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(File(image.path!)),
        ),
          borderRadius: BorderRadius.all(
            Radius.circular(size),
          ),
          color: Colors.blue
      ),
    );
  }
}

