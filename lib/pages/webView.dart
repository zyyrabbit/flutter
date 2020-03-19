import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:peanut/utils/application.dart';
import 'package:peanut/event/UserGithubOAuthEvent.dart';
import 'package:peanut/db/sql.dart';
import 'package:peanut/utils/common.dart';
import 'package:provider/provider.dart';
import 'package:peanut/model/globalModel.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;
  final String btn;

  WebViewPage(this.url, this.title, {this.btn});
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();
  bool isStore;
  GlobalModel globalModel;

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

        if (App.event != null) {
          App.event.fire(UserGithubOAuthEvent(token, true));
        }
        print('ready close');
        flutterWebviewPlugin.close();
        // 验证成功
      } else if (url.indexOf('loginFail') == 0) {
        // 验证失败
        if (App.event != null) {
          App.event.fire(UserGithubOAuthEvent('', true));
        }
        flutterWebviewPlugin.close();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    globalModel = Provider.of<GlobalModel>(context, listen: false);
    int index = globalModel.storeArticles.indexWhere((item) => item['originalUrl'] == widget.url);
    isStore = index != -1;

    Widget appBarWidget = AppBar(
        elevation: 10,
        shape: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 210, 210, 210)
          )
        ),
        title: Text(widget.title),
        actions: widget.btn != null ? <Widget>[
          IconButton(
            icon: Icon(
              isStore ? Icons.star : Icons.star_border, 
              color: isStore ? Color.fromARGB(255, 0, 127, 255) : Colors.black
            ),
            tooltip: '收藏',
            onPressed: () async {
              if (isStore) return;
              Map<String, dynamic> item = {
                'title': widget.title,
                'originalUrl': widget.url,
                'time': CommonUtil.getCurrntDate()
              };
              await Sql.insert(TableName.STORE, item);
              globalModel.storeArticles.add(item);
              setState(() {
                isStore = true;
              });
            }
          ),
        ] : []
      );
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget,
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
