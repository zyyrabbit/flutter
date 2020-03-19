import 'package:event_bus/event_bus.dart';
import 'package:peanut/http/api.dart';
import 'package:peanut/router.dart';
import 'package:peanut/utils/log.dart';

enum ENV {
  PRODUCTION,
  DEV,
}

Map<String, String> android = {
   'upgrade': 'http://test.ct-km.com/guangzhou/apk/'
};


Map<String, String> ios = {
   'upgrade': 'https://itunes.apple.com/cn/app/id1380512641/'
};

class App {
  /// 通过App设计环境变量
  static final ENV env = ENV.DEV;
  static EventBus event;
  static PageRouter pageRouter;
  static API api;
  static Log log;

  /// 所有获取配置的唯一入口
 static  Map<String, dynamic> get config {
    if (App.env == ENV.PRODUCTION) {
      return {
        'android': android,
        'ios': ios
      };
    }
    if (App.env == ENV.DEV) {
      return {
        'android': android,
        'ios': ios
      };
    }
    return {};
  }
}
