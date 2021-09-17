import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:system_info/system_info.dart';
import 'package:virtual_ggroceries/model/core/ads_model.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/provider/adsProvider.dart';
import 'package:virtual_ggroceries/provider/category_provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';
import 'package:virtual_ggroceries/view/screens/activities/search_activity.dart';
import 'package:virtual_ggroceries/view/widgets/ads_card.dart';
import 'package:virtual_ggroceries/view/widgets/logger_widget.dart';
import 'package:virtual_ggroceries/view/widgets/producta_card_grid.dart';
import 'package:virtual_ggroceries/view/widgets/products_card_horizontal.dart';
import 'package:virtual_ggroceries/view/widgets/shimmers.dart';
import 'package:virtual_ggroceries/view/widgets/snack_bar_builder.dart';
import 'package:virtual_ggroceries/view/widgets/snapshot_handler.dart';
import 'package:virtual_ggroceries/view/widgets/stacked_product_card.dart';
import 'package:virtual_ggroceries/view/widgets/tabbed_buttons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  @override
  bool get wantKeepAlive => true;

  CategoryProvider _categoryProvider = CategoryProvider();
  ProductsProvider _productsProvider = ProductsProvider();
  AdsProvider _adsProvider = AdsProvider();
  Logger logger = Logger();

  int currentIndex = 0, streamIndex = 0, page = 1;
  bool isLoading = true;
  bool loadMoreSubProducts = false, loadMore = false;

  @override
  void initState() {
    initProviders();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _categoryProvider.dispose();
    _productsProvider.dispose();
    _adsProvider.dispose();
  }

  void initProviders() async {
    await _categoryProvider.getCategories();
    await _productsProvider.getProducts();
    await _productsProvider.getProducts(filter: ProductFilters.new_arrival);
    await _productsProvider.getProducts(filter: ProductFilters.recommendation);
    await _productsProvider.getProducts(filter: ProductFilters.recommendation);
    await _productsProvider.getProducts(filter: ProductFilters.mostPopular);
    await _adsProvider.getAds();

    setState(() => isLoading = false);
  }

  Future<Null> _refreshHomePage() async {
    _resetLoading();
    initProviders();
  }

  _resetLoading() {
    setState(() {
      isLoading = !isLoading;
      page = 1;
    });
  }

  Future _loadMoreVertical() async {
    if (page <= 4) {
      page++;
      setState(() => loadMore = true);
      await _productsProvider.updatePaginatedList(page: page);
      setState(() => loadMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ModalProgressHUD(
      inAsyncCall: loadMoreSubProducts,
      color: kScaffoldColor,
      child: LazyLoadScrollView(
        onEndOfPage: () => _loadMoreVertical(),
        scrollOffset: 70,
        child: RefreshIndicator(
          onRefresh: _refreshHomePage,
          child: isLoading
              ? homePageShimmerLayout()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'Welcome to\nVirtual Groceries',
                          style: kTextStyleHeader,
                          textScaleFactor: 1,
                        ),
                      ),
                      //search field
                      Material(
                        color: kCardBackground,
                        borderRadius: kBorderRadiusCircular,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, SearchActivity.id);
                          },
                          child: ListTile(
                            leading: Icon(Icons.search),
                            title: Text(
                              "Search for products...",
                              style: kTextStyleFaint,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Featured Products',
                        style: kTextStyleSubHeader,
                      ),
                      SizedBox(height: 20),
                      //category List
                      Container(
                        child: categoryBuilder(),
                      ),
                      SizedBox(height: 15),
                      //horizontalCardView
                      Container(
                        child: productsBuilder(
                          stream: _productsProvider.getCategoryProductsStream,
                        ),
                      ),
                      SizedBox(height: 15),
                      //adsCard
                      Container(
                        child: adsBuilder(pageCount: 0),
                      ),
                      SizedBox(height: 15),
                      //horizontalCardView
                      Text(
                        'Recommended',
                        style: kTextStyleSubHeader,
                      ),
                      Container(
                        child: productsBuilder(
                          stream:
                              _productsProvider.getRecommendedProductsStream,
                        ),
                      ),
                      SizedBox(height: 15),
                      //adsCard
                      Container(
                        child: adsBuilder(pageCount: 1),
                      ),
                      SizedBox(height: 15),
                      //horizontalCardView
                      Text(
                        'New Arrivals',
                        style: kTextStyleSubHeader,
                      ),
                      Container(
                        child: productsBuilder(
                          stream: _productsProvider.getNewProductsStream,
                        ),
                      ),
                      SizedBox(height: 15),
                      //stacked product card
                      Text(
                        'Most Popular',
                        style: kTextStyleSubHeader,
                      ),
                      Container(
                        child: mostPopularStackedProductCardBuilder(),
                      ),
                      SizedBox(height: 15),
                      //ProductGrid
                      Text(
                        'All Products',
                        style: kTextStyleSubHeader,
                      ),
                      Container(
                        child: productCardGridBuilder(),
                      ),
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
      ),
    );
  }

  StreamBuilder<CategoryModel> categoryBuilder() {
    return StreamBuilder(
      stream: _categoryProvider.getStream,
      builder: (context, AsyncSnapshot<CategoryModel> snapshot) {
        return snapShotBuilder(
          snapshot: snapshot,
          shimmer: tabbedButtonShimmer(),
          widget: TabbedButtons(
            snapshot: snapshot,
            onSelectionUpdated: (index) async {
              setState(() => currentIndex = index);
              setState(() => loadMoreSubProducts = !loadMoreSubProducts);
              await _productsProvider.getProducts(
                filter: ProductFilters.cat_prod,
                categoryId: index,
              );
              setState(() => loadMoreSubProducts = !loadMoreSubProducts);
            },
            selectedIndex: currentIndex,
          ),
        );
      },
    );
  }

  // product Cards
  StreamBuilder<ProductsModel> productsBuilder({
    required var stream,
    Function? function,
    bool hasFunction = false,
  }) {
    if (hasFunction) {
      function!();
    }
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
        return snapShotBuilder(
          snapshot: snapshot,
          shimmer: productCardGridShimmer(displayTwo: true),
          widget: loadMoreSubProducts
              ? productCardGridShimmer(displayTwo: true)
              : ProductsCardHorizontal(snapshot),
        );
      },
    );
  }

  StreamBuilder<ProductsModel> productCardGridBuilder() {
    return StreamBuilder(
      stream: _productsProvider.getStream,
      builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
        return snapShotBuilder(
          snapshot: snapshot,
          shimmer: productCardGridShimmer(),
          widget: ProductCardGrid(snapshot: snapshot.data),
        );
      },
    );
  }

  StreamBuilder<ProductsModel> mostPopularStackedProductCardBuilder() {
    return StreamBuilder(
      stream: _productsProvider.getMostPopularStream,
      builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
        return snapShotBuilder(
          snapshot: snapshot,
          shimmer: horizontalProductCard(),
          widget: StackedProductCard(snapshot),
        );
      },
    );
  }

  StreamBuilder<AdsModel> adsBuilder(
      {bool hasFunction = false, required int pageCount}) {
    return StreamBuilder(
      stream: _adsProvider.getStream,
      builder: (context, AsyncSnapshot<AdsModel> snapshot) {
        return snapShotBuilder(
          snapshot: snapshot,
          shimmer: productCardGridShimmer(),
          widget: AdsCard(snapshot: snapshot.data, page: pageCount),
        );
      },
    );
  }
}
