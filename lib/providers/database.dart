import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trackme/models/abstracts.dart';
import 'package:trackme/models/entities.dart';

typedef TableNotifier = void Function();

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider();
  static DatabaseProvider get instance => _instance;

  late Future<Database> _database;
  var _isInitialized = false;

  final _observers = <TableNotifier>[];

  Future<void> initialize() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'task_database.db'),
      onCreate: (db, version) async {
        await db.execute(TimeTrack.createSQL);
        await db.execute(Pomodoro.createSQL);
        await db.execute(Project.createSQL);
        await db.execute(Task.createSQL);
      },
      version: 1,
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

  Future<List<Task>> listTasks({int limit = 0, bool showFinished = false}) async {
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
}
