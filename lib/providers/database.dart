import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trackme/models/abstracts.dart';
import 'package:trackme/models/entities.dart';
import 'package:trackme/providers/filesystem.dart';

typedef TableNotifier = void Function();

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._();
  static DatabaseProvider get instance => _instance;
  DatabaseProvider._();

  late Future<Database> _database;
  var _isInitialized = false;
  static const String dbFile = 'db.json';
  static const int _dbVersion = 2;

  final _observers = <TableNotifier>[];

  Future<void> _onCreate(Database db) async {
    await db.execute(TimeTrack.createSQL);
    await db.execute(Pomodoro.createSQL);
    await db.execute(Project.createSQL);
    await db.execute(Task.createSQL);
    await db.execute(MoneyTrack.createSQL);
  }

  Future<void> _onDrop(Database db) async {
    await _executeUnconditionally(db, TimeTrack.dropSql);
    await _executeUnconditionally(db, Pomodoro.dropSql);
    await _executeUnconditionally(db, Project.dropSql);
    await _executeUnconditionally(db, Task.dropSql);
    await _executeUnconditionally(db, MoneyTrack.dropSql);
  }

  Future<void> _executeUnconditionally(Database db, String sql) async {
    try {
      await db.execute(sql);
    } catch(e) {
      // Prevent elevate exception
    }
  }

  Future<void> _export(Database db) async {
    final merger = <String, dynamic>{};

    var project = Project.empty();
    merger[project.tableName()] = await _readAllRaw(db, project.tableName());

    var task = Task.empty();
    merger[task.tableName()] = await _readAllRaw(db, task.tableName());

    var timeTracker = TimeTrack.empty();
    merger[timeTracker.tableName()] = await _readAllRaw(db, timeTracker.tableName());

    var moneyTracker = MoneyTrack.empty();
    merger[moneyTracker.tableName()] = await _readAllRaw(db, moneyTracker.tableName());

    var encode = jsonEncode(merger);
    await FilesystemProvider.instance.writeFile(DirectoryType.cache, dbFile, encode);
  }

  Future<void> _import(Database db) async {
    final db = DatabaseProvider.instance;
    final raw = await FilesystemProvider.instance.readFile(DirectoryType.cache, dbFile);
    var decode = jsonDecode(raw);

    var project = Project.empty();
    var list = decode[project.tableName()];
    for (var record in list) {
      await db.insert(Project.fromMap(record));
    }

    var task = Task.empty();
    list = decode[task.tableName()];
    for (var record in list) {
      await db.insert(Task.fromMap(record));
    }

    var track = TimeTrack.empty();
    list = decode[track.tableName()];
    for (var record in list) {
      await db.insert(TimeTrack.fromMap(record));
    }

    var money = MoneyTrack.empty();
    list = decode[money.tableName()];
    for (var record in list) {
      await db.insert(MoneyTrack.fromMap(record));
    }
  }

  Future<void> initialize() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'task_database.db'),
      onCreate: (db, version) async {
        _onCreate(db);
      },
      onUpgrade: (db, previous, current) async {
        _export(db);
        _onDrop(db);
        _onCreate(db);
        _import(db);
      },
      version: _dbVersion,
    );
    _isInitialized = true;
  }

  TableNotifier registerObserver(TableNotifier callback) {
    _observers.add(callback);
    return callback;
  }

  void removeObserver(TableNotifier callback) {
    _observers.remove(callback);
  }

  void _notifyObserver() {
    for (var observer in _observers) {
      observer();
    }
  }

  bool get isInitialized {
    return _isInitialized;
  }

  Future<void> export() async {
    final db = await _database;
    return _export(db);
  }

  Future<void> import() async {
    final db = await _database;
    return _import(db);
  }

  Future<void> insertPomodoro(Pomodoro record) async {
    final db = await _database;
    await db.insert('pomodoro', record.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updatePomodoro(Pomodoro record) async {
    final db = await _database;
    await db.update('pomodoro', record.toMap());
  }

  Future<void> deletePomodoro() async {
    final db = await _database;
    await db.delete('pomodoro');
  }

  Future<Pomodoro?> getPomodoro() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('pomodoro');

    if (maps.isEmpty) return null;
    return List.generate(maps.length, (index) => Pomodoro.fromMap(maps[index])).first;
  }

  Future<void> insert(DataSerial record) async {
    final db = await _database;
    var map = record.toMap();
    map.remove('id');
    await db.insert(record.tableName(), map, conflictAlgorithm: ConflictAlgorithm.replace);

    _notifyObserver();
  }

  Future<void> update(DataSerial record) async {
    final db = await _database;
    await db.update(record.tableName(), record.toMap(), where: 'id = ?', whereArgs: [record.tableId()]);

    _notifyObserver();
  }

  Future<void> delete(DataSerial record) async {
    final db = await _database;
    await db.delete(record.tableName(), where: 'id = ?', whereArgs: [record.tableId()]);

    _notifyObserver();
  }

  Future<List<Map<String, dynamic>>> _readAllRaw(Database db, String tableName) async {
    try {
      var list = await db.query(tableName);
      return list;
    } catch (ex) {
      return [];
    }
  }

  Future<List<Project>> listProjects() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('project');

    return List.generate(maps.length, (index) => Project.fromMap(maps[index]));
  }

  Future<List<TimeTrack>> listTimeTracks({int limit = 0}) async {
    final db = await _database;
    String query = 'SELECT t.id, projectId, taskId, created, minutes, p.name projectName '
        'FROM timeTrack t INNER JOIN project p ON p.id = t.projectId';

    query = '$query ORDER BY t.id DESC';

    if (limit > 0) {
      query = '$query LIMIT $limit';
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    return List.generate(maps.length, (index) => TimeTrack.fromMap(maps[index]));
  }

  Future<List<Task>> listTasks({
    int limit = 0,
    bool showFinished = false,
  }) async {
    final db = await _database;
    String query = 'SELECT t.id, title, projectId, created, due, finished, p.name projectName, status '
        'FROM task t INNER JOIN project p ON p.id = t.projectId';

    String where = '';
    if (!showFinished) {
      where = '$where finished IS NULL';
    }

    if (where.isNotEmpty) {
      query = '$query WHERE $where';
    }

    query = '$query ORDER BY t.id DESC';

    if (limit > 0) {
      query = '$query LIMIT $limit';
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    return List.generate(maps.length, (index) => Task.fromMap(maps[index]));
  }

  Future<List<Task>> listTasksToDo({required DateTime date}) async {
    final db = await _database;
    String query = 'SELECT t.id, title, projectId, created, due, finished, p.name projectName, status '
        'FROM task t INNER JOIN project p ON p.id = t.projectId '
        'WHERE t.created <= \'${DateUtils.dateOnly(date.add(const Duration(days: 1))).toString()}\' '
        'AND t.finished IS NULL ';

    query = '$query ORDER BY t.id DESC';

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    return List.generate(maps.length, (index) => Task.fromMap(maps[index]));
  }
}
