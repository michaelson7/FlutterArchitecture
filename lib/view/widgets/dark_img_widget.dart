import 'package:flutter/material.dart';

class DarkImageWidget extends StatelessWidget {
  final String imgPath;
  final borderRadius;
  final double width;
  final double height;
  final child;

  DarkImageWidget({
    required this.imgPath,
    this.borderRadius,
    this.width = 0,
    this.height = 0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xc3000000),
        borderRadius: borderRadius,
        image: DecorationImage(
          image: NetworkImage(imgPath),
          fit: BoxFit.cover,
          colorFilter: new ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: child,
    );
  }
}
