import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/view/widgets/producta_card_grid.dart';
import 'package:virtual_ggroceries/view/widgets/snapshot_handler.dart';

class WishListFragment extends StatefulWidget {
  const WishListFragment({Key? key}) : super(key: key);

  @override
  _WishListFragmentState createState() => _WishListFragmentState();
}

class _WishListFragmentState extends State<WishListFragment> {
  ProductsProvider _productsProvider = ProductsProvider();

  void initProviders() async {
    await _productsProvider.getProducts();
  }

  @override
  void initState() {
    initProviders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
    );
  }
}