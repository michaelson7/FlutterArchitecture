import 'package:flutter/material.dart';

class DarkImageWidget extends StatelessWidget {
  final imgPath;
  final borderRadius;
  final width;
  final height;
  final child;

  DarkImageWidget({
    required this.imgPath,
    this.borderRadius,
    this.width,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        image: DecorationImage(
          image: NetworkImage(imgPath),
          fit: BoxFit.cover,
          colorFilter: new ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: child,
    );
  }
}
