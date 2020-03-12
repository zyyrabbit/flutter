
import 'package:flutter/foundation.dart';
import 'package:peanut/bean/userInforBean.dart';

class GlobalModel extends ChangeNotifier {
  UserInforBean _userInfor;
  bool _hasLogin;
  List<Map<String, dynamic>> _storeArticles = [];

  GlobalModel(userInfor, hasLogin, storeArticles);

  UserInforBean get userInfor => _userInfor;
  bool get hasLogin => _hasLogin;
  List<Map<String, dynamic>> get storeArticles => _storeArticles;

  void set(UserInforBean userInfor,  bool hasLogin, List<Map<String, dynamic>> storeArticles) {
    _userInfor = userInfor;
    _hasLogin = hasLogin;
    _storeArticles.clear();
    _storeArticles.addAll(storeArticles);
    notifyListeners();
  }

  void setStoreArticles(List<Map<String, dynamic>> storeArticles) {
     _storeArticles.clear();
    _storeArticles.addAll(storeArticles);
  }
}
