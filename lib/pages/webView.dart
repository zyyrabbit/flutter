import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:peanut/application.dart';
import 'package:peanut/event/eventModel.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  WebViewPage(this.url, this.title);
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print('url change:$url');
      if (url.indexOf('code') > -1) {
        String urlQuery = url.substring(url.indexOf('?') + 1);
        String token;
        List<String> queryList = urlQuery.split('&');
        for (int i = 0; i < queryList.length; i++) {
          String queryNote = queryList[i];
          int eqIndex = queryNote.indexOf('=');
          if (queryNote.substring(0, eqIndex) == 'code') {
            token = queryNote.substring(eqIndex + 1);
          }
        }

        if (Application.event != null) {
          Application.event.fire(UserGithubOAuthEvent(token, true));
        }
        print('ready close');
        flutterWebviewPlugin.close();
        // 验证成功
      } else if (url.indexOf('loginFail') == 0) {
        // 验证失败
        if (Application.event != null) {
          Application.event.fire(UserGithubOAuthEvent('', true));
        }
        flutterWebviewPlugin.close();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebviewScaffold(
        url: widget.url,
        withZoom: false,
        withLocalStorage: true,
        withJavascript: true,
        hidden: true,
      ),
    );
  }
}
