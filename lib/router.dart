import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:peanut/pages/account/accountPage.dart';
import 'package:peanut/pages/sharePage.dart';
import 'package:peanut/pages/webView.dart';
import 'package:peanut/pages/home/homePage.dart';
import 'package:peanut/pages/loginPage.dart';

enum PageName {
  accoutPage,
  sharePage,
  webViewPage,
  homePage,
  containerPage,
  loginPage
}

final Map<PageName, Handler> pageRoutes = {
  PageName.accoutPage: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return AccountPage();
  }),
  PageName.sharePage: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return SharePage();
  }),
  PageName.homePage: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return HomePage();
  }),
  PageName.loginPage: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return LoginPage();
  }),
  PageName.webViewPage: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String title = params['title']?.first;
    String url = params['url']?.first;
    return WebViewPage(url, title);
  }),
};

class PageRouter {
  final router = Router();

  PageRouter() {
    setupRoutes();
  }

  setupRoutes() {
    pageRoutes.forEach((path, handler) {
      router.define(path.toString(), handler: handler, transitionType: TransitionType.inFromRight);
    });
  }

  pushNoParams(BuildContext context, PageName pageName) {
    router.navigateTo(context, '$pageName', transition: TransitionType.fadeIn);
  }

  push(BuildContext context, PageName pageName, dynamic params) {
    var path = pageName.toString() + '?';
    if (params is Map) {
      params.forEach( (key, val)  => path += '$key=$val&');
    }
    router.navigateTo(context, path, transition: TransitionType.nativeModal);
  }
}
