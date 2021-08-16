import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/provider/cart_provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';
import 'package:virtual_ggroceries/view/widgets/dark_img_widget.dart';
import 'package:get/get.dart';
import 'package:virtual_ggroceries/view/widgets/empty_handler.dart';
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
  Logger logger = Logger();
  ProductsProvider _productsProvider = ProductsProvider();
  int quantity = 1, page = 1;
  dynamic price = 0.00, originalPrice = 0.00;
  bool loadMore = false, isLoading = false;

  addToQuantity() {
    setState(() {
      quantity++;
      price = originalPrice * quantity;
      widget._model.orderQuantity = quantity;
      widget._model.price = price;
    });
  }

  removeFromQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        price = price - originalPrice;
        widget._model.orderQuantity = quantity;
        widget._model.price = price;
      });
    }
  }

  void initProviders() async {
    setState(() {
      isLoading = true;
      price = widget._model.price;
      originalPrice = price;
    });
    await _productsProvider.getProducts(
        filter: ProductFilters.cat_prod, categoryId: widget._model.categoryId);
    setState(() => isLoading = false);
  }

  Future _loadMoreVertical() async {
    page++;
    setState(() => loadMore = true);
    await _productsProvider.updatePaginatedList(
        filter: ProductFilters.cat_prod,
        categoryId: widget._model.categoryId,
        page: page);
    setState(() => loadMore = false);
  }

  @override
  void initState() {
    initProviders();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _productsProvider.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        body: isLoading
            ? productShimmerLayout()
            : LazyLoadScrollView(
                onEndOfPage: () => _loadMoreVertical(),
                child: CustomScrollView(
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
                                style: kTextStyleSubHeader.copyWith(
                                    color: kAccentColor),
                              ),
                            ),
                            SizedBox(height: 15),
                            productsGridBuilder(),
                            loadMore
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'ZMW ${price.toStringAsFixed(2)}',
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
                      icon: Icon(FontAwesomeIcons.minus),
                      onPressed: removeFromQuantity,
                    ),
                    Text(quantity.toString()),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.plus),
                      onPressed: addToQuantity,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => addToCart(context),
              )
            ],
          )
        ],
      ),
    );
  }

  void addToCart(BuildContext context) {
    var message;
    if (Provider.of<CartProvider>(context, listen: false)
        .addToCart(widget._model)) {
      message = '${widget._model.name}added to cart';
    } else {
      message = 'error, check logs';
    }
    snackBarBuilder(message: message, context: context);
  }

  productsGridBuilder() {
    return StreamBuilder(
      stream: _productsProvider.getCategoryProductsStream,
      builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
        return snapShotBuilder(
          snapshot: snapshot,
          shimmer: productCardGridShimmer(),
          emptyMessage: "No Products Found",
          widget: ProductCardGrid(
            snapshot: snapshot.data,
          ),
        );
      },
    );
  }
}
