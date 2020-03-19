import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:isolate';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:peanut/utils/application.dart';
import 'package:http/http.dart' as http;

ReceivePort _port = ReceivePort();

class Upgrade extends StatefulWidget {
  final String url;
  final Widget child;
  final String apkName;
  Upgrade({
    Key key, 
    @required this.child, 
    @required this.url, 
    @required this.apkName}
  ) : super(key: key);

  @override
  _UpgradeState createState() => _UpgradeState();
}

class _UpgradeState extends State<Upgrade> {
  String taskId;
  @override
  void initState() {
    super.initState();
    //检查是否有更新
    checkUpdate(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.child
    );
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  Future<String> getVersionInfo() async {
    String versionInfo = '';
    try {
      versionInfo = await http.read('${widget.url}app-version.json');
    } catch(e) {
      print(e);
    }
    return versionInfo;
  }

  /// 1.检查是否有更新
  Future<void> checkUpdate(BuildContext context) async{
  //Android , 需要下载apk包
  if(Platform.isAndroid){
    print('is android');
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String localVersion = packageInfo.version;
      ///获取服务端中最新的app版本信息
      String versionInfo = await getVersionInfo();
      if(versionInfo.isNotEmpty) {
        Map<String, dynamic> map = json.decode(versionInfo);
        String serverAndroidVersion = map['version'].toString();
        String serverMsg = map['msg'].toString();
        String url = map['url'].toString();
        print(url);
        print('本地版本: ' + localVersion + ',最新版本: ' + serverAndroidVersion );
        int c = serverAndroidVersion.compareTo(localVersion);
        ///如果服务端版本大于本地版本则提示更新
        if(c == 1){
          showUpdate(context, serverAndroidVersion, serverMsg, url);
        }
      }
  }
  
  //Ios , 只能跳转到 AppStore , 直接采用url_launcher就可以了
  //android也可以采用此方法，会跳转到手机浏览器中下载
  if(Platform.isIOS){
    print('is ios');
    final url = App.config['ios']['upgrade']; // id 后面的数字换成自己的应用 id 就行了
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}

  /// 2.显示更新内容
  Future<void> showUpdate(BuildContext context, String version, String serverMsg, String url) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('检测到新版本 v$version'),
          content : Text('是否要更新到最新版本?') ,
          actions: <Widget>[
            FlatButton(
              child: Text('下次在说'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('立即更新'),
              onPressed: () => doUpdate(context, widget.url + widget.apkName)
            ),
          ],
        );
      },
    );
  }

  /// 3.检查是否有权限
  Future<bool> checkPermission() async {
    //检查是否已有读写内存权限
    PermissionStatus status = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    print(status);
    
    //判断如果还没拥有读写权限就申请获取权限
    if(status != PermissionStatus.granted){
      var map = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      if(map[PermissionGroup.storage] != PermissionStatus.granted){
        return false;
      }
    }
    return true;
  }

  /// 4.执行更新操作
  doUpdate(BuildContext context, String url) async {
    //关闭更新内容提示框
    Navigator.pop(context);
    //获取权限
    var per = await checkPermission();
    if(per != null && !per){
      return null;
    }
    // progressDialog();
    //开始下载apk
    executeDownload(context , url);
  }


  /// 5.下载时显示下载进度dialog
  void progressDialog() {
      //下载时显示下载进度dialog
    ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Download, 
      isDismissible: true, 
      showLogs: true
    );

    pr.style(
      message: '下载中，请稍后…',
      backgroundColor: Colors.white,
      progressWidget: Container(
        padding: EdgeInsets.all(8.0), 
        child: CircularProgressIndicator()
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600)
    );

    if (!pr.isShowing()) {
      pr.show();
    }

    _port.listen((dynamic data) {

      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (status == DownloadTaskStatus.running) {
        pr.update(progress: progress.toDouble(), message: "下载中，请稍后…");
      }

      if (status == DownloadTaskStatus.failed) {
        if (pr.isShowing()) {
          pr.hide();
        }
      }

      if (taskId == id && status == DownloadTaskStatus.complete) {
        if (pr.isShowing()) {
          pr.hide();
        }
        
      }
    });

  }

  /// 6.下载apk
  Future<void> executeDownload(BuildContext context, String url) async {
    //apk存放路径
    final path = await _apkLocalPath;
    File file = File(path + '/' + widget.apkName);
    if (await file.exists()) await file.delete();
    // 只能调用一次
    await FlutterDownloader.initialize();
    FlutterDownloader.registerCallback(downloadCallback);
    _bindBackgroundIsolate();
    //下载
    taskId = await FlutterDownloader.enqueue(
      url: url,//下载最新apk的网络地址
      savedDir: path,
      showNotification: true,
      openFileFromNotification: true
    );

  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];

      if (taskId == id && status == DownloadTaskStatus.complete) {
        _installApk();
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  // 7.安装app
  Future<Null> _installApk() async {
    String path = await _apkLocalPath;
    await FlutterDownloader.open(taskId: taskId);
  }

  // 获取apk存放地址(外部路径)
  Future<String> get _apkLocalPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }
}