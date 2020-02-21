import 'package:flutter/material.dart';

/// 详情页面
class AccountPage extends StatefulWidget {
  
  AccountPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AccountPageState();
  }
}

class _AccountPageState extends State<AccountPage> {
  Color pickColor = Color(0xffffffff); // 默认主题色

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('我'),
        )
      ),
      backgroundColor: pickColor,
      body: Center(
        child: Text('你好，林小芳')
      )
    );
  }

}
