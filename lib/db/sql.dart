import 'package:sqflite/sqflite.dart';
import './dbProvider.dart';

class TableName {
  static const RECOMD = Table.RECOMD;
  static const STORE = Table.STORE;
  static const USERINFOR = Table.USERINFOR;
}

class Sql {
  static final Database db = DbProvider.db;
  static final query = db.query;

  /// sdf
  static Future<List> get(String tableName) async {
    return await query(tableName);
  }

  static Future<int> getCount(String tableName) async {
    return  Sqflite.firstIntValue(await db.rawQuery('select count(1) from $tableName'));
  }

  static Future<int> delete(String tableName, String value, String key) async {
    return await db.delete(tableName, where: '$key = ?', whereArgs: [value]);
  }

  static Future<int> deleteAll(String tableName) async {
    return await db.delete(tableName);
  }

  static Future<void> batchDelete(String tableName, List<int> ids) async {
    Batch batch = db.batch();
    for (int id in ids) {
      batch.delete(tableName, where: 'id = ?', whereArgs: [id]);
    }
    return await batch.commit(noResult: true);
  }

  static Future<List> getByPage(String tableName, int limit, int offset) async {
    return await query(tableName, limit: limit, offset: offset);
  }

  static Future<List> getByCondition(String tableName, {Map<dynamic, dynamic> conditions}) async {
    if (conditions == null || conditions.isEmpty) {
      return get(tableName);
    }
    String stringConditions = '';

    int index = 0;
    conditions.forEach((key, value) {
      if (value == null) {
        return;
      }
      if (value.runtimeType == String) {
        stringConditions = '$stringConditions $key = "$value"';
      }
      if (value.runtimeType == int) {
        stringConditions = '$stringConditions $key = $value';
      }

      if (index >= 0 && index < conditions.length - 1) {
        stringConditions = '$stringConditions and';
      }
      index++;
    });
    return await query(tableName, where: stringConditions);
  }

  static Future<Map<String, dynamic>> insert(String tableName, Map<String, dynamic> json) async {
    int id = await db.insert(tableName, json);
    json['id'] = id;
    
    return json;
  }

  /// 搜索
  /// @param Object condition
  /// @mods [And, Or] default is Or
  /// search({'name': "hanxu', 'id': 1};
  static Future<List> search(String tableName, {Map<String, dynamic> conditions, String mods = 'Or'}) async {
    if (conditions == null || conditions.isEmpty) {
      return get(tableName);
    }
    String stringConditions = '';
    int index = 0;
    conditions.forEach((key, value) {
      if (value == null) {
        return;
      }

      if (value.runtimeType == String) {
        stringConditions = '$stringConditions $key like "%$value%"';
      }
      if (value.runtimeType == int) {
        stringConditions = '$stringConditions $key = "%$value%"';
      }

      if (index >= 0 && index < conditions.length - 1) {
        stringConditions = '$stringConditions $mods';
      }
      index++;
    });

    return await query(tableName, where: stringConditions);
  }
}
