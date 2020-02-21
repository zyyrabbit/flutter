import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:peanut/pages/account/accountPage.dart';
import 'package:peanut/pages/sharePage.dart';
import 'package:peanut/pages/webView.dart';

enum PageName {
  accoutPage,
  sharePage,
  webViewPage
}

final Map<PageName, Handler> pageRoutes = {
  PageName.accoutPage: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return AccountPage();
  }),
  PageName.sharePage: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return SharePage();
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
    router.navigateTo(context, pageName.toString(), transition: TransitionType.fadeIn);
  }

  push(BuildContext context, PageName pageName, dynamic params) {
    var path = pageName.toString() + '?';
    if (params is Map) {
      params.forEach( (key, val)  => path += '$key=$val&');
    }
    router.navigateTo(context, path, transition: TransitionType.nativeModal);
  }
}
