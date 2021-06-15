import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/provider/category_provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/widgets/dark_img_widget.dart';
import 'package:virtual_ggroceries/view/widgets/slide_show_widget.dart';
import 'package:virtual_ggroceries/view/widgets/snapshot_handler.dart';

class CategoryProducts extends StatefulWidget {
  final CategoryModelList _categoryModel;
  CategoryProducts(this._categoryModel);

  @override
  _CategoryProductsState createState() =>
      _CategoryProductsState(_categoryModel);
}

class _CategoryProductsState extends State<CategoryProducts> {
  final CategoryModelList _categoryModel;
  CategoryProvider _categoryProvider = CategoryProvider();
  ProductsProvider _productsProvider = ProductsProvider();
  int currentIndex = 0;
  int streamIndex = 0;

  _CategoryProductsState(this._categoryModel);

  void initProviders() async {
    await _categoryProvider.getCategories();
    await _productsProvider.getProducts();
  }

  @override
  void initState() {
    initProviders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _productsProvider.getStream,
        builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
          return snapShotBuilder(
            snapshot: snapshot,
            widget: MainInterface(
              categoryModel: _categoryModel,
              snapshot: snapshot,
            ),
          );
        },
      ),
    );
  }
}

class MainInterface extends StatelessWidget {
  const MainInterface({
    Key? key,
    required CategoryModelList categoryModel,
    required this.snapshot,
  })  : _categoryModel = categoryModel,
        super(key: key);

  final CategoryModelList _categoryModel;
  final AsyncSnapshot<ProductsModel> snapshot;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 350.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(_categoryModel.name),
            background: SlideShowWidget(snapshot: snapshot),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  'ZMW ',
                  style: TextStyle(color: kAccentColor),
                ),
                SizedBox(height: 10),
                Text(
                  'Availability: ',
                ),
                SizedBox(height: 15),
                Text(
                  'vsdvsdv',
                  style: kTextStyleFaint,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Add To Cart',
                        style: kTextStyleSubHeader,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
