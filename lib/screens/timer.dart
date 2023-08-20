import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:trackme/core/constants.dart';
import 'package:trackme/core/theme.dart';
import 'package:trackme/models/entities.dart';
import 'package:trackme/providers/background.dart';
import 'package:trackme/providers/database.dart';
import 'package:trackme/providers/pomodoro.dart';
import 'package:trackme/widgets/bars.dart';
import 'package:trackme/widgets/containers.dart';
import 'package:trackme/widgets/texts.dart';
import 'package:trackme/widgets/button.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _InitState();
}

class _InitState extends State<TimerScreen> with WidgetsBindingObserver {
  int _secondsElapsed = 0;
  int _secondsTotal = 1;
  String _currentState = '';
  bool _timerIsActive = false;
  List<Project> _projects = [];
  List<TimeTrack> _tracks = [];
  Project? _currentProject;
  late TableNotifier _notifier;

  @override
  void initState() {
    super.initState();

    _initTimer();
    _refreshNodeList();
    _refreshTimeTracks();
    WidgetsBinding.instance.addObserver(this);
  }

  void _initTimer() {
    _bindPomodoroTimer();
    _notifier = DatabaseProvider.instance.registerObserver(() {
      _refreshNodeList();
    });
  }

  @override
  void dispose() {
    DatabaseProvider.instance.removeObserver(_notifier);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _bindPomodoroTimer();
    }
  }

  void _bindPomodoroTimer() {
    var pomodoro = PomodoroTimer.instance;
    pomodoro.load().then((value) {
      setState(() {
        _timerIsActive = value;
      });
    });
    pomodoro.onTimerTick = (counter, total, state) {
      if (counter > total) {
        return;
      }
      setState(() {
        _secondsElapsed = counter;
        _secondsTotal = total;
        _currentState = state;
      });
    };
  }

  void _refreshNodeList() {
    DatabaseProvider.instance.listProjects().then((value) {
      setState(() {
        _projects = value;
      });
    });
  }

  void _refreshTimeTracks() {
    DatabaseProvider.instance.listTimeTracks(limit: 5).then((value) {
      setState(() {
        _tracks = value;
      });
    });
  }

  String _secondsToHourFormat(int seconds) {
    String number2str(int number) {
      if (number<10) {
        return '0$number';
      }
      return number.toString();
    }

    if (seconds == 0) {
      return '';
    }
    int minutes = seconds ~/ 60;
    int residual = seconds % 60;
    return '${number2str(minutes)}:${number2str(residual)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SimpleTopBar(
        showBorder: true,
        topRightAction: ActionButton(
          icon: const FaIcon(
            FontAwesomeIcons.arrowsRotate,
            size: kActionIconSize,
          ),
          onTap: () {
            _refreshTimeTracks();
            _refreshNodeList();
          },
        ),
      ),
      body: ListView(
        children: [
          SleekCircularSlider(
            min: 0,
            max: _secondsTotal.toDouble(),
            initialValue: _secondsElapsed.toDouble(),
            appearance: CircularSliderAppearance(
              size: 250,
              customColors: CustomSliderColors(
                progressBarColor: blueColor,
              ),
            ),
            innerWidget: (double percentage) {
              return Center(
                child: Headline.h3(
                  _secondsToHourFormat(_secondsElapsed),
                  color: blueColor,
                ),
              );
            },
          ),
          Center(
            child: Paragraph.normal(_currentState),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: xSpacing,),
            child: MyButton.secondary(
              label: _timerIsActive? 'Detener temporizador': 'Iniciar temporizador',
              onTap: () {
                _toggleTimer();
              },
            ),
          ),
          TimeTrackContainer(
              items: _tracks,
              onViewAll: () {}
          )
        ],
      ),
    );
  }

  Future _toggleTimer() async {
    if (_timerIsActive) {
      await PomodoroTimer.instance.stop();
      await BackgroundService.instance.stop(ServiceType.pomodoro);
      _refreshTimeTracks();
      setState(() {
        _timerIsActive = !_timerIsActive;
      });
    } else {
      _showDialog(context);
    }
  }

  Future<void> _showDialog(BuildContext context) async {
    var response = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              title: const Text('Temporizador'),
              backgroundColor: Colors.white,
              content: DropdownButton(
                value: _currentProject,
                onChanged: (value) {
                  setState(() {
                    _currentProject = value;
                  });
                },
                items: List.generate(_projects.length, (index) {
                  return DropdownMenuItem(
                      value: _projects[index],
                      child: Text(_projects[index].name)
                  );
                }),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                    foregroundColor: blueColor,
                  ),
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                    foregroundColor: blueColor,
                  ),
                  child: const Text('Iniciar'),
                  onPressed: () {
                    if (_currentProject == null) return;
                    PomodoroTimer.instance.start(_currentProject!.id, projectType).then((pomodoro) {
                      BackgroundService.instance.start(ServiceType.pomodoro, pomodoro);
                      Navigator.of(context).pop(true);
                    });
                    setState(() {
                      _timerIsActive = true;
                    });
                  },
                ),
              ],
            );
          }
        );
      },
    );

    if (response == true) {
      _refreshTimeTracks();
    }
  }
}
