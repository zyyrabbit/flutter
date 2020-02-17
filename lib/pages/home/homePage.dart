import 'package:flutter/material.dart';
import 'package:peanut/bean/subjectEntity.dart';
import 'package:flutter/cupertino.dart';
import 'package:peanut/application.dart';
import 'package:peanut/router.dart';
import 'package:peanut/components/searchInput.dart';

class HomePageState extends State<HomePage> {
  static final itemHeight = 150.0;
  List<Subject> _itemList = <Subject>[];

  @override
  void initState() {
    super.initState();
    getTop().then((data) {
      setState(() {
        _itemList = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildSearchInput(context),
      ),
      body: Center(
        child: _buildItemList()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Application.router.pushNoParams(context, Router.sharePage),
        tooltip: 'share',
        child: Icon(Icons.add),
      ),
    );
  }

  Future getTop( {count} ) async {
    return await Application.api.top();
  }

  void onWidgetTap(Subject widgetPoint, BuildContext context) {
    print('router ::: $Router.detailPage');
    Application.router.pushNoParams(context, Router.detailPage);
  }

  Widget buildSearchInput(BuildContext context) {
    return new SearchInput((value) async {
      if (value != '') {
        print('value ::: $value');
        // List<WidgetPoint> list = await widgetControl.search(value);
        List<Subject> list = await getTop();
        return list.map((item) => new MaterialSearchResult<String>(
                  value: item.title,
                  icon: null,
                  text: 'widget',
                  onTap: () {
                    onWidgetTap(item, context);
                  },
                ))
            .toList();
      } else {
        return null;
      }
    }, (value) {}, () {});
  }

  Widget _buildItemList() {
    if (_itemList.length == 0) {
      //loading
      return CircularProgressIndicator();
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return Divider(); /*2*/
        final index = i ~/ 2; /*3*/
        return _buildRow(_itemList[index]);
      });
  }

  Widget _buildRow(Subject item) {
    return GestureDetector(
      child: Container(
        child: Row(
          children: <Widget>[
            imageWidget(item.images.medium),
            itemInfoWidget(item)
          ],
        ),
      ),
      onTap: () {
        Application.router.pushNoParams(context, Router.detailPage);
      }
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

  itemInfoWidget(Subject item) {
    return Container(
      height: itemHeight,
      alignment: Alignment.topLeft,
      child: Row(
        children: <Widget>[
          Text(
            item.title,
            style: TextStyle(fontSize: 18.0)
          ),
          Text('(${item.year})',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey
          )),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}
