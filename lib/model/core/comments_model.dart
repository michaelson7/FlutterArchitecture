class CategoryModel {
  String _errorMessage = "";
  bool _hasError = false;
  int _size = 0;
  List<CommentsModelList> _commentModelList = [];

  CategoryModel.testJson(List<CommentsModelList> model) {
    for (int i = 0; i < model.length; i++) {
      _commentModelList.add(CommentsModelList(
        id: model[i].id,
        rating: model[i].rating,
        name: model[i].name,
        imgPath: model[i].imgPath,
        date: model[i].date,
        comment: model[i].comment,
      ));
    }
  }

  CategoryModel.fromJson(Map<String, dynamic> jsonResponse) {
    if (!jsonResponse['error']) {
      print("Account model added");
      _hasError = false;
      List<dynamic> results = jsonResponse["results"];

      for (int i = 0; i < results.length; i++) {
        _commentModelList.add(CommentsModelList(
          id: results[i]['Id'],
          name: results[i]['Id'],
          imgPath: results[i]['Id'],
          date: results[i]['Id'],
          comment: results[i]['Id'],
          rating: results[i]['Id'],
        ));
      }
    } else {
      _hasError = true;
      _errorMessage = jsonResponse['message'];
      print("Category model failed: $_errorMessage");
    }
  }

  int get size => _commentModelList.length;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<CommentsModelList> get commentModelList => _commentModelList;
}

class CommentsModelList {
  late final int id, rating;
  late final String name, imgPath, date, comment;

  CommentsModelList({
    required this.id,
    required this.rating,
    required this.name,
    required this.imgPath,
    required this.date,
    required this.comment,
  });
}
