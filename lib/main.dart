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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbProvider().open();
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalModel({}, false),
      child: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool hasLogin = false;
  bool isLoading = true;
  UserInforBean userInfor;
  bool isConnected = false;
  

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
        hasLogin = true;
        userInfor = await Storage.getValue('userInfor');
      }
      setState(() { isLoading = false; });
    });
    JpushUtil.initPlatformState();
  }

   /// 判断是否已经登录
  showPage() {
    if (isLoading) {
      return Container(
        child:  Image.asset(
            'assets/images/peanut.jpg',
            fit: BoxFit.fill,
          ),
      );
    } else {
      if (hasLogin) {
        GlobalModel globalModel = Provider.of<GlobalModel>(context, listen: false);
        globalModel.set(userInfor, hasLogin);
        return  ContainerPage();
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