import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:peanut/utils/application.dart';
import 'package:peanut/router.dart';
import 'package:peanut/db/sql.dart';

class StorePage extends StatefulWidget {
  StorePage({Key key}) : super(key: key);
  @override
  StorePageState createState() => StorePageState();
}

class StorePageState extends State<StorePage> {
  
  bool _loading = false;
  List<Map<String, dynamic>> storeArticles = [];
  @override
  void initState() {
    super.initState();
    getStoreWidgetList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('我的收藏')
        )
      ),
      body: showPage(context)
    );
  }

  showPage(BuildContext context) {
    if (_loading) {
      return _buildProgressIndicator();
    } else {
      List<Widget> listWidget = storeArticles.map((item) => _buildCard(item)).toList();
      return ListView(
        children: listWidget
      );
    }
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Opacity(
              opacity: _loading ? 1.0 : 0.0,
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blue)),
            ),
            SizedBox(height: 20.0),
            Text( '稍等片刻更精彩...',style: TextStyle(fontSize: 14.0))
          ],
      )
      ),
    );
  }

  Future<void> getStoreWidgetList() async {
    try {
      storeArticles = await Sql.getByCondition(TableName.STORE);
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildCard(Map<String, dynamic> item) {
    var children = <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 0, bottom: 10),
                child: Text(
                  item['title'],
                  style: TextStyle(fontSize: 16, color: Colors.black87)
                )
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
          _onWidgetTap(item); 
        })
    );
  }

  void _onWidgetTap(Map<String, dynamic> item) {
    print('router ::: $PageName.containerPage');
    Application.pageRouter.pushNoParams(context, PageName.containerPage);
  }
}

