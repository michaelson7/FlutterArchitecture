import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:logger/logger.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/core/sub_categories_model.dart';
import 'package:virtual_ggroceries/provider/category_provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/provider/sub_category_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';
import 'package:virtual_ggroceries/view/screens/activities/testActivity.dart';
import 'package:virtual_ggroceries/view/widgets/empty_handler.dart';
import 'package:virtual_ggroceries/view/widgets/producta_card_grid.dart';
import 'package:virtual_ggroceries/view/widgets/shimmers.dart';
import 'package:virtual_ggroceries/view/widgets/slide_show_widget.dart';
import 'package:virtual_ggroceries/view/widgets/snapshot_handler.dart';
import 'package:virtual_ggroceries/view/widgets/tabbed_buttons.dart';

import '../../constants/constants.dart';

class CategoryProducts extends StatefulWidget {
  final CategoryModelList _categoryModel;
  CategoryProducts(this._categoryModel);

  @override
  _CategoryProductsState createState() =>
      _CategoryProductsState(_categoryModel);
}

class _CategoryProductsState extends State<CategoryProducts> {
  final CategoryModelList _categoryModel;
  bool isLoading = false, loadMore = false;
  SubCategoryProvider _categoryProvider = SubCategoryProvider();
  Logger logger = Logger();
  int currentIndex = 0;
  int streamIndex = 0;
  int page = 1;
  bool fetchSubCategories = false;
  ProductsProvider _productsProvider = ProductsProvider();

  _CategoryProductsState(this._categoryModel);

  void initProviders() async {
    setState(() {
      isLoading = true;
      fetchSubCategories = false;
    });
    await _categoryProvider.getSubCategories(
      categoryId: _categoryModel.id,
    );
    await _productsProvider.getProducts(
      filter: ProductFilters.cat_prod,
      categoryId: _categoryModel.id,
    );
    setState(() => isLoading = false);
  }

  Future _loadMoreVertical() async {
    page++;
    setState(() => loadMore = true);
    fetchSubCategories
        ? await _productsProvider.updatePaginatedList(
            filter: ProductFilters.subProducts,
            subCategoryId: currentIndex,
            page: page)
        : await _productsProvider.updatePaginatedList(
            filter: ProductFilters.cat_prod,
            categoryId: _categoryModel.id,
            page: page);
    setState(() => loadMore = false);
  }

  resetPage() {
    page = 1;
  }

  @override
  void dispose() {
    super.dispose();
    _productsProvider.dispose();
    _categoryProvider.dispose();
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
        body: LazyLoadScrollView(
          isLoading: loadMore,
          onEndOfPage: () => _loadMoreVertical(),
          child: StreamBuilder(
            stream: _productsProvider.getCategoryProductsStream,
            builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
              if (snapshot.hasData) {
                return mainInterface(
                  categoryModel: _categoryModel,
                  snapshot: snapshot,
                );
              }
              return productShimmerLayout();
            },
          ),
        ),
      ),
    );
  }

  mainInterface({
    required CategoryModelList categoryModel,
    required AsyncSnapshot<ProductsModel> snapshot,
  }) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 350.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(categoryModel.title),
            background: SlideShowWidget(snapshot: snapshot),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 15),
                Container(
                  child: tabbedCategoryProducts(),
                ),
                SizedBox(height: 15),
                Container(
                  child: productsGridBuilder(),
                ),
                loadMore
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ],
    );
  }

  StreamBuilder<SubCategoryModel> tabbedCategoryProducts() {
    return StreamBuilder(
      stream: _categoryProvider.getStream,
      builder: (
        context,
        AsyncSnapshot<SubCategoryModel> snapshot,
      ) {
        return snapShotBuilder(
          snapshot: snapshot,
          shimmer: tabbedButtonShimmer(),
          widget: TabbedButtons(
            snapshot: snapshot,
            onSelectionUpdated: (index) async {
              setState(
                () {
                  fetchSubCategories = true;
                  currentIndex = index;
                  isLoading = true;
                },
              );
              _productsProvider.clearProductList();
              resetPage();
              await _productsProvider.getProducts(
                filter: ProductFilters.subProducts,
                subCategoryId: currentIndex,
              );
              setState(
                () {
                  isLoading = false;
                },
              );
            },
            selectedIndex: currentIndex,
          ),
        );
      },
    );
  }

  Widget productsGridBuilder() {
    return isLoading
        ? productCardGridShimmer()
        : StreamBuilder(
            stream: fetchSubCategories
                ? _productsProvider.getSubCategoryProductsStream
                : _productsProvider.getCategoryProductsStream,
            builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
              fetchSubCategories = false;
              isLoading = false;
              return snapShotBuilder(
                snapshot: snapshot,
                shimmer: productCardGridShimmer(),
                widget: ProductCardGrid(
                  snapshot: snapshot.data,
                  shouldScroll: false,
                ),
              );
            },
          );
  }
}
