class SubCategoryModel {
  String _errorMessage = "";
  bool _hasError = false;
  int _size = 0;
  List<SubCategoryModelList> _categoryModelList = [];

  SubCategoryModel.fromJson(Map<String, dynamic> jsonResponse) {
    _hasError = false;
    List<dynamic> results = jsonResponse["results"];

    for (int i = 0; i < results.length; i++) {
      _categoryModelList.add(SubCategoryModelList(
        id: results[i]['SubCategoryId'],
        title: results[i]['Title'],
        imgPath: results[i]['ImgPath'],
        categoryId: results[i]['CategoryId'],
      ));
    }
  }

  int get size => _categoryModelList.length;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<SubCategoryModelList> get categoryModelList => _categoryModelList;
}

class SubCategoryModelList {
  late final int id, categoryId;
  late final String title, imgPath;

  SubCategoryModelList({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.imgPath,
  });
}
