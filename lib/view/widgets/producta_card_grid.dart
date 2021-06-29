import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';

import 'product_card_design.dart';

class ProductCardGrid extends StatelessWidget {
  final AsyncSnapshot<ProductsModel> snapshot;
  final bool shouldScroll;
  const ProductCardGrid({
    Key? key,
    required this.snapshot,
    this.shouldScroll = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemCount: snapshot.data!.size,
      shrinkWrap: true,
      physics: shouldScroll
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(4.0),
      itemBuilder: (BuildContext context, int index) {
        return ProductCardDesign(
          data: snapshot.data!.productsModelList[index],
          isGrid: true,
          isSaved: false,
        );
      },
    );
  }
}
