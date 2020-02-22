import './request.dart';
import 'package:html/parser.dart' show parse;
import 'package:peanut/bean/searchResult.dart';
import 'package:http/http.dart' as http;

class API {
  static const BASE_URL = 'https://fluttergo.pub:9527/juejin.im/v1/get_tag_entry';

  var _request = HttpRequest(BASE_URL);

  Future<dynamic> top({ page = 1, pageSize = 50 }) async {
    dynamic params = '?src=web&tagId=5a96291f6fb9a0535b535438&sort=rankIndex&page=$page&pageSize=$pageSize';
    final Map result = await _request.get(params);
    return result;
  }

  Future<List<SearchResult>> suggestion(String query) async {
    var response = await http.get('https://www.so.com/s?ie=utf-8&q=$query flutter');
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
}
