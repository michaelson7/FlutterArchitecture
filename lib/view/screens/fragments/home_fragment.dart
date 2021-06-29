import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
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
  Future? interface;
  var buileme;

  @override
  void initState() {
    initProviders();
    setState(() {
      isLoading = true;
    });
    super.initState();
  }

  void initProviders() async {
    await _categoryProvider.getCategories();
    await _productsProvider.getProducts();
    await _productsProvider.getProducts(filter: ProductFilters.new_arrival);
    await _adsProvider.getAds();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        categoryBuilder(),
        productsBuilder(
          stream: _productsProvider.getAllProductsStream,
        ),
        adsBuilder(),
        productsBuilder(
          stream: _productsProvider.getNewProductsStream,
        ),
        productCardGridBuilder(),
        stackedProductCardBuilder(),
      ]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          var categorySnapshot = snapshot.data[0];
          var productsAllSnapshot = snapshot.data[1];
          var adsSnapshot = snapshot.data[2];
          var productsNewSnapshot = snapshot.data[3];
          var productGridSnapshot = snapshot.data[4];
          var stackedProduct = snapshot.data[5];

          return mainInterface(
              context,
              categorySnapshot,
              productsAllSnapshot,
              adsSnapshot,
              productsNewSnapshot,
              stackedProduct,
              productGridSnapshot);
        } else if (snapshot.hasError) {
          print('home_frag interface error: ${snapshot.error}');
          return Center(child: Text('hasNoData'));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  ModalProgressHUD mainInterface(
      BuildContext context,
      categorySnapshot,
      productsAllSnapshot,
      adsSnapshot,
      productsNewSnapshot,
      stackedProduct,
      productGridSnapshot) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      opacity: 1,
      progressIndicator: CircularProgressIndicator(),
      color: kScaffoldColor,
      child: SingleChildScrollView(
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
              child: categorySnapshot,
            ),
            SizedBox(height: 15),
            //horizontalCardView
            Container(
              child: productsAllSnapshot,
            ),
            SizedBox(height: 15),
            //adsCard
            Container(
              child: adsSnapshot,
            ),
            SizedBox(height: 15),
            //horizontalCardView
            Text(
              'Recommended',
              style: kTextStyleSubHeader,
            ),
            Container(
              child: productsNewSnapshot,
            ),
            SizedBox(height: 15),
            //adsCard
            Container(
              child: adsSnapshot,
            ),
            SizedBox(height: 15),
            //horizontalCardView
            Text(
              'New Arrivals',
              style: kTextStyleSubHeader,
            ),
            Container(
              child: productsNewSnapshot,
            ),
            SizedBox(height: 15),
            //stacked product card
            Text(
              'Most Popular',
              style: kTextStyleSubHeader,
            ),
            Container(
              child: stackedProduct,
            ),
            SizedBox(height: 15),
            //ProductGrid
            Text(
              'All Products',
              style: kTextStyleSubHeader,
            ),
            Container(
              child: productGridSnapshot,
            ),
          ],
        ),
      ),
    );
  }

  Future<StreamBuilder<ProductsModel>> productCardGridBuilder() async {
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

  Future<StreamBuilder<ProductsModel>> stackedProductCardBuilder() async {
    return StreamBuilder(
      stream: _productsProvider.getStream,
      builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
        return snapShotBuilder(
          snapshot: snapshot,
          widget: StackedProductCard(snapshot),
        );
      },
    );
  }

  Future<StreamBuilder<AdsModel>> adsBuilder() async {
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

  Future<StreamBuilder<ProductsModel>> productsBuilder(
      {required var stream}) async {
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

  Future<StreamBuilder<CategoryModel>> categoryBuilder() async {
    return StreamBuilder(
      stream: _categoryProvider.getStream,
      builder: (context, AsyncSnapshot<CategoryModel> snapshot) {
        return snapShotBuilder(
          snapshot: snapshot,
          widget: TabbedButtons(
            snapshot: snapshot,
            onSelectionUpdated: (index) async {
              await _productsProvider.refreshProducts();
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
}
