import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:peanut/utils/application.dart';
import 'package:peanut/router.dart';
import 'package:peanut/bean/articleBean.dart';
import 'package:peanut/bean/searchResultBean.dart';
import 'package:peanut/components/listRefresh.dart' as listComp;
import 'package:peanut/db/sql.dart';

class RecomPage extends StatefulWidget {
  RecomPage({Key key}) : super(key: key);
  @override
  RecomPageState createState() => RecomPageState();
}

class RecomPageState extends State<RecomPage> {
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('推荐')
        )
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
    );
  }

  void onWidgetTap(BuildContext context, SearchResultBean item) {
    print('router ::: $PageName.webViewPage');
    App.pageRouter.push(
      context, 
      PageName.webViewPage, 
      { 
        'title': Uri.encodeComponent(item.title),
        'url': Uri.encodeComponent(item.url)
      }
    );
  }

  Future<Map> getIndexListData([Map<String, dynamic> params]) async {
    int pageIndex = (params is Map) ? params['pageIndex'] : 0;
    int pageTotal = 0;
    var responseList = [];

    print(params);

    try {
      responseList = await Sql.getByPage(TableName.RECOMD, 10, pageIndex * 10);
      print('responseList: ${responseList.length}');
      pageTotal = await Sql.getCount(TableName.RECOMD);
      print('pageTotal: $pageTotal');
      pageTotal = (pageTotal ~/ 10);
      print('$pageIndex, $pageTotal');
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
              Text(
                  item.title,
                  style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold)
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
                child: Text(
                item.content,
                style: TextStyle(fontSize: 12, color: Color.fromRGBO(10,10, 10, 0.6))
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      item.author,
                      style: TextStyle(fontSize: 12, color: Color.fromRGBO(10,10, 10, 0.6))
                    )
                  ),
                  Center(
                   child:Text(
                    item.createdAt,
                    style: TextStyle(fontSize: 12, color: Color.fromRGBO(10,10, 10, 0.6))
                  ),
                  )
                ],
              )
              
          ])
        ),
    ];

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
}
