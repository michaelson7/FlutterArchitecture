import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
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
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return buildFoodShimmer();
        },
      ),
    );
  }

  Widget buildFoodShimmer() {
    return ListTile(
      leading: ShimmerWidget.circular(height: 16),
      title: ShimmerWidget.rectangle(height: 16),
      subtitle: ShimmerWidget.rectangle(height: 14),
    );
  }

  StreamBuilder<ProductsModel> layout() {
    return StreamBuilder(
      stream: _productsProvider.getStream,
      builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
        if (snapshot.hasData) {
          return ProductCardGrid(
            snapshot: snapshot,
            shouldScroll: false,
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
          child: shimmerBuilder(),
        );
      },
    );
  }

  Shimmer shimmerBuilder() {
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.grey,
      child: Container(width: 80, height: 16, color: Colors.grey),
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  final width;
  final height;
  final ShapeBorder shapeBorder;

  ShimmerWidget.rectangle({
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const RoundedRectangleBorder(),
  });

  ShimmerWidget.circular({
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.grey[300]!,
      baseColor: Colors.black,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey[400]!,
          shape: shapeBorder,
        ),
      ),
    );
  }
}
