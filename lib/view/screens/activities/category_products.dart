import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/provider/category_provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';

class CategoryProducts extends StatefulWidget {
  final int categoryId;
  CategoryProducts({required this.categoryId});

  @override
  _CategoryProductsState createState() => _CategoryProductsState(categoryId);
}

class _CategoryProductsState extends State<CategoryProducts> {
  CategoryProvider _categoryProvider = CategoryProvider();
  ProductsProvider _productsProvider = ProductsProvider();
  int currentIndex = 0;
  final int categoryId;

  _CategoryProductsState(this.categoryId);

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
      appBar: AppBar(
        title: Text('Product Name $categoryId'),
      ),
    );
  }
}
