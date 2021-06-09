import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/model/helper/api_helper.dart';

class CategoryProvider extends ChangeNotifier {
  final _apiHelper = ApiHelper();
  final _streamController = BehaviorSubject<CategoryModel>();

  Stream<CategoryModel> get getStream {
    return _streamController.stream;
  }

  Future<void> getCategories() async {
    var helperResult = await _apiHelper.getCategories();
    _streamController.add(helperResult);
  }

  void endStream() {
    _streamController.close();
  }
}
