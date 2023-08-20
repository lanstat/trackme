import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackme/core/theme.dart';
import 'package:trackme/models/entities.dart';
import 'package:trackme/providers/notification.dart';
import 'package:trackme/widgets/bars.dart';
import 'package:trackme/widgets/boxes.dart';
import 'package:trackme/widgets/button.dart';
import 'package:trackme/widgets/containers.dart';
import 'package:trackme/widgets/listviews.dart';
import 'package:trackme/widgets/tabs.dart';
import 'package:trackme/widgets/task_block.dart';
import 'package:trackme/widgets/texts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        topLeftAction: ActionButton(
          onTap: () {
            NotificationProvider.instance.show('Test', 'Test calendart');
          },
          icon: const FaIcon(FontAwesomeIcons.calendar),
        ),
        topRightAction: ActionButton(
          onTap: () {},
          icon: const FaIcon(FontAwesomeIcons.bell),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Headline.h5('Hola, Javier'),
            Paragraph.subtitle('Creemos habitos juntos')
          ],
        ),
        footer: ToggleTab(
          selectedIndex: 0,
          labels: ['Habitos', 'Tareas', 'Gastos'],
          onChangeIndex: (index) {},
        ),
      ),
      backgroundColor: backgroundColor,
      body: ListView(
        children: [
          LinearCalendar(
            init: DateTime.now(),
            selectedDate: _selectedDate,
            onTap: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          const GoalCounter(
            taskCount: 1,
            taskTotal: 3,
          ),
          HabitContainer(
              items: [
                Habit(id: 0, name: 'Caminar', limit: 9000, icon: FontAwesomeIcons.personWalking.codePoint, unitTimes: 'pasos'),
                Habit(id: 1, name: 'Regar plantas', limit: 1, icon: FontAwesomeIcons.houseFloodWater.codePoint),
              ],
              onViewAll: () {}
          ),
          const TaskBlock(),
        ],
      ),
    );
  }

}