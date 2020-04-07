import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:peanut/utils/application.dart';
import 'package:peanut/router.dart';
import 'package:peanut/components/searchInput.dart';
import 'package:peanut/bean/articleBean.dart';
import 'package:peanut/bean/searchResultBean.dart';
import 'package:peanut/components/listRefresh.dart' as listComp;
import 'package:peanut/components/upgrade.dart';
import 'package:peanut/utils/formatTime.dart';
import 'package:peanut/event/MessageEvent.dart';
import 'package:peanut/db/sql.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    registerListger();
  }

  void registerListger() {
    print('123');
    App.event.on<MessageEvent>().listen((event) async {
      print('token: ${event.userInfor}');
      try {
        await Sql.insert(TableName.RECOMD, event.userInfor);
        App.pageRouter.pushNoParams(
          context,
          PageName.containerPage,
          clearStack: true
        );
      } catch(e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildSearchInput(context),
      ),
      body: Upgrade(
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: listComp.ListRefresh(getIndexListData, buildCard)
            )
          ]
        ),
        url: App.config['android']['upgrade'],
        apkName: 'app-release.apk',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          App.pageRouter.pushNoParams(context, PageName.publishPage);
        },
        tooltip: 'publish',
        child: Icon(Icons.add),
      ),
    );
  }

  void onWidgetTap(BuildContext context, SearchResultBean item) {
    print('router ::: $PageName.webViewPage');
    App.pageRouter.push(
      context, 
      PageName.webViewPage, 
      { 
        'title': Uri.encodeComponent(item.title),
        'url': Uri.encodeComponent(item.url),
        'btn': '1'
      }
    );
  }

  Widget buildSearchInput(BuildContext context) {
    return SearchInput((value) async {
      if (value != '') {
        print('value ::: $value');
        List<SearchResultBean> list = await App.api.suggestion(value);
        return list.map((item) => MaterialSearchResult<String>(
                  value: item.title,
                  icon: null,
                  text: '',
                  onTap: () {
                    onWidgetTap(context, item);
                  },
                ))
            .toList();
      } else {
        return null;
      }
    }, (value) {}, () {});
  }

  Future<Map> getIndexListData([Map<String, dynamic> params]) async {
    var pageIndex = (params is Map) ? params['pageIndex'] : 0;
    var responseList = [];
    var pageTotal = 0;

    try {
      var response = await App.api.top(page: pageIndex);
      responseList = response['d']['entrylist'];
      pageTotal = response['d']['total'];
      if (!(pageTotal is int) || pageTotal <= 0) {
        pageTotal = 0;
      }
    } catch (e) {}
    pageIndex += 1;
    List<ArticleBean> resultList = responseList.map<ArticleBean>((item) => ArticleBean.fromMap(item)).toList();
    Map<String, dynamic> result = {
      'list': resultList,
      'total': pageTotal,
      'pageIndex': pageIndex
    };
    return result;
  }

  Widget buildCard(index, item) {
    var children = <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 0, bottom: 10),
                child: Text(
                  item.title,
                  style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold)
                )
              ),
              Text(
                item.content,
                style: TextStyle(fontSize: 12, color: Color.fromRGBO(10,10, 10, 0.6))
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                formatTime(DateTime.parse(item.createdAt).millisecondsSinceEpoch),
                style: TextStyle(fontSize: 12, color: Color.fromRGBO(10,10, 10, 0.6))
              ),
            )
          ])
        ),
    ];

    if (item.screenshot != '') {
      double height = item.content == '' ? 60 : 120;
      children.add(_imageWidget(item.screenshot,  height: height)); 
    }

    return Card(
      color: Colors.white,
      elevation: 0.1,
      margin: new EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Row(children: children, crossAxisAlignment: CrossAxisAlignment.start),
        ),
        onTap: () {
          onWidgetTap(context, SearchResultBean(title: item.title, url: item.originalUrl)); 
        })
    );
  }

  //圆角图片
  Widget _imageWidget(String imgUrl, { double height = 120 }) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover),
        borderRadius: BorderRadius.all(Radius.circular(5.0))
      ),
      margin: EdgeInsets.only(left: 8, top: 3, right: 8, bottom: 3),
      height: height,
      width: 100.0,
    );
  }
}

