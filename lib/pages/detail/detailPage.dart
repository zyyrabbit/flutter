import 'package:flutter/material.dart';

/// 详情页面
class DetailPage extends StatefulWidget {
  
  DetailPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DetailPageState();
  }
}

class _DetailPageState extends State<DetailPage> {
  Color pickColor = Color(0xffffffff); // 默认主题色

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('文章详情页'),
      ),
      backgroundColor: pickColor,
      body: Center(
        child: Text('文章详情页')
      )
    );
  }

}
