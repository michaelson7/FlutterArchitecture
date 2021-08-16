import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/constants.dart';
import 'horizontal_widget.dart';

shimmerLayout({required Widget child}) {
  return Shimmer.fromColors(
    baseColor: kCardBackground,
    highlightColor: kCardBackgroundFaint,
    child: Material(
      borderRadius: kBorderRadiusCircular,
      child: Card(
        child: child,
      ),
    ),
  );
}

GridView productCardGridShimmer({bool displayTwo = false}) {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    ),
    itemCount: displayTwo ? 2 : 5,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      return shimmerLayout(
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
  return shimmerLayout(
    child: Container(
      height: 10,
      width: 200,
      color: kCardBackground,
    ),
  );
}

Widget horizontalProductCard() {
  return shimmerLayout(
    child: Container(
      height: 200,
      width: double.infinity,
      color: kCardBackground,
    ),
  );
}

Widget productShimmerLayout() {
  return SingleChildScrollView(
    child: Column(
      children: [
        shimmerLayout(
          child: Container(
            height: 300,
            width: double.infinity,
          ),
        ),
        SizedBox(height: 20),
        tabbedButtonShimmer(),
        productCardGridShimmer()
      ],
    ),
  );
}

homePageShimmerLayout() {
  return SingleChildScrollView(
    physics: NeverScrollableScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tabbedButtonShimmer(),
        SizedBox(height: 20),
        shimmerLayout(
          child: Container(
            height: 20,
            width: double.infinity,
          ),
        ),
        SizedBox(height: 20),
        tabbedButtonShimmer(),
        SizedBox(height: 20),
        productCardGridShimmer(displayTwo: true),
        SizedBox(height: 20),
        horizontalProductCard()
      ],
    ),
  );
}
