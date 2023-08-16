import 'package:trackme/models/entities.dart';
import 'package:trackme/providers/pomodoro.dart';
import 'package:workmanager/workmanager.dart';

import 'notification.dart';

const pomodoroKey = 'key.pomodoro';
const pomodoroStart = 'task.pomodoro.start';
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
        Workmanager().cancelByUniqueName(pomodoroKey);
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

    var delay = current.end.difference(current.init).inSeconds;

    NotificationProvider.instance.show('Pomodoro', 'Activo en ${current.cycleName}');
    Workmanager().registerOneOffTask(pomodoroKey, pomodoroStart, initialDelay: Duration(seconds: delay));
  }
}