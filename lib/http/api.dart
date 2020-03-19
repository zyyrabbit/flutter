import './request.dart';
import 'package:html/parser.dart' show parse;
import 'package:peanut/bean/searchResultBean.dart';
import 'package:peanut/bean/userInforBean.dart';
import 'package:peanut/bean/messageBean.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as Convert;

class API {

  final _request = HttpRequest();

  Future<dynamic> top({ page = 1, pageSize = 50 }) async {
    dynamic params = 'https://fluttergo.pub:9527/juejin.im/v1/get_tag_entry?src=web&tagId=5a96291f6fb9a0535b535438&sort=rankIndex&page=$page&pageSize=$pageSize';
    final Map result = await _request.get(params);
    return result;
  }

  Future<List<SearchResultBean>> suggestion(String query) async {
    var response = await http.get('https://www.so.com/s?ie=utf-8&q=$query');
    var document = parse(response.body);
    var elements = document.querySelectorAll('.res-title a');
    List<SearchResultBean> res = [];
    elements.forEach((f) {
      res.add(
        SearchResultBean(
          title: f.text,
          url: f.attributes['data-url'] ?? f.attributes['href'],
        ),
      );
    });
    return Future.delayed(Duration(seconds: 2), () {
      return res;
    });
    //return suggestion;
  }

  // 获取用户信息
  Future<UserInforBean> getUserInfo(String requestToken) async {
      var resultToken = await _request.post(
        'https://github.com/login/oauth/access_token?client_id=4974949c8779c6204086&' +
        'client_secret=756e820bcb3ad234e38672d92c6ba31289b32bd3&' +
        'code=$requestToken',
        '',
        headers: {
          'accept': 'App/json'
        }
      );
      var accessToken = resultToken['access_token'];
      var resultInfo = await _request.get(
       'https://api.github.com/user',
        headers: {
          'accept': 'App/json',
          'Authorization': 'token $accessToken'
      });
     return UserInforBean.fromJson(resultInfo);
    
  }


  // 推送消息到极光
  Future<void> sendMessageToJpush(MessageBean messageBean, String base64AppKey) async {
    print('sendMessageToJpush messageBean ${Convert.jsonEncode(messageBean)}');
    print('sendMessageToJpush base64AppKey $base64AppKey');
    
    var result = await _request.post(
      'https://api.jpush.cn/v3/push',
      Convert.jsonEncode(messageBean),
      headers: {
       'Content-Type': 'App/json',
       'Authorization': 'Basic $base64AppKey'
      }
    );

    if (result['error']) {
      throw Error();
    }
  }
}
