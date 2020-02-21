import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:peanut/application.dart';
import 'package:peanut/router.dart';
import 'package:peanut/components/searchInput.dart';
import 'package:peanut/bean/ArticleEntity.dart';
import 'package:peanut/components/listRefresh.dart' as listComp;

class HomePageState extends State<HomePage> {
  static final itemHeight = 120.0;

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

  void onWidgetTap(BuildContext context) {
    print('router ::: $PageName.detailPage');
    Application.pageRouter.pushNoParams(context, PageName.accoutPage);
  }

  Widget buildSearchInput(BuildContext context) {
    return new SearchInput((value) async {
      if (value != '') {
        print('value ::: $value');
        // List<WidgetPoint> list = await widgetControl.search(value);
        Map<String, dynamic> result = await getIndexListData();
        List<ArticleEntity> list = result['list'];
        return list
            .map((item) => new MaterialSearchResult<String>(
                  value: item.title,
                  icon: null,
                  text: 'widget',
                  onTap: () {
                    onWidgetTap(context);
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
                child: Text(item.title,
                style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold)
              )),
              Text(
                item.content,
                style: TextStyle(fontSize: 12, color: Color.fromRGBO(10,10, 10, 0.6))
              ),
          ])
        ),
    ];
    if (item.screenshot == null || item.screenshot != '') {
      children.add(imageWidget(item.screenshot)); 
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
          Application.pageRouter.push(
            context, 
            PageName.webViewPage, 
            {
              'title': Uri.encodeComponent(item.title),
              'url': Uri.encodeComponent(item.originalUrl)
            }
          );
        })
    );
  }

  //圆角图片
  imageWidget(var imgUrl) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover),
        borderRadius: BorderRadius.all(Radius.circular(5.0))
      ),
      margin: EdgeInsets.only(left: 8, top: 3, right: 8, bottom: 3),
      height: itemHeight,
      width: 100.0,
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}
