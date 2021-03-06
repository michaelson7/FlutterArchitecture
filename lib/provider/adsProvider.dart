import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtual_ggroceries/model/core/ads_model.dart';
import 'package:virtual_ggroceries/model/helper/api_helper.dart';

class AdsProvider extends ChangeNotifier {
  final _apiHelper = ApiHelper();
  final _streamController = BehaviorSubject<AdsModel>();

  Stream<AdsModel> get getStream {
    return _streamController.stream;
  }

  Future<void> getAds({int page = 1}) async {
    var helperResult = await _apiHelper.getAds(page: 1);
    _streamController.add(helperResult);
  }
}
