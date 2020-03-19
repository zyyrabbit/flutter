import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:peanut/utils/application.dart';
import 'package:peanut/router.dart';
import 'package:provider/provider.dart';
import 'package:peanut/model/globalModel.dart';
import 'package:peanut/db/sql.dart';

class StorePage extends StatefulWidget {
  StorePage({Key key}) : super(key: key);
  @override
  StorePageState createState() => StorePageState();
}

class StorePageState extends State<StorePage> {
  
  bool _loading = false;
  bool _showBottom = false;
  List<Map<String, dynamic>> storeArticles = []; 
  List<int> deleteIds = [];
  GlobalModel globalModel;
  @override
  void initState() {
    super.initState();
    globalModel = Provider.of<GlobalModel>(context, listen: false);
    storeArticles = globalModel.storeArticles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('我的收藏')
        ),
        actions: <Widget>[
          showEditBtn()
        ],
      ),
      body: showPage(),
      bottomNavigationBar: showBottom(),
    );
  }

  Future<List<Map<String, dynamic>>> getStoreWidgetList() async {
    try {
      return await Sql.getByCondition(TableName.STORE);
    } on Exception catch(e) {
      return [];
    }
  }

  showBottom() {
    if (_showBottom) {
      return  Container(
        height: 50,
        decoration: ShapeDecoration(
          color: Color.fromARGB(255, 240, 240, 240),
          shape: Border(top: BorderSide(
            color: Color(0xFF999999), 
            style: BorderStyle.solid, 
            width: 0.5)
          )
        ),
        child: Center(
          child: FlatButton(
            onPressed: () async {
              if (deleteIds.isEmpty) return;
              await Sql.batchDelete(TableName.STORE, deleteIds);
              storeArticles = await getStoreWidgetList();
              globalModel.setStoreArticles(storeArticles);
              print(deleteIds);
              setState(() {
                _showBottom = !_showBottom;
              });
            },
            child: Center(
              child: Text('删除', style: TextStyle(fontSize: 16),)
            )
          )
        )
      );
    }
    return null;
  }

  showEditBtn() {
    return FlatButton(
      onPressed: () {
        if (storeArticles.isEmpty) return;
        setState(() {
          _showBottom = !_showBottom;
        });
      },
      child: Center(
        child: Text(_showBottom ? '取消' : '编辑'),
      )
    );
  }

  showPage() {
    if (_loading) {
      return _buildProgressIndicator();
    } else if (storeArticles.length == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: Column(
            children: <Widget>[
            Image.asset('assets/icon/icon.png', width: 60, height: 60, color: Color.fromARGB(255, 160, 160, 160)),
            Text('暂无收藏', style: TextStyle(color: Color.fromARGB(255, 160, 160, 160)))
          ]),
        )
      );
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

  Widget _buildCardItem(Map<String, dynamic> item) {
    return Container(
      height: 80,
      padding: EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
             Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: TextStyle(fontSize: 16, color: Colors.black87)
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                  item['time'],
                  style: TextStyle(fontSize: 14, color: Color(0x255240240240))
                  ),
                )
              ]
            ),
            _showBottom ? Checkbox(
              value: deleteIds.contains(item['id']),
                onChanged: (val) {
                  setState(() {
                    if (val) {
                      deleteIds.add(item['id']);
                    } else {
                      deleteIds.remove(item['id']);
                    }
                  });
                }, 
            ) : Text('')
        ]
      )
    );
  }
  Widget _buildCard(Map<String, dynamic> item) {
    // Row(children: children, crossAxisAlignment: CrossAxisAlignment.center)
    return Card(
      color: Colors.white,
      elevation: 0.1,
      margin: new EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        child: _buildCardItem(item),
        onTap: () {
          _onWidgetTap(item); 
        })
    );
  }

  void _onWidgetTap(Map<String, dynamic> item) {
    print('router ::: $PageName.webViewPage');
    App.pageRouter.push(
      context, 
      PageName.webViewPage,
      {
        'url': Uri.encodeComponent(item['originalUrl']),
        'title': Uri.encodeComponent(item['title'])
      }
    );
  }
}

