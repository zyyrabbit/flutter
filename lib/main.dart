import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:peanut/application.dart';
import 'package:peanut/router.dart';
import 'package:peanut/http/api.dart';
import 'package:peanut/pages/containerPage.dart';
import 'package:peanut/pages/loginPage.dart';
import 'package:peanut/utils/storage.dart';
import 'package:peanut/bean/userInfor.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hasLogin = false;
  bool _isLoading = true;
  UserInfor userInfor;

  _MyAppState() {
    /// 挂载全局上下文
    Application.event = EventBus();
    Application.pageRouter = PageRouter();
    Application.api = API();
  }
 
  @override
  void initState() {
    super.initState();
    Storage.getValue('hasLogin').then((value) async {
      if (value != null) {
        _hasLogin = true;
        userInfor = await Storage.getValue('userInfor');
      }
      setState(() { _isLoading = false; });
    });
  }

   /// 判断是否已经登录
  showPage() {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: Center(
          child: Text('启动中...', style: TextStyle(color: Colors.blueGrey),)
        ),
      );
    } else {
      if (_hasLogin) {
        return ContainerPage(userInfor, _hasLogin);
      } else {
        return LoginPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peanut',
      theme: ThemeData(primaryColor: Colors.white),
      home: showPage(),
      onGenerateRoute: Application.pageRouter.router.generator,
    );
  }

}