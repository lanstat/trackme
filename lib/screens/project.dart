import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackme/core/constants.dart';
import 'package:trackme/core/theme.dart';
import 'package:trackme/models/entities.dart';
import 'package:trackme/providers/database.dart';
import 'package:trackme/widgets/bars.dart';
import 'package:trackme/widgets/boxes.dart';
import 'package:trackme/widgets/button.dart';
import 'package:trackme/widgets/containers.dart';
import 'package:trackme/widgets/listviews.dart';
import 'package:trackme/widgets/texts.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _InitState();
}

class _InitState extends State<ProjectScreen> {
  var _projects = <Project>[];
  final _formController = TextEditingController();
  Project? _currentProject;

  @override
  void initState() {
    _refreshList();
    super.initState();
  }

  void _refreshList() {
    _currentProject = null;
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
      body: SafeArea(
        child:ListView(
          children: [
            SimpleTopBar(
              onBack: () {},
              title: Paragraph.title('Proyectos'),
              showBorder: true,
            ),
            const SizedBox(height: ySpacing,),
            ColumnBuilder(
              count: _projects.length,
              spacer: const SizedBox(height: ySpacing),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    _currentProject = _projects[index];
                    _showDialog(context);
                  },
                  child: BorderContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Paragraph.normal(_projects[index].name),
                        ActionButton(
                          icon: const FaIcon(FontAwesomeIcons.trash),
                          onTap: () async {
                            await DatabaseProvider.instance.delete(_projects[index]);
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
          _showDialog(context);
        },
        child: const FaIcon(
            FontAwesomeIcons.plus
        ),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context) {
    _formController.text = _currentProject?.name ?? '';
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Proyecto'),
          backgroundColor: Colors.white,
          content: TextField(
            decoration: const InputDecoration(
              labelText: 'Nombre'
            ),
            controller: _formController,
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
              child: const Text('Guardar'),
              onPressed: () {
                DatabaseProvider.instance.insert(Project(id: _currentProject?.id ?? 0, name: _formController.text)).then((value) {
                  _refreshList();
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
