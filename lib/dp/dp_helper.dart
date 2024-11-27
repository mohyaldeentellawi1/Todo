import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'dart:io';
import '../models/task.dart';

class DpHelper {
  static Database? _dp;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initDp() async {
    if (_dp != null) {
      debugPrint('not null dp');
      return;
    } else {
      try {
        String path = '${await getDatabasesPath()}tasks.dp';
        debugPrint('in database path $path');
        path = join(await getDatabasesPath(), 'tasks.dp');
        String dir = await getDatabasesPath();
        if (await Directory(dir).exists() == false) {
          await Directory(dir).create(recursive: true);
        }
        log('in database path $path');
        _dp = await openDatabase(
          path,
          version: _version,
          onCreate: (Database db, int version) async {
            await db.execute(
              'CREATE TABLE $_tableName ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title TEXT, note TEXT, date INTEGER,'
              'startTime TEXT, endTime TEXT,'
              'remind INTEGER, repeat TEXT,'
              'color INTEGER,'
              'isCompleted INTEGER)',
            );
          },
        );
        log('Database Created');
      } catch (e) {
        log('Error in creating database $e');
      }
    }
  }

  static Future<int> insert(Task task) async {
    log('insert something');
    try {
      return await _dp!.insert(_tableName, task.toJson());
    } catch (e) {
      log('We are Here');
      return 9000;
    }
  }

  static Future<int> delete(Task task) async {
    log('Delete');
    return await _dp!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> deleteAll() async {
    log('Delete All');
    return await _dp!.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    log('query');
    return await _dp!.query(_tableName);
  }

  static Future<int> update(Task task) async {
    log('Update');
    return await _dp!.rawUpdate('''
    UPDATE tasks 
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, task.id]);
  }
}
