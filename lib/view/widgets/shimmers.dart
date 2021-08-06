import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/constants.dart';
import 'horizontal_widget.dart';

GridView productCardGridShimmer() {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    ),
    itemCount: 5,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      return Card(
        child: Container(
          height: 200,
          width: 200,
          color: kCardBackground,
        ),
      );
    },
  );
}

Widget tabbedButtonShimmer() {
  return Card(
    child: Container(
      height: 10,
      width: 200,
      color: kCardBackground,
    ),
  );
}

Widget horizontalProductCard() {
  return Card(
    child: Container(
      height: 200,
      width: double.infinity,
      color: kCardBackground,
    ),
  );
}

class CustomWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const CustomWidget.rectangular(
      {this.width = double.infinity, required this.height})
      : this.shapeBorder = const RoundedRectangleBorder();

  const CustomWidget.circular(
      {this.width = double.infinity,
      required this.height,
      this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Colors.red,
        highlightColor: Colors.grey[300]!,
        period: Duration(seconds: 2),
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: Colors.grey[400]!,
            shape: shapeBorder,
          ),
        ),
      );
}
