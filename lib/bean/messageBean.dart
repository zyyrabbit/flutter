
import 'package:flutter/cupertino.dart';

class MessageBean {
  String platform;
  String audience;
  String msgContent;
  String contentType;
  String title;
  Map<String, dynamic> extras;

  MessageBean(
    { 
      @required  this.title,  
      @required this.contentType,
      @required this.msgContent, 
      this.extras, 
      this.platform = 'all',
      this.audience = 'all' 
    }
  );

  Map<String, dynamic> toJson() => {
   'platform': platform,
   'audience': audience,
   'message':  {
      'msg_content': msgContent,
      'content_type': contentType,
      'title': title,
      'extras': extras,
    },
   'notification': {
      'android': {
        'alert': title,
      },
    }
  };
}

