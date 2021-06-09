class SharedPreferenceModel {
  late String _userId, _userName, _userEmail;

  SharedPreferenceModel() {
    _userId = "userId";
    _userName = "userName";
    _userEmail = "userEmail";
  }

  get userEmail => _userEmail;

  get userName => _userName;

  String get userId => _userId;
}
