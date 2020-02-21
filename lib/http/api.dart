import './request.dart';
import 'package:peanut/bean/ArticleEntity.dart';

/* 
class API {
  static const BASE_URL = 'https://api.douban.com';

  /// TOP250
  static const String TOP_250 = '/v2/movie/top250';

  var _request = HttpRequest(API.BASE_URL);

  Future<List<Subject>> top({count = 50}) async {
    final Map result = await _request.get(TOP_250 + '?start=0&count=$count&apikey=0b2bdeda43b5688921839c8ecb20399b');
    var resultList = result['subjects'];
    return resultList.map<Subject>((item) => Subject.fromMap(item)).toList();
  }
} */


class API {
  static const BASE_URL = 'https://fluttergo.pub:9527/juejin.im/v1/get_tag_entry';

  var _request = HttpRequest(API.BASE_URL);

  Future<dynamic> top({ page = 1, pageSize = 10 }) async {
    dynamic params = '?src=web&tagId=5a96291f6fb9a0535b535438&sort=rankIndex&$page&$pageSize';
    final Map result = await _request.get(BASE_URL + params);
    return result;
  }
}
