import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:peanut/pages/account/accountPage.dart';
import 'package:peanut/pages/account/publishPage.dart';
import 'package:peanut/pages/account/storePage.dart';
import 'package:peanut/pages/webView.dart';
import 'package:peanut/pages/home/homePage.dart';
import 'package:peanut/pages/loginPage.dart';
import 'package:peanut/pages/containerPage.dart';


enum PageName {
  accoutPage,
  webViewPage,
  homePage,
  containerPage,
  loginPage,
  publishPage,
  storePage
}

final Map<PageName, Handler> pageRoutes = {
  PageName.accoutPage: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return AccountPage();
  }),
  PageName.homePage: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return HomePage();
  }),
  PageName.loginPage: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return LoginPage();
  }),
  PageName.containerPage: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    int index = 0;
    if (params['index'] != null) {
      index = int.parse(params['index']?.first);
    }
    return ContainerPage(index: index);
  }),
  PageName.publishPage: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return PublishPage();
  }),
  PageName.storePage: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return StorePage();
  }),
  PageName.webViewPage: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String title = params['title']?.first;
    String url = params['url']?.first;
    String btn = params['btn']?.first;
    return WebViewPage(url, title, btn: btn);
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

  pushNoParams(BuildContext context, PageName pageName, { bool clearStack  = false}) {
    router.navigateTo(context, '$pageName', transition: TransitionType.fadeIn, clearStack : clearStack);
  }

  

  push(BuildContext context, PageName pageName, dynamic params, {bool clearStack = false}) {
    var path = pageName.toString() + '?';
    if (params is Map) {
      params.forEach( (key, val)  => path += '$key=$val&');
    }
    router.navigateTo(context, path, transition: TransitionType.nativeModal, clearStack: clearStack);
  }
}
