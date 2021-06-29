class CategoryModel {
  String _errorMessage = "";
  bool _hasError = false;
  int _size = 0;
  List<CategoryModelList> _categoryModelList = [];

  CategoryModel.testJson(List<CategoryModelList> model) {
    for (int i = 0; i < model.length; i++) {
      _categoryModelList.add(CategoryModelList(
        id: model[i].id,
        title: model[i].title,
        imgPath: model[i].imgPath,
      ));
    }
  }

  CategoryModel.fromJson(Map<String, dynamic> jsonResponse) {
    _hasError = false;
    List<dynamic> results = jsonResponse["results"];

    for (int i = 0; i < results.length; i++) {
      _categoryModelList.add(CategoryModelList(
        id: results[i]['prod_cat_id'],
        title: results[i]['name'],
        imgPath: results[i]['img_path'],
      ));
    }
  }

  int get size => _categoryModelList.length;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<CategoryModelList> get categoryModelList => _categoryModelList;
}

class CategoryModelList {
  late final int id;
  late final String title, imgPath;

  CategoryModelList({
    required this.id,
    required this.title,
    required this.imgPath,
  });
}
