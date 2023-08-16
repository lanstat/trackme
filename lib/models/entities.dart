import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackme/models/abstracts.dart';

const projectType = 1;
const taskType = 2;

class Habit {
  int id;
  String title;
  String subtitle;
  int count;
  int min;
  int max;
  int icon;

  Habit({
    required this.id,
    required this.title,
    required this.count,
    required this.max,
    required this.icon,
    this.subtitle = '',
    this.min = 0,
  });

  IconData iconData() {
    return IconDataSolid(icon);
  }
}

class Project implements DataSerial {
  int id;
  String name;

  static const String createSQL = 'CREATE TABLE project(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)';

  Project({
    required this.id,
    required this.name,
  });

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  @override
  int tableId() {
    return id;
  }

  @override
  String tableName() {
    return 'project';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Project.fromMap(Map<String, dynamic> record) {
    return Project(
      id: record['id'],
      name: record['name'],
    );
  }

}

class Task implements DataSerial {
  int id;
  String title;
  int projectId;
  DateTime created;
  DateTime? due;
  DateTime? finished;
  int status;
  late Project project;

  static const int pending = 1;
  static const int successful = 2;
  static const int failed = 3;

  static const String createSQL = 'CREATE TABLE task(id INTEGER PRIMARY KEY, title TEXT NOT NULL, projectId INTEGER NOT NULL, created TEXT NOT NULL, due TEXT NULL, finished TEXT NULL, status INT NOT NULL);';

  Task({
    required this.id,
    required this.title,
    required this.projectId,
    required this.created,
    this.due,
    this.finished,
    this.status = pending,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    var instance = Task(
      id: map['id'],
      title: map['title'],
      projectId: map['projectId'],
      created: DateTime.parse(map['created']),
      due: map['due'] == null? null: DateTime.parse(map['due']),
      finished: map['finished'] == null? null: DateTime.parse(map['finished']),
      status: map['status'],
    );

    instance.project = Project(
      id: instance.projectId,
      name: map['projectName']
    );

    return instance;
  }

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  @override
  int tableId() {
    return id;
  }

  @override
  String tableName() {
    return 'task';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'projectId': projectId,
      'created': created.toString(),
      'due': due?.toString(),
      'finished': finished?.toString(),
      'status': status,
    };
  }
}

class TimeTrack implements DataSerial {
  int id;
  int projectId;
  int? taskId;
  DateTime created;
  int minutes;
  late Project project;

  static const String createSQL = 'CREATE TABLE timeTrack(id INTEGER PRIMARY KEY, projectId INTEGER NOT NULL, taskId INTEGER NULL, created TEXT NOT NULL, minutes INT NOT NULL);';

  TimeTrack({
    required this.id,
    required this.projectId,
    required this.created,
    required this.minutes,
    this.taskId,
  });

  factory TimeTrack.fromMap(Map<String, dynamic> record) {
    var instance = TimeTrack(
      id: record['id'],
      projectId: record['projectId'],
      created: DateTime.parse(record['created']),
      taskId: record['taskId'],
      minutes: record['minutes'],
    );

    instance.project = Project(
      id: instance.projectId,
      name: record['projectName']
    );

    return instance;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'taskId': taskId,
      'created': created.toString(),
      'minutes': minutes
    };
  }

  @override
  int tableId() {
    return id;
  }

  @override
  String tableName() {
    return 'timeTrack';
  }
}

class Pomodoro {
  DateTime init;
  DateTime end;
  int cycle;
  String cycleName;
  int nodeId;
  int nodeType;
  DateTime created;

  static const String createSQL = 'CREATE TABLE pomodoro(init TEXT, end TEXT, cycle int, cycleName TEXT, nodeId INT, nodeType INT, created TEXT)';

  Pomodoro({
    required this.init,
    required this.end,
    required this.cycle,
    required this.cycleName,
    required this.nodeId,
    required this.nodeType,
    required this.created,
  });

  Map<String, dynamic> toMap() {
    return {
      'init': init.toString(),
      'end': end.toString(),
      'cycle': cycle,
      'cycleName': cycleName,
      'nodeId': nodeId,
      'nodeType': nodeType,
      'created': created.toString(),
    };
  }

  factory Pomodoro.fromMap(Map<String, dynamic> record) {
    return Pomodoro(
      init: DateTime.parse(record['init']),
      end: DateTime.parse(record['end']),
      cycle: record['cycle'],
      cycleName: record['cycleName'],
      nodeId: record['nodeId'],
      nodeType: record['nodeType'],
      created: DateTime.parse(record['created']),
    );
  }
}