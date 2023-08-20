import 'package:trackme/core/utils.dart';
import 'package:trackme/models/entities.dart';
import 'package:trackme/providers/pomodoro.dart';
import 'package:workmanager/workmanager.dart';

import 'notification.dart';

const pomodoroTag = 'tag.pomodoro';
const pomodoroStart = 'task.pomodoro.start';
const notificationShow = 'task.notification.show';
const pomodoroStop = 'task.pomodoro.stop';

enum ServiceType {
  pomodoro
}

class BackgroundService {
  static final BackgroundService _instance = BackgroundService();
  static BackgroundService get instance => _instance;

  start(ServiceType service, dynamic data) {
    switch (service) {
      case ServiceType.pomodoro:
        pomodoroStartHandler(false);
        break;
    }
  }

  stop(ServiceType service) {
    switch(service) {
      case ServiceType.pomodoro:
        PomodoroTimer.instance.stop();
        Workmanager().cancelByTag(pomodoroTag);
        break;
    }
  }

  Future<void> pomodoroStartHandler(bool changeCycle) async {
    Pomodoro? current;
    if (changeCycle) {
      current = await PomodoroTimer.instance.nextCycle();
    } else {
      current = await PomodoroTimer.instance.getCurrentCycle();
    }
    if (current == null) return;

    var cycles = PomodoroTimer.instance.cycles;

    int initial = 1;
    var now = DateTime.now();
    for (var i=0; i<cycles.length; i++) {
      var cycle = cycles[i];
      var duration = Duration(seconds: initial);
      var stamp = now.add(duration);
      var message = '${cycle.$1}: ${formatTime(stamp)} - ${formatTime(stamp.add(Duration(seconds: cycle.$2)))}';

      var taskName = i + 1 == cycles.length? pomodoroStart: notificationShow;

      Workmanager().registerOneOffTask(
        '$pomodoroTag-$i',
        taskName,
        tag: pomodoroTag,
        initialDelay: duration,
        inputData: {
          'title': 'Pomodoro',
          'message': message,
          'stamp': stamp.toString(),
        },
      );
      initial += cycle.$2;
    }
  }

  Future<void> showNotification(Map<String, dynamic> input) async {
    DateTime stamp = DateTime.parse(input['stamp']);
    var now = DateTime.now();

    if (stamp.isAfter(now.add(const Duration(seconds: -5)))) {
      await NotificationProvider.instance.show(
        input['title'],
        input['message'],
        id: -1,
      );
    }
  }
}