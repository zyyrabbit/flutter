import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:peanut/application.dart';
import 'package:peanut/router.dart';
import 'package:peanut/http/api.dart';
import 'package:peanut/pages/containerPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  _MyAppState() {
    /// 挂载全局上下文
    Application.event = EventBus();
    Application.router = Router();
    Application.api = API();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peanut',
      theme: ThemeData(primaryColor: Colors.white),
      home: ContainerPage()
    );
  }

}