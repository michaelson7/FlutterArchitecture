class AdsModel {
  String _errorMessage = "";
  bool _hasError = false;
  int _size = 0;
  List<AdsModelList> _adsModelList = [];

  AdsModel.testJson(List<AdsModelList> model) {
    for (int i = 0; i < model.length; i++) {
      _adsModelList.add(AdsModelList(
        adsId: model[i].adsId,
        productId: model[i].productId,
        header: model[i].header,
        subHeader: model[i].subHeader,
        imgPath: model[i].imgPath,
      ));
    }
  }

  AdsModel.fromJson(Map<String, dynamic> jsonResponse) {
    if (!jsonResponse['error']) {
      print("Account model added");
      _hasError = false;
      List<dynamic> results = jsonResponse["results"];

      for (int i = 0; i < results.length; i++) {
        _adsModelList.add(
          AdsModelList(
            adsId: results[i]['Id'],
            productId: results[i]['Id'],
            header: results[i]['Id'],
            subHeader: results[i]['Id'],
            imgPath: results[i]['Id'],
          ),
        );
      }
    } else {
      _hasError = true;
      _errorMessage = jsonResponse['message'];
      print("Category model failed: $_errorMessage");
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
    required this.subHeader,
    required this.imgPath,
  });
}
