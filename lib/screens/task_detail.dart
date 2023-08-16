import 'package:flutter/gestures.dart';
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

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key});

  @override
  State<TaskDetailScreen> createState() => _InitState();
}

class _InitState extends State<TaskDetailScreen> {
  var _projects = <Project>[];
  final _titleController = TextEditingController();
  Project? _selectedProject;

  @override
  void initState() {
    _refreshProjectList();
    super.initState();
  }

  void _refreshProjectList() {
    DatabaseProvider.instance.listProjects().then((value) {
      setState(() {
        _projects = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SimpleTopBar(
        onBack: () {},
        title: Paragraph.title('Tareas'),
        showBorder: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(xSpacing),
        children: [
          Paragraph.legend('Titulo'),
          TextField(
            controller: _titleController,
          ),
          const SizedBox(height: ySpacing,),
          Paragraph.legend('Proyecto'),
          DropdownButton(
            isExpanded: true,
            value: _selectedProject,
            onChanged: (value) {
              setState(() {
                _selectedProject = value;
              });
            },
            items: List.generate(_projects.length, (index) {
              return DropdownMenuItem(
                  value: _projects[index],
                  child: Text(_projects[index].name)
              );
            }),
          ),
          const SizedBox(height: ySpacing,),
          Paragraph.legend('Vencimiento'),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(xSpacing),
        child: MyButton.primary(
          label: 'Guardar tarea',
          height: kBottomNavigationBarHeight,
          onTap: () {
            if (_selectedProject == null) return;

            var record = Task(
              id: 0,
              title: _titleController.text,
              projectId: _selectedProject?.id ?? 0,
              created: DateTime.now()
            );
            DatabaseProvider.instance.insert(record).then((value) {
              Navigator.of(context).pop();
            });
          }
        ),
      ),
    );
  }
}
