class AdsModel {
  String _errorMessage = "";
  bool _hasError = false;
  int _size = 0;
  List<AdsModelList> _adsModelList = [];

  AdsModel.fromJson(Map<String, dynamic> jsonResponse) {
    _hasError = false;
    List<dynamic> results = jsonResponse["results"];

    for (int i = 0; i < results.length; i++) {
      _adsModelList.add(
        AdsModelList(
          adsId: results[i]['ads_id'],
          productId: results[i]['prod_id'],
          header: results[i]['header'],
          imgPath: results[i]['img_path'],
        ),
      );
    }
  }

  int get size => _adsModelList.length;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<AdsModelList> get adsModelList => _adsModelList;
}

class AdsModelList {
  late final int adsId, productId;
  late final String header, subHeader, imgPath;

  AdsModelList({
    required this.adsId,
    required this.productId,
    required this.header,
    this.subHeader = '',
    required this.imgPath,
  });
}
