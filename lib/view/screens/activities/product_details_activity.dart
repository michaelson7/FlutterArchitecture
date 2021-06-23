import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/provider/cart_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/widgets/dark_img_widget.dart';
import 'package:get/get.dart';
import 'package:virtual_ggroceries/view/widgets/snack_bar_builder.dart';

class ProductsDetails extends StatelessWidget {
  final ProductsModelList _model;
  ProductsDetails(this._model);

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 350.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(_model.name),
                background: DarkImageWidget(
                  imgPath: _model.imgPath,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'ZMW ${_model.price}',
                      style: TextStyle(color: kAccentColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Availability: ${_model.quantity}',
                    ),
                    SizedBox(height: 15),
                    Text(
                      '${_model.description}',
                      style: kTextStyleFaint,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          var message;
                          if (Provider.of<CartProvider>(context, listen: false)
                              .addToCart(_model)) {
                            message = '${_model.name}added to cart';
                          } else {
                            message = 'error, check logs';
                          }
                          snackBarBuilder(message: message, context: context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Add To Cart',
                            style: kTextStyleSubHeader,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
