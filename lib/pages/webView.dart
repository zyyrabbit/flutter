/// @Author: 一凨
/// @Date: 2019-01-14 17:44:47
/// @Last Modified by: 一凨
/// @Last Modified time: 2019-01-14 19:47:14
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

/// import 'package:flutter_go/model/collection.dart';
// import 'package:peanut/event/event_bus.dart';
// import 'package:flutter_go/event/event_model.dart';
// import 'package:flutter_go/api/api.dart';

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
