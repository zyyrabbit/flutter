import 'package:flutter/material.dart';
import 'package:peanut/pages/detail/detailPage.dart';
import 'package:peanut/pages/sharePage.dart';
///https://www.jianshu.com/p/b9d6ec92926f

class Router {
  static const detailPage = '/detailPage';
  static const sharePage = '/sharePage';

  Widget _getPage(String url, dynamic params) {
      switch (url) {
        case detailPage:
          return DetailPage();
        case sharePage:
          return SharePage();
      }
    return null;
  }

  pushNoParams(BuildContext context, String url) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return _getPage(url, null);
    }));
  }

  push(BuildContext context, String url, dynamic params) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return _getPage(url, params);
    }));
  }
}
