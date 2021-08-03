import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:virtual_ggroceries/view/widgets/producta_card_grid.dart';
import 'package:virtual_ggroceries/view/widgets/products_card_horizontal.dart';
import 'package:virtual_ggroceries/view/widgets/snack_bar_builder.dart';
import 'package:virtual_ggroceries/view/widgets/snapshot_handler.dart';
import 'package:virtual_ggroceries/view/widgets/stacked_product_card.dart';
import 'package:virtual_ggroceries/view/widgets/tabbed_buttons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AfterLayoutMixin<Home> {
  CategoryProvider _categoryProvider = CategoryProvider();
  ProductsProvider _productsProvider = ProductsProvider();
  AdsProvider _adsProvider = AdsProvider();

  int currentIndex = 0;
  int streamIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    initProviders();
    super.initState();
  }

  void initProviders() async {
    await _categoryProvider.getCategories();
    await _productsProvider.getProducts();
    await _productsProvider.getProducts(filter: ProductFilters.new_arrival);
    await _adsProvider.getAds();
    await _productsProvider.getProducts(filter: ProductFilters.recommendation);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to\nVirtual Groceries',
                  style: kTextStyleHeader,
                ),
                SizedBox(height: 15),
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
                  child: adsBuilder(),
                ),
                SizedBox(height: 15),
                //horizontalCardView
                Text(
                  'Recommended',
                  style: kTextStyleSubHeader,
                ),
                Container(
                  child: productsBuilder(
                    stream: _productsProvider.getRecommndedProductsStream,
                  ),
                ),
                SizedBox(height: 15),
                //adsCard
                Container(
                  child: adsBuilder(),
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
                  child: mostPopularstackedProductCardBuilder(),
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
              ],
            ),
          );
  }

  StreamBuilder<CategoryModel> categoryBuilder() {
    return StreamBuilder(
      stream: _categoryProvider.getStream,
      builder: (context, AsyncSnapshot<CategoryModel> snapshot) {
        return snapShotBuilder(
          snapshot: snapshot,
          widget: TabbedButtons(
            snapshot: snapshot,
            onSelectionUpdated: (index) async {
              await _productsProvider.getProducts(
                filter: ProductFilters.cat_prod,
                categoryId: index,
              );
              setState(
                () {
                  currentIndex = index;
                },
              );
            },
            selectedIndex: currentIndex,
          ),
        );
      },
    );
  }

  StreamBuilder<ProductsModel> productCardGridBuilder() {
    return StreamBuilder(
      stream: _productsProvider.getStream,
      builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
        if (snapshot.hasData) {
          return ProductCardGrid(
            snapshot: snapshot,
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  //TODO: create get most popular function in api
  StreamBuilder<ProductsModel> mostPopularstackedProductCardBuilder() {
    return StreamBuilder(
      stream: _productsProvider.getRecommndedProductsStream,
      builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
        return snapShotBuilder(
          snapshot: snapshot,
          widget: StackedProductCard(snapshot),
        );
      },
    );
  }

  StreamBuilder<AdsModel> adsBuilder({
    Function? function,
    bool hasFunction = false,
  }) {
    if (hasFunction) {
      function!();
    }
    return StreamBuilder(
      stream: _adsProvider.getStream,
      builder: (context, AsyncSnapshot<AdsModel> snapshot) {
        return snapShotBuilder(
          snapshot: snapshot,
          widget: AdsCard(snapshot),
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
          widget: ProductsCardHorizontal(snapshot),
        );
      },
    );
  }
}
