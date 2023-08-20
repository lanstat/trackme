import 'dart:async';

import 'package:trackme/models/entities.dart';
import 'package:trackme/providers/database.dart';

typedef OnTimerTick = void Function(int counter, int total, String state);

class PomodoroTimer {
  static final PomodoroTimer _instance = PomodoroTimer._();
  static PomodoroTimer get instance => _instance;
  PomodoroTimer._();
  static const int _seconds = 60;

  static const int _focusTime = 20 * _seconds;
  static const int _breakTime = 5 * _seconds;
  static const int _longBreakTime = 15 * _seconds;

  final List<(String, int)> _cycles = [
    ('Concentracion', _focusTime),
    ('Descanso', _breakTime),
    ('Concentracion', _focusTime),
    ('Descanso', _breakTime),
    ('Concentracion', _focusTime),
    ('Descanso', _breakTime),
    ('Concentracion', _focusTime),
    ('Descanso largo', _longBreakTime),
  ];

  Timer? _timer;
  OnTimerTick? onTimerTick;

  List<(String, int)> get cycles => _cycles;

  Future<bool> load() async {
    var current = await nextCycle();
    if (current == null) return false;

    var now = DateTime.now();
    _startCycle(current.cycle, now.difference(current.init).inSeconds);

    return true;
  }

  Future<Pomodoro> start(int nodeId, int nodeType) async {
    var first = _cycles.first;
    var init = DateTime.now();
    var end = init.add(Duration(seconds: first.$2));
    var record = Pomodoro(
      init: init,
      end: end,
      cycle: 0,
      cycleName: first.$1,
      nodeId: nodeId,
      nodeType: nodeType,
      created: init,
    );
    await DatabaseProvider.instance.insertPomodoro(record);
    _startCycle(0, 0);

    return record;
  }

  Future<void> stop() async {
    _timer?.cancel();

    var current = await DatabaseProvider.instance.getPomodoro();
    if (current == null) return;

    var elapsed = DateTime.now().difference(current.created).inMinutes;
    if (elapsed <= 1) {
      elapsed = 1;
    }

    // TODO Verificar cuando sea tarea
    var timeTrack = TimeTrack(
      id: 0,
      projectId: current.nodeId,
      created: current.created,
      minutes: elapsed,
      taskId: null
    );

    await DatabaseProvider.instance.insert(timeTrack);
    await DatabaseProvider.instance.deletePomodoro();
    onTimerTick!(0, 1, '');
  }

  _startCycle(int cycle, int counter) {
    _timer?.cancel();
    if (cycle >= _cycles.length) {
      cycle = 0;
    }
    var description = _cycles[cycle];
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      counter++;
      onTimerTick!(counter, description.$2, description.$1);
      if (counter >= description.$2) {
        _startCycle(cycle+1, 0);
      }
    });
  }

  Future<Pomodoro?> getCurrentCycle() async {
    return DatabaseProvider.instance.getPomodoro();
  }

  Future<Pomodoro?> nextCycle() async {
    var current = await DatabaseProvider.instance.getPomodoro();
    if (current == null) return null;

    var now = DateTime.now();
    if (current.end.isAfter(now)) {
      return current;
    }

    var next = current.cycle;
    var init = now;
    var end = current.end;
    while (!end.isAfter(now)) {
      next++;
      if (next >= _cycles.length) {
        next = 0;
      }
      init = end;
      end = end.add(Duration(seconds: _cycles[next].$2));
    }

    var cycle = _cycles[next];

    current.init = init;
    current.end = end;
    current.cycle = next;
    current.cycleName = cycle.$1;

    await DatabaseProvider.instance.updatePomodoro(current);

    return current;
  }
}