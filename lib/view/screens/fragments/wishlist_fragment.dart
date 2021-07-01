import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';
import 'package:virtual_ggroceries/view/widgets/producta_card_grid.dart';
import 'package:virtual_ggroceries/view/widgets/snapshot_handler.dart';

class WishListFragment extends StatefulWidget {
  const WishListFragment({Key? key}) : super(key: key);

  @override
  _WishListFragmentState createState() => _WishListFragmentState();
}

class _WishListFragmentState extends State<WishListFragment> {
  ProductsProvider _productsProvider = ProductsProvider();
  AccountProvider _accountProvider = AccountProvider();
  bool isSignedIn = false;
  int? userId;

  getWishList() async {
    var userId = await _accountProvider.getUserId();
    await _productsProvider.getProducts(
      filter: ProductFilters.wish_list,
      userId: userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    getWishList();
    return StreamBuilder(
      stream: _productsProvider.getWishListProductsStream,
      builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
        if (snapshot.hasData) {
          return ProductCardGrid(
            snapshot: snapshot,
            shouldScroll: false,
          );
        } else if (!snapshot.hasData) {
          return Text('No data');
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
          child: Text('loading stream'),
        );
      },
    );
  }

  Widget wishListProducts() {
    return FutureBuilder(
      future: getWishList(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return streamList();
        } else if (!snapshot.hasData) {
          return Center(
            child: Text('No data in future'),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
          child: Text('loading wishlist Future'),
        );
      },
    );
  }

  StreamBuilder<ProductsModel> streamList() {
    return StreamBuilder(
      stream: _productsProvider.getWishListProductsStream,
      builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
        if (snapshot.hasData) {
          return ProductCardGrid(
            isSaved: true,
            snapshot: snapshot,
            shouldScroll: false,
          );
        } else if (!snapshot.hasData) {
          return Text('No data');
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
          child: Text('loading stream'),
        );
      },
    );
  }

  Widget signInPromte() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.verified_user,
            size: 100,
            color: kAccentColor,
          ),
          SizedBox(height: 10),
          Text(
            "Please sign in to view wishlist",
            style: kTextStyleFaint,
          ),
        ],
      ),
    );
  }
}
