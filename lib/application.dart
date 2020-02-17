import 'package:event_bus/event_bus.dart';
import 'package:peanut/router.dart';
import 'package:peanut/http/api.dart';

enum ENV {
  PRODUCTION,
  DEV,
}

class Application {
  /// 通过Application设计环境变量
  static final ENV env = ENV.DEV;
  static EventBus event;
  static Router router;
  static API api;

  /// 所有获取配置的唯一入口
  Map<String, String> get config {
    if (Application.env == ENV.PRODUCTION) {
      return {};
    }
    if (Application.env == ENV.DEV) {
      return {};
    }
    return {};
  }
}
