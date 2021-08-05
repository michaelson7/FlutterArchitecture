import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';
import 'package:virtual_ggroceries/view/widgets/producta_card_grid.dart';
import 'package:virtual_ggroceries/view/widgets/snapshot_handler.dart';

import '../../../provider/shared_pereferences_provider.dart';
import '../../widgets/snapshot_handler.dart';

class WishListFragment extends StatefulWidget {
  const WishListFragment({Key? key}) : super(key: key);

  @override
  _WishListFragmentState createState() => _WishListFragmentState();
}

class _WishListFragmentState extends State<WishListFragment>
    with AutomaticKeepAliveClientMixin<WishListFragment> {
  @override
  bool get wantKeepAlive => false;

  var logger = Logger();
  ProductsProvider _productsProvider = ProductsProvider();
  AccountProvider _accountProvider = AccountProvider();
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  bool isSignedIn = false;
  int? userId;

  @override
  void initState() {
    getWishList();
    super.initState();
  }

  getWishList() async {
    //check if signed in
    var isLoggedIn = await _sp.isLoggedIn();
    if (isLoggedIn) {
      logger.i('IS SIGNED IN');
      var userId = await _accountProvider.getUserId();
      await _productsProvider.getProducts(
        filter: ProductFilters.wish_list,
        userId: userId,
      );
    } else {
      logger.e('IS NOT SIGNED IN');
    }
    isSignedIn = isLoggedIn;
  }

  Future<Null> _refresh() async {
    getWishList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: isSignedIn ? wishListBuilder() : signInPromte(),
    );
  }

  Widget wishListBuilder() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: StreamBuilder(
        stream: _productsProvider.getWishListProductsStream,
        builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
          return snapShotBuilder(
            snapshot: snapshot,
            widget: ProductCardGrid(
              snapshot: snapshot,
              shouldScroll: false,
            ),
          );
        },
      ),
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
