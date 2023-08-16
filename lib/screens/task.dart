import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackme/core/constants.dart';
import 'package:trackme/core/theme.dart';
import 'package:trackme/models/entities.dart';
import 'package:trackme/providers/database.dart';
import 'package:trackme/widgets/bars.dart';
import 'package:trackme/widgets/boxes.dart';
import 'package:trackme/widgets/button.dart';
import 'package:trackme/widgets/listviews.dart';
import 'package:trackme/widgets/texts.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _InitState();
}

class _InitState extends State<TaskScreen> {
  var _tasks = <Task>[];

  @override
  void initState() {
    _refreshList();
    super.initState();
  }

  void _refreshList() {
    DatabaseProvider.instance.listTasks().then((value) {
      setState(() {
        _tasks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child:ListView(
          children: [
            SimpleTopBar(
              onBack: () {},
              title: Paragraph.title('Tareas'),
              showBorder: true,
            ),
            const SizedBox(height: ySpacing,),
            ColumnBuilder(
              count: _tasks.length,
              spacer: const SizedBox(height: ySpacing),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                  },
                  child: BorderContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Paragraph.normal(_tasks[index].title),
                        ActionButton(
                            icon: const FaIcon(FontAwesomeIcons.trash),
                            onTap: () async {
                              await DatabaseProvider.instance.delete(_tasks[index]);
                              _refreshList();
                            }
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueColor,
        foregroundColor: whiteColor,
        onPressed: () {
        },
        child: const FaIcon(
            FontAwesomeIcons.plus
        ),
      ),
    );
  }
}
