import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:share_plus/share_plus.dart';
import 'package:trackme/core/constants.dart';
import 'package:trackme/core/theme.dart';
import 'package:trackme/providers/database.dart';
import 'package:trackme/providers/filesystem.dart';
import 'package:trackme/screens/project.dart';
import 'package:trackme/widgets/bars.dart';
import 'package:trackme/widgets/boxes.dart';
import 'package:trackme/widgets/button.dart';
import 'package:trackme/widgets/texts.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _InitState();
}

class _InitState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SimpleTopBar(
        onBack: () {},
        title: Paragraph.title('Configuracion'),
        showBorder: true,
      ),
      body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(xSpacing),
              child: Paragraph.subtitle('General'),
            ),
            BorderContainer(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.businessTime),
                    title: Paragraph.normal('Proyectos'),
                    trailing: const FaIcon(FontAwesomeIcons.chevronRight),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProjectScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.fileExport),
                    title: Paragraph.normal('Exportar base de datos'),
                    onTap: () async {
                      await DatabaseProvider.instance.export();
                      /*
                      final result = await Share.shareXFiles([XFile(dbExport.path)]);

                      if (result.status == ShareResultStatus.success) {
                        _showSnackBar('Importacion compartida');
                      }
                      */
                    },
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.fileImport),
                    title: Paragraph.normal('Importar base de datos'),
                    onTap: () async {
                      await DatabaseProvider.instance.import();
                    },
                  ),
                ],
              )
            ),
          ],
        ),
    );
  }

  _showSnackBar(String message) {
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
