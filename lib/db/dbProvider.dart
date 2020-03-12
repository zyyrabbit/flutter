import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Table {
  static const RECOMD = 'recomd';
  static const STORE = 'store';
  static const USERINFOR = 'userInfor';
}

class DbProvider {
  static Database db;

  // 获取数据库中所有的表
  Future<List> getTables() async {
    if (db == null) {
      return Future.value([]);
    }
    List tables = await db.rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    List<String> targetList = [];
    tables.forEach((item) {targetList.add(item['name']);});
    return targetList;
  }

  // 检查数据库中, 表是否完整, 在部份android中, 会出现表丢失的情况
  Future checkTableIsRight() async {
   // List<String> expectTables = ['userInfor', 'recommed', 'store'];
    List<String> expectTables = [Table.RECOMD, Table.STORE];

    List<String> tables = await getTables();

    for (int i = 0; i < expectTables.length; i++) {
      if (!tables.contains(expectTables[i])) {
        return false;
      }
    }
    return true;
  }

  //初始化数据库
  Future open() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'peanut.db');
    print(path);
    try {
      db = await openDatabase(path);
    } catch (e) {
      print('Error $e');
    }

    bool tableIsRight = await this.checkTableIsRight();
    if (!tableIsRight) {
      /// 关闭上面打开的db，否则无法执行open
      db.close();
      /// Delete the database
      await deleteDatabase(path);

      db = await openDatabase(
          path, 
          version: 1,
          onCreate: (Database db, int version) async {
            // 可以优化，生产文件后，然后出错复制过去
            await db.execute('''
              create table ${Table.RECOMD} ( 
                id integer primary key autoincrement, 
                title text not null,
                originalUrl text not null,
                screenshot text,
                content text,
                time text
               )
              ''');
             // 可以优化，生产文件后，然后出错复制过去
            await db.execute('''
              create table ${Table.STORE} ( 
                id integer primary key autoincrement, 
                title text not null,
                originalUrl text not null,
                time text
               )
              ''');

      }, 
      onOpen: (Database db) async {
        print('new db opened');
      });
    } else {
      print('Opening existing database');
    }
  }
}
