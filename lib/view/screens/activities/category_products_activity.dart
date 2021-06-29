import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/core/sub_categories_model.dart';
import 'package:virtual_ggroceries/provider/category_provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/provider/sub_category_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';
import 'package:virtual_ggroceries/view/widgets/producta_card_grid.dart';
import 'package:virtual_ggroceries/view/widgets/slide_show_widget.dart';
import 'package:virtual_ggroceries/view/widgets/snapshot_handler.dart';
import 'package:virtual_ggroceries/view/widgets/tabbed_buttons.dart';

SubCategoryProvider _categoryProvider = SubCategoryProvider();
ProductsProvider _productsProvider = ProductsProvider();
int currentIndex = 0;
int streamIndex = 0;
bool isLoaded = false;

class CategoryProducts extends StatefulWidget {
  final CategoryModelList _categoryModel;
  CategoryProducts(this._categoryModel);

  @override
  _CategoryProductsState createState() =>
      _CategoryProductsState(_categoryModel);
}

class _CategoryProductsState extends State<CategoryProducts> {
  final CategoryModelList _categoryModel;

  _CategoryProductsState(this._categoryModel);

  void initProviders() async {
    await _productsProvider.getProducts(
        filter: ProductFilters.cat_prod, categoryId: _categoryModel.id);
    await _categoryProvider.getSubCategories(categoryId: _categoryModel.id);
  }

  @override
  void initState() {
    initProviders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: _productsProvider.getCategoryProductsStream,
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
      ),
    );
  }
}

class MainInterface extends StatefulWidget {
  const MainInterface({
    Key? key,
    required CategoryModelList categoryModel,
    required this.snapshot,
  })   : _categoryModel = categoryModel,
        super(key: key);

  final CategoryModelList _categoryModel;
  final AsyncSnapshot<ProductsModel> snapshot;

  @override
  _MainInterfaceState createState() => _MainInterfaceState();
}

class _MainInterfaceState extends State<MainInterface> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 400.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(widget._categoryModel.title),
            background: SlideShowWidget(snapshot: widget.snapshot),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Container(
                  child: StreamBuilder(
                    stream: _categoryProvider.getStream,
                    builder:
                        (context, AsyncSnapshot<SubCategoryModel> snapshot) {
                      return snapShotBuilder(
                        snapshot: snapshot,
                        widget: TabbedButtons(
                          snapshot: snapshot,
                          onSelectionUpdated: (index) async {
                            print(index.toString());
                            await _productsProvider.getProducts(
                              filter: ProductFilters.subProducts,
                              subCategoryId: currentIndex,
                            );
                            setState(
                              () {
                                isLoaded = true;
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
                Container(
                  child: StreamBuilder(
                    stream: isLoaded
                        ? _productsProvider.getSubCategoryProductsStream
                        : _productsProvider.getCategoryProductsStream,
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
          ),
        ),
      ],
    );
  }
}
