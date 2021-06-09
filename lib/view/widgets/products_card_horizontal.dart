import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/widgets/product_card_design.dart';
import 'horizontal_widget.dart';

class ProductsCardHorizontal extends StatelessWidget {
  final AsyncSnapshot<ProductsModel> snapshot;
  ProductsCardHorizontal(this.snapshot);

  @override
  Widget build(BuildContext context) {
    var modelData = snapshot.data!.productsModelList;
    List<Widget> widgetList = [];

    for (var data in modelData) {
      var interface = ProductCardDesign(
        data: data,
        isGrid: false,
      );
      widgetList.add(interface);
    }

    var horizontalStyle = horizontalWidgetBuilder(widgetList);
    return horizontalStyle;
  }
}
