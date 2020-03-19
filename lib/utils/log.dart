import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:peanut/utils/formatTime.dart';

enum LogLevel {
  Trace,
  Debug,
  Info,
  Warning,
  Error,
  Critical,
  Off
}

class LogOption {
  LogLevel _logLevel;
  String _filePath;
  String _extname;
  int _expireDays;

  LogOption({LogLevel logLevel = LogLevel.Info,
    String filePath = '',
    String extname = '.log',
    int expireDays = 1
  }) : _logLevel = logLevel,
    _filePath = filePath,
    _extname = extname,
    _expireDays = expireDays;
  //  get方法
  LogLevel get logLevel => _logLevel;
  String get extname => _extname;
  String get filePath => _filePath;
  int get expireDays => _expireDays;

  //set方法
  set logLevel(LogLevel logLevel) => this._logLevel = logLevel;
  set extname(String extname) => this._extname = extname;
  set filePath(String filePath) => this._filePath = filePath;
  set expireDays(int expireDays) => this._expireDays = expireDays;
}

class Log {
  LogLevel _logLevel;
  String _filePath;
  String _extname;
  int _expireDays;
  String _today;
  IOSink _stdout;

  Log({ LogOption logOption }) {
    if (logOption == null) {
      logOption = LogOption();
    }
    _logLevel = logOption.logLevel;
    _filePath = logOption.filePath;
    _extname = logOption.extname;
    _expireDays = logOption.expireDays;
    _today = _now();
    _init();
  }

  get logLevel => _logLevel;
  set logLevel(LogLevel logLevel) => this._logLevel = logLevel;

  Future<void> _init() async {
    await _ensureFilePath();
    _clean();
    _stdout = File(_getLogFile(date: _today)).openWrite(mode: FileMode.append);
  }

  void info(String msg) {
    if (logLevel.index <= LogLevel.Info.index) {
      _write(LogLevel.Info, msg);
    }
  }

  void error(String msg) {
    if (logLevel.index <= LogLevel.Error.index) {
      _write(LogLevel.Error, msg);
    }
  }

  void _write(LogLevel logLevel, String msg) {
    if (_stdout == null) return;

    String dateTime = DateTime.now().toString();
    if (logLevel == LogLevel.Info) {
      _stdout.writeln(['Info', dateTime, msg]);
    }

    if (logLevel == LogLevel.Error) {
      _stdout.writeln(['Error', dateTime, msg]);
    }
  }

  String _now() {
    DateTime now = DateTime.now();
    return formatTime(now.millisecondsSinceEpoch, format: 'yyyy-MM-dd');
  }

  Future<void> _ensureFilePath() async {
    if (_filePath.isEmpty) {
      _filePath = (await getApplicationDocumentsDirectory()).path;
    }
  }

  void _clean() {
    String dir = _getLogFile();
    print('clean  $dir');
    final logDir = Directory(dir);
    const reg = r'([^/]+)\.[^.]+$';

    logDir.list().listen((FileSystemEntity entity) {
      entity.stat().then((FileStat fileState) {
        if (fileState.type == FileSystemEntityType.file) {
          String fileName = RegExp(reg).firstMatch(entity.path).group(1);
          /// 判断日志文件是否过期
          if (DateTime.parse(fileName)
            .add(Duration(days: _expireDays))
            .isBefore(DateTime.parse(_today)) ) {
              entity.delete();
            }
          }
      });
    });
  }

  String _getLogFile({ String date }) {
    if (date != null && date.isNotEmpty) {
      return '$_filePath' + '/Log/' + date + '$_extname';
    }
    final logDir = Directory('$_filePath' + '/Log');
    if (!logDir.existsSync()) {
      logDir.createSync();
    }
    return logDir.path;
  }

  dispose() {
    _stdout.close();
  }

}