import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtual_ggroceries/model/core/ads_model.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/helper/api_helper.dart';

class CartProvider extends ChangeNotifier {
  List<ProductsModelList> _list = [];
  List<ProductsModelList> get list => _list;

  bool addToCart(ProductsModelList model) {
    try {
      _list.add(model);
      notifyListeners();
      print('Added ${model.name} to cart ${getItemSize()}');
      return true;
    } catch (e) {
      print('Error while adding to cart: $e');
      return false;
    }
  }

  bool removeFromCart(int id) {
    try {
      _list.removeAt(id);
      notifyListeners();
      print('${_list[id].name} removed');
      return true;
    } catch (e) {
      print('Error while removing cart: $e');
      return false;
    }
  }

  int getItemSize() {
    return _list.length;
  }

  bool hasData() {
    if (_list.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  int getTotalCost() {
    int cost = 0;
    for (var data in _list) {
      var price = data.price;
      cost += price;
    }
    return cost;
  }
}
