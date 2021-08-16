import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';
import 'package:virtual_ggroceries/view/widgets/producta_card_grid.dart';
import 'package:virtual_ggroceries/view/widgets/shimmers.dart';
import 'package:virtual_ggroceries/view/widgets/sign_in_promt.dart';
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
  bool isLoading = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    getWishList();
  }

  getWishList() async {
    //check if signed in
    setState(() => isLoading = true);
    var isLoggedIn = await _sp.isLoggedIn();
    if (isLoggedIn) {
      var userId = await _accountProvider.getUserId();
      await _productsProvider.getProducts(
        filter: ProductFilters.wish_list,
        userId: userId,
      );
      setState(() => isSignedIn = true);
    } else {
      setState(() => isSignedIn = false);
    }
    setState(() => isLoading = false);
  }

  Future<Null> _refresh() async {
    getWishList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: isLoading
          ? productCardGridShimmer()
          : isSignedIn
              ? wishListBuilder()
              : signInPromte(message: "Please sign in to view wishlist"),
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
            shimmer: productCardGridShimmer(),
            emptyMessage: "You have not added any item to wishlist",
            widget: ProductCardGrid(
              snapshot: snapshot.data,
              shouldScroll: false,
              isSaved: true,
            ),
          );
        },
      ),
    );
  }
}
