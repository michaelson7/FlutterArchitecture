class CategoryModel {
  String _errorMessage = "";
  bool _hasError = false;
  int _size = 0;
  List<CategoryModelList> _categoryModelList = [];

  CategoryModel.testJson(List<CategoryModelList> model) {
    for (int i = 0; i < model.length; i++) {
      _categoryModelList.add(CategoryModelList(
        id: model[i].id,
        name: model[i].name,
        imgPath: model[i].imgPath,
      ));
    }
  }

  CategoryModel.fromJson(Map<String, dynamic> jsonResponse) {
    if (!jsonResponse['error']) {
      print("Account model added");
      _hasError = false;
      List<dynamic> results = jsonResponse["results"];

      for (int i = 0; i < results.length; i++) {
        _categoryModelList.add(CategoryModelList(
          id: results[i]['Id'],
          name: results[i]['Id'],
          imgPath: results[i]['Id'],
        ));
      }
    } else {
      _hasError = true;
      _errorMessage = jsonResponse['message'];
      print("Category model failed: $_errorMessage");
    }
  }

  int get size => _categoryModelList.length;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<CategoryModelList> get categoryModelList => _categoryModelList;
}

class CategoryModelList {
  late final int id;
  late final String name, imgPath;

  CategoryModelList({
    required this.id,
    required this.name,
    required this.imgPath,
  });
}
