import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackme/core/constants.dart';
import 'package:trackme/core/theme.dart';
import 'package:trackme/screens/settings.dart';
import 'package:trackme/widgets/bars.dart';
import 'package:trackme/widgets/button.dart';
import 'package:trackme/widgets/texts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _InitState();
}

class _InitState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SimpleTopBar(
        title: Paragraph.title('Tu perfil'),
        topRightAction: ActionButton(
          icon: const FaIcon(
            FontAwesomeIcons.gears,
            size: kActionIconSize,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingScreen()),
            );
          },
        ),
      ),
    );
  }
}
