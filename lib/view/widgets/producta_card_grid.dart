import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';

import 'product_card_design.dart';

class ProductCardGrid extends StatelessWidget {
  final ProductsModel? snapshot;
  final bool shouldScroll;
  final bool isSaved;

  const ProductCardGrid({
    Key? key,
    this.snapshot,
    this.shouldScroll = false,
    this.isSaved = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = 260;
    final double itemWidth = size.width / 2;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: (itemWidth / itemHeight),
      ),
      itemCount: snapshot!.size,
      shrinkWrap: true,
      physics: shouldScroll
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(4.0),
      itemBuilder: (BuildContext context, int index) {
        return ProductCardDesign(
          data: snapshot!.productsModelList[index],
          isGrid: true,
          isSaved: isSaved,
        );
      },
    );
  }
}
