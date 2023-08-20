import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackme/core/constants.dart';
import 'package:trackme/core/theme.dart';
import 'package:trackme/models/entities.dart';
import 'package:trackme/providers/database.dart';
import 'package:trackme/screens/task.dart';
import 'package:trackme/screens/task_detail.dart';
import 'package:trackme/widgets/boxes.dart';
import 'package:trackme/widgets/texts.dart';

class TaskBlock extends StatefulWidget {
  const TaskBlock({super.key});

  @override
  State<TaskBlock> createState() => _InitState();
}

class _InitState extends State<TaskBlock> {
  List<Task> _items = [];
  late TableNotifier _notifier;

  @override
  void initState() {
    _refreshList();
    _notifier = DatabaseProvider.instance.registerObserver(() {
      _refreshList();
    });
    super.initState();
  }

  @override
  void dispose() {
    DatabaseProvider.instance.removeObserver(_notifier);
    super.dispose();
  }

  void _refreshList() {
    DatabaseProvider.instance.listTasksToDo(date: DateTime.now()).then((value) {
      setState(() {
        _items = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    children.add(Padding(
      padding: const EdgeInsets.all(ySpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Paragraph.title('Tareas'),
          Link(
            text: 'Ver mas',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaskScreen()),
              );
            },
          )
        ],
      ),
    ));

    int index = 0;
    for (var item in _items) {
      children.add(_buildCompletable(index, item));
      children.add(const SizedBox(height: ySpacing,));
      index++;
    }

    return Column(
      children: children,
    );
  }

  Widget _buildCompletable(int index, Task item) {
    return Slidable(
      key: ValueKey(index),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TaskDetailScreen()
                )
              );
            },
            backgroundColor: whiteColor,
            icon: const FaIcon(
              FontAwesomeIcons.eye,
              color: blueColor,
            ),
            label: 'Ver',
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15)
            ),
          ),
          SlidableAction(
            onPressed: (BuildContext context) {
              _finishTask(_items[index]);
            },
            backgroundColor: whiteColor,
            icon: const FaIcon(
              FontAwesomeIcons.check,
              color: greenColor,
            ),
            label: 'Listo',
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15)
            ),
            spacing: 10,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context){
              _failTask(_items[index]);
            },
            backgroundColor: whiteColor,
            icon: const FaIcon(
              FontAwesomeIcons.xmark,
              color: redColor,
            ),
            label: 'Fallo',
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15)
            ),
          ),
          SlidableAction(
            onPressed: (BuildContext context){
              _passTask(_items[index]);
            },
            backgroundColor: whiteColor,
            icon: const FaIcon(
              FontAwesomeIcons.chevronRight,
            ),
            label: 'Saltar',
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15)
            ),
            spacing: 10,
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(
              color: grayColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Paragraph.normal(item.title),
            Paragraph.subtitle(item.project.name)
          ],
        ),
      ),
    );
  }

  void _finishTask(Task record) {
    record.finished = DateTime.now();
    record.status = Task.successful;
    DatabaseProvider.instance.update(record);
  }

  void _failTask(Task record) {
    record.finished = DateTime.now();
    record.status = Task.failed;
    DatabaseProvider.instance.update(record);
  }

  void _passTask(Task record) {
    record.created = DateTime.now().add(const Duration(days: 1));
    DatabaseProvider.instance.update(record);
  }
}
