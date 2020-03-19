import 'dart:async';
import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:peanut/utils/application.dart';
import 'package:peanut/router.dart';
import 'package:peanut/http/api.dart';
import 'package:peanut/pages/containerPage.dart';
import 'package:peanut/pages/loginPage.dart';
import 'package:peanut/utils/storage.dart';
import 'package:peanut/bean/userInforBean.dart';
import 'package:peanut/db/dbProvider.dart';
import 'package:provider/provider.dart';
import 'package:peanut/model/globalModel.dart';
import 'package:peanut/utils/jpush.dart';
import 'package:peanut/utils/excepHandler.dart';
import 'package:peanut/utils/log.dart';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbProvider().open();
  /// 捕获flutter异常
  ExcepHandler.resetOnError();
  /// 捕获dart异常
  runZoned<Future<void>>(() async {
   runApp(
      ChangeNotifierProvider(
        create: (context) => GlobalModel({}, false, []),
        child: MyApp(),
      )
    );
  }, onError: (error, stackTrace) async {
    await ExcepHandler.reportError(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool hasLogin = false;
  bool isLoading = true;
  bool isConnected = false;
  UserInforBean userInfor;

  _MyAppState() {
    /// 挂载全局上下文
    App.event = EventBus();
    App.pageRouter = PageRouter();
    App.api = API();
    App.log = Log();
  }
 
  @override
  void initState() {
    super.initState();
    JpushUtil.initPlatformState();
    Storage.getValue('hasLogin').then((value) async {
      if (value != null) {
        hasLogin = true;
      }
      setState(() { isLoading = false; });
    });
  }

   /// 判断是否已经登录
  showHomePage() {
    if (isLoading) {
      return Container(
        child: Image.asset(
          'assets/images/peanut.jpg',
          fit: BoxFit.fill,
        ),
      );
    } else {
      if (hasLogin) {
        return ContainerPage();
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
      home: showHomePage(),
      onGenerateRoute: App.pageRouter.router.generator,
    );
  }

}