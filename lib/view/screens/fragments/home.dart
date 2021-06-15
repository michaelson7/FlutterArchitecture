import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/ads_model.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/provider/adsProvider.dart';
import 'package:virtual_ggroceries/provider/category_provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/widgets/ads_card.dart';
import 'package:virtual_ggroceries/view/widgets/max.dart';
import 'package:virtual_ggroceries/view/widgets/producta_card_grid.dart';
import 'package:virtual_ggroceries/view/widgets/products_card_horizontal.dart';
import 'package:virtual_ggroceries/view/widgets/snapshot_handler.dart';
import 'package:virtual_ggroceries/view/widgets/stacked_product_card.dart';
import 'package:virtual_ggroceries/view/widgets/tabbed_buttons.dart';

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

  void initProviders() async {
    await _categoryProvider.getCategories();
    await _productsProvider.getProducts();
    await _adsProvider.getAds();
  }

  @override
  void initState() {
    initProviders();
    super.initState();
  }

  @override
  void dispose() {
    _categoryProvider.endStream();
    _productsProvider.endStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: buildSingleChildScrollView(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        print(snapshot.connectionState);
        if (snapshot.hasData) {
          return snapshot.data;
        } else if (snapshot.hasError) {
          return Center(child: Text('hasNoData'));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<SingleChildScrollView> buildSingleChildScrollView() async {
    return SingleChildScrollView(
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
            color: kDarkCardBackground,
            child: InkWell(
              onTap: () {},
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
            child: StreamBuilder(
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
            ),
          ),
          SizedBox(height: 15),
          //horizontalCardView
          Container(
            child: StreamBuilder(
              stream: _productsProvider.getStream,
              builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
                return snapShotBuilder(
                  snapshot: snapshot,
                  widget: ProductsCardHorizontal(snapshot),
                );
              },
            ),
          ),
          SizedBox(height: 15),
          //adsCard
          Container(
            child: StreamBuilder(
              stream: _adsProvider.getStream,
              builder: (context, AsyncSnapshot<AdsModel> snapshot) {
                return snapShotBuilder(
                  snapshot: snapshot,
                  widget: AdsCard(snapshot),
                );
              },
            ),
          ),
          SizedBox(height: 15),
          //horizontalCardView
          Text(
            'Recommended',
            style: kTextStyleSubHeader,
          ),
          Container(
            child: StreamBuilder(
              stream: _productsProvider.getStream,
              builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
                return snapShotBuilder(
                  snapshot: snapshot,
                  widget: ProductsCardHorizontal(snapshot),
                );
              },
            ),
          ),
          SizedBox(height: 15),
          //adsCard
          Container(
            child: StreamBuilder(
              stream: _adsProvider.getStream,
              builder: (context, AsyncSnapshot<AdsModel> snapshot) {
                return snapShotBuilder(
                  snapshot: snapshot,
                  widget: AdsCard(snapshot),
                );
              },
            ),
          ),
          SizedBox(height: 15),
          //horizontalCardView
          Text(
            'New Arrivals',
            style: kTextStyleSubHeader,
          ),
          Container(
            child: StreamBuilder(
              stream: _productsProvider.getStream,
              builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
                return snapShotBuilder(
                  snapshot: snapshot,
                  widget: ProductsCardHorizontal(snapshot),
                );
              },
            ),
          ),
          SizedBox(height: 15),
          //stacked product card
          Text(
            'Most Popular',
            style: kTextStyleSubHeader,
          ),
          Container(
            child: StreamBuilder(
              stream: _productsProvider.getStream,
              builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
                return snapShotBuilder(
                  snapshot: snapshot,
                  widget: StackedProductCard(snapshot),
                );
              },
            ),
          ),
          SizedBox(height: 15),
          //ProductGrid
          Text(
            'All Products',
            style: kTextStyleSubHeader,
          ),
          Container(
            child: StreamBuilder(
              stream: _productsProvider.getStream,
              builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
                return snapShotBuilder(
                  snapshot: snapshot,
                  widget: ProductCardGrid(
                    snapshot: snapshot,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
    showHelloWorld();
  }

  void showHelloWorld() {
    // showDialog(
    //   context: context,
    //   builder: (context) => new AlertDialog(
    //     content: new Text('Hello World'),
    //     actions: <Widget>[
    //       new FlatButton(
    //         child: new Text('DISMISS'),
    //         onPressed: () => Navigator.of(context).pop(),
    //       )
    //     ],
    //   ),
    // );
  }
}
