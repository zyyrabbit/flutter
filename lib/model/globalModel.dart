
import 'package:flutter/foundation.dart';
import 'package:peanut/bean/userInforBean.dart';

class GlobalModel extends ChangeNotifier {
  UserInforBean _userInfor;
  bool _hasLogin;

  GlobalModel(userInfor, hasLogin);

  get userInfor => _userInfor;
  get hasLogin => _hasLogin;

  void set(UserInforBean userInfor,  bool hasLogin) {
    _userInfor = userInfor;
    _hasLogin = hasLogin;
    notifyListeners();
  }
}
