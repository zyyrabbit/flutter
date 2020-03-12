

import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:peanut/utils/application.dart';
import 'package:peanut/bean/messageBean.dart';
import 'package:peanut/event/MessageEvent.dart';
import 'dart:convert' as Convert;


class JpushUtil {
  static const _appkey = '01c2efae9da06b0e9c5d43cc';
  static const _authkey = 'MDFjMmVmYWU5ZGEwNmIwZTljNWQ0M2NjOmZmOWE3MGM3NTAxNmUzM2NiOTU1NjU3Nw==';
  
  static final JPush _jpush = JPush();
  static String _registrationId;

  static get registrationId => _registrationId;

    // Platform messages are asynchronous, so we initialize in an async method.
  static Future<void> initPlatformState() async {

    try {
       _jpush.addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
          print('flutter onReceiveNotification: $message');
        }, 
        onReceiveMessage: (Map<String, dynamic> message) async {
          print('flutter onReceiveMessage: $message');
          var extras = message['extras'];
          var userInfor = Convert.jsonDecode(extras['cn.jpush.android.EXTRA']);
          Application.event.fire(MessageEvent(userInfor));
        },
        onOpenNotification: (Map<String, dynamic> message) async {
          print('flutter onOpenNotification: $message');
        });
        
      } catch(e) {
        print('Failed to get platform version.');
      }

    _jpush.setup(
      appKey: _appkey, //你自己应用的 AppKey
      channel: 'flutter_channel',
      production: false,
      debug: true,
    );
    
    _jpush.applyPushAuthority(NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.
    _jpush.getRegistrationID().then((rid) {
      print('flutter get registration id : $rid');
      _registrationId = rid;
    });
  }

  static Future<void> sendMessage(MessageBean messageBean) async {
    await Application.api.sendMessageToJpush(messageBean, _authkey);
  }
}


  