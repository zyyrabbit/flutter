import './request.dart';
import 'package:peanut/bean/subjectEntity.dart';
typedef RequestCallBack<T> = void Function(T value);

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
}
