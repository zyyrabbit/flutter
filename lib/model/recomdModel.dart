import 'package:flutter/foundation.dart';
import 'package:peanut/bean/articleBean.dart';

class recomdModel extends ChangeNotifier {
  
  final List<ArticleBean> _items = [];

  get items => _items;

  void add(ArticleBean item) {
    _items.add(item);
    notifyListeners();
  }
  
}