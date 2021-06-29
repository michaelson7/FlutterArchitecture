import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/model/core/sub_categories_model.dart';
import 'package:virtual_ggroceries/model/helper/api_helper.dart';

class SubCategoryProvider extends ChangeNotifier {
  final _apiHelper = ApiHelper();
  final _streamController = BehaviorSubject<SubCategoryModel>();

  Stream<SubCategoryModel> get getStream {
    return _streamController.stream;
  }

  Future<void> getSubCategories({required int categoryId}) async {
    var helperResult =
        await _apiHelper.getSubCategories(categoryId: categoryId);
    _streamController.add(helperResult);
  }

  void endStream() {
    _streamController.close();
  }
}
