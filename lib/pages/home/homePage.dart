import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:peanut/application.dart';
import 'package:peanut/router.dart';
import 'package:peanut/components/searchInput.dart';
import 'package:peanut/bean/ArticleEntity.dart';
import 'package:peanut/bean/searchResult.dart';
import 'package:peanut/components/listRefresh.dart' as listComp;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildSearchInput(context),
      ),
      body: Center(
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: listComp.ListRefresh(getIndexListData, buildCard)
            )
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Application.pageRouter.pushNoParams(context, PageName.sharePage),
        tooltip: 'share',
        child: Icon(Icons.add),
      ),
    );
  }

  void onWidgetTap(BuildContext context, SearchResult item) {
    print('router ::: $PageName.webViewPage');
    Application.pageRouter.push(
      context, 
      PageName.webViewPage, 
      { 
        'title': Uri.encodeComponent(item.title),
        'url': Uri.encodeComponent(item.url)
      }
    );
  }

  Widget buildSearchInput(BuildContext context) {
    return SearchInput((value) async {
      if (value != '') {
        print('value ::: $value');
        List<SearchResult> list = await Application.api.suggestion(value);
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
      var response = await Application.api.top(page: pageIndex);
      responseList = response['d']['entrylist'];
      pageTotal = response['d']['total'];
      if (!(pageTotal is int) || pageTotal <= 0) {
        pageTotal = 0;
      }
    } catch (e) {}
    pageIndex += 1;
    List<ArticleEntity> resultList = responseList.map<ArticleEntity>((item) => ArticleEntity.fromMap(item)).toList();
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
          ])
        ),
    ];

    if (item.screenshot == null || item.screenshot != '') {
      children.add(_imageWidget(item.screenshot)); 
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
          onWidgetTap(context, SearchResult(title: item.title, url: item.originalUrl)); 
        })
    );
  }

  //圆角图片
  Widget _imageWidget(var imgUrl) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover),
        borderRadius: BorderRadius.all(Radius.circular(5.0))
      ),
      margin: EdgeInsets.only(left: 8, top: 3, right: 8, bottom: 3),
      height: 120.0,
      width: 100.0,
    );
  }
}

