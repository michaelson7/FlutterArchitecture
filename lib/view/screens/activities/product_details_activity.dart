import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/provider/cart_provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';
import 'package:virtual_ggroceries/view/widgets/dark_img_widget.dart';
import 'package:get/get.dart';
import 'package:virtual_ggroceries/view/widgets/padded_container.dart';
import 'package:virtual_ggroceries/view/widgets/producta_card_grid.dart';
import 'package:virtual_ggroceries/view/widgets/shimmers.dart';
import 'package:virtual_ggroceries/view/widgets/snack_bar_builder.dart';
import 'package:virtual_ggroceries/view/widgets/snapshot_handler.dart';

class ProductsDetails extends StatefulWidget {
  final ProductsModelList _model;
  ProductsDetails(this._model);

  @override
  _ProductsDetailsState createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {
  ProductsProvider _productsProvider = ProductsProvider();

  void initProviders() async {
    await _productsProvider.getProducts(
        filter: ProductFilters.cat_prod, categoryId: widget._model.categoryId);
  }

  @override
  void initState() {
    initProviders();
    super.initState();
  }

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
                title: Text(widget._model.name),
                background: DarkImageWidget(
                  imgPath: widget._model.imgPath,
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
                      '${widget._model.description}',
                    ),
                    SizedBox(height: 15),
                    Text(
                      '${widget._model.quantity} left',
                      style: kTextStyleFaint,
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Text(
                        'Similar Products',
                        style:
                            kTextStyleSubHeader.copyWith(color: kAccentColor),
                      ),
                    ),
                    SizedBox(height: 15),
                    StreamBuilder(
                      stream: _productsProvider.getCategoryProductsStream,
                      builder:
                          (context, AsyncSnapshot<ProductsModel> snapshot) {
                        return snapShotBuilder(
                          snapshot: snapshot,
                          shimmer: productCardGridShimmer(),
                          widget: ProductCardGrid(
                            snapshot: snapshot,
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'ZMW ${widget._model.price.toString()}',
                style: TextStyle(color: kAccentColor),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: kBorderRadiusCircular,
                  border: Border.all(
                    color: kCardBackground,
                    width: 3,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_right_alt),
                      onPressed: () {},
                    ),
                    Text("1"),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  var message;
                  if (Provider.of<CartProvider>(context, listen: false)
                      .addToCart(widget._model)) {
                    message = '${widget._model.name}added to cart';
                  } else {
                    message = 'error, check logs';
                  }
                  snackBarBuilder(message: message, context: context);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
