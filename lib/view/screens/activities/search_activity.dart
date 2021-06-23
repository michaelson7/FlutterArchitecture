import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/widgets/padded_container.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:virtual_ggroceries/view/widgets/producta_card_grid.dart';
import 'package:virtual_ggroceries/view/widgets/snapshot_handler.dart';

class SearchActivity extends StatefulWidget {
  static final String id = 'SearchActivity';
  const SearchActivity({Key? key}) : super(key: key);

  @override
  _SearchActivityState createState() => _SearchActivityState();
}

class _SearchActivityState extends State<SearchActivity> {
  ProductsProvider _productsProvider = ProductsProvider();
  late SearchBar searchBar;
  bool isSearching = false;
  String _toolbarSearchTerm = 'Search Bar Demo';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _SearchActivityState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text(_toolbarSearchTerm),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    setState(() {
      isSearching = true;
      _productsProvider.searchForProduct(searchTerm: value);
      _toolbarSearchTerm = '$value...';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: searchBar.build(context),
        key: _scaffoldKey,
        body: SafeArea(child: isSearching ? productInterface() : searchPromt()),
      ),
    );
  }

  Widget productInterface() {
    return Container(
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
    );
  }

  Widget searchPromt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 100,
          ),
          SizedBox(height: 10),
          Text(
            "Search for products here",
            style: kTextStyleFaint,
          ),
        ],
      ),
    );
  }
}

// PaddedContainer(
// child: ListTile(
// leading: Icon(Icons.search),
// title: TextField(
// autofocus: true,
// decoration: InputDecoration(
// hintText: 'Search for any products...',
// border: InputBorder.none,
// ),
// ),
// ),
// )
