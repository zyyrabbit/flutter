import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class AccountPage extends StatefulWidget {
  final userInfo;
  AccountPage({Key key, this.userInfo}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextStyle textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w300);
   _AccountPageState() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title:  Center(child: Text('个人中心'))
      ),
      body: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        // Divider(),
        ListTile(
          leading: Icon(Icons.search,size: 27.0,),
          title: Text('全网搜', style: textStyle,),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.favorite,size: 27.0,),
          title: Text('我的收藏',style: textStyle,),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.email,size: 27.0,),
          title: Text('反馈/建议',style: textStyle,),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.share,size: 27.0,),
          title: Text('分享 App',style: textStyle,),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.supervised_user_circle,size: 27.0,),
          title: Text('点击登录',style: textStyle,),
          onTap: () {},
        ),
      ],
     )
    ); 
  }
}
