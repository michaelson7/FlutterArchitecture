import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';

class TestActivity extends StatefulWidget {
  static String id = "TestActivity";

  @override
  _TestActivityState createState() => _TestActivityState();
}

class _TestActivityState extends State<TestActivity> {
  var productsProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void> init() async {
    productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    await productsProvider.updatePaginatedList(
      filter: ProductFilters.all_products,
    );
    Logger logger = Logger();
    logger.i(productsProvider.getItemSize());
  }
}
