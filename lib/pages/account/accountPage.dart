import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:peanut/bean/globalEntity.dart';
import 'package:peanut/utils/storage.dart';
import 'package:peanut/application.dart';
import 'package:peanut/router.dart';
import 'package:share/share.dart';

class AccountPage extends StatefulWidget {
  final userInfo;
  AccountPage({Key key, this.userInfo}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextStyle textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w300);
   _AccountPageState();

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
      body: Consumer<GlobalEntity>(
         builder: (context, userInfor, child) {
          return  Column(children: <Widget>[
            _buildNickWidget(userInfor),
            _buildFeatureWidget(userInfor),
          ]);
        }
      )
    );
  }

  Widget _buildNickWidget(GlobalEntity globalEntity) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      height: 100,
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.only(top: 14.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(globalEntity.hasLogin 
                    ?  globalEntity.userInfor.avatarPic 
                    : 'https://hbimg.huabanimg.com/9bfa0fad3b1284d652d370fa0a8155e1222c62c0bf9d-YjG0Vt_fw658'),
                  fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(360.0))
              ),
              margin: EdgeInsets.only(left: 8, top: 3, right: 20, bottom: 3),
              height: 50.0,
              width: 50.0,
            ),
            Text('${globalEntity.userInfor.username}', style: TextStyle(fontSize: 16.0))
          ]
        ),
      )
    );
  }

  Widget _buildFeatureWidget(GlobalEntity globalEntity) {
    return Card(
      elevation: 0.0,
      child: Column(children: <Widget>[
        ListTile(
          leading: Icon(Icons.favorite, size: 27.0,),
          title: Text('我的收藏', style: textStyle,),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.share,size: 27.0,),
          title: Text('分享 App',style: textStyle,),
          onTap: () {
            Share.share('https://www.baidu.com/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(globalEntity.hasLogin ? Icons.exit_to_app : Icons.supervised_user_circle, size: 27.0,),
          title: Text(globalEntity.hasLogin ? '退出登陆' : '点击登录',style: textStyle,),
          onTap: () async{
            if (globalEntity.hasLogin) {
              await Storage.clear();
              Application.pageRouter.router.navigateTo(
                context, 
                '$PageName.loginPage',
                clearStack: true
              );
            }
          },
        ),
      ])
    );
  }
  
}
