import './request.dart';
import 'package:html/parser.dart' show parse;
import 'package:peanut/bean/searchResult.dart';
import 'package:peanut/bean/userInfor.dart';
import 'package:http/http.dart' as http;

class API {

  var _request = HttpRequest();

  Future<dynamic> top({ page = 1, pageSize = 50 }) async {
    dynamic params = 'https://fluttergo.pub:9527/juejin.im/v1/get_tag_entry?src=web&tagId=5a96291f6fb9a0535b535438&sort=rankIndex&page=$page&pageSize=$pageSize';
    final Map result = await _request.get(params);
    return result;
  }

  Future<List<SearchResult>> suggestion(String query) async {
    var response = await http.get('https://www.so.com/s?ie=utf-8&q=$query');
    var document = parse(response.body);
    var elements = document.querySelectorAll('.res-title a');
    List<SearchResult> res = [];
    elements.forEach((f) {
      res.add(
        SearchResult(
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
  Future<UserInfor> getUserInfo(String requestToken) async {
      var resultToken = await _request.post(
        'https://github.com/login/oauth/access_token?client_id=4974949c8779c6204086&' +
        'client_secret=756e820bcb3ad234e38672d92c6ba31289b32bd3&' +
        'code=$requestToken',
        {},
        headers: {
          'accept': 'application/json'
        }
      );
      var accessToken = resultToken['access_token'];
      var resultInfo = await _request.get(
       'https://api.github.com/user',
        headers: {
          'accept': 'application/json',
          'Authorization': 'token $accessToken'
      });
     return UserInfor.fromJson(resultInfo);
    
  }
}
