import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackme/core/constants.dart';
import 'package:trackme/core/theme.dart';
import 'package:trackme/screens/task_detail.dart';
import 'package:trackme/widgets/boxes.dart';
import 'package:trackme/widgets/texts.dart';

Widget _buildAdd(IconData icon) => Container(
  width: kBottomNavigationBarHeight,
  height: kBottomNavigationBarHeight,
  decoration: BoxDecoration(
    gradient: blueGradient,
    borderRadius: BorderRadius.circular(50),
  ),
  child: Center(
    child: FaIcon(
      icon,
      color: whiteColor,
    ),
  ),
);

class MainNavbar extends StatelessWidget {
  final ValueChanged<int> onTap;
  final int selectedIndex;

  const MainNavbar({
    super.key,
    required this.onTap,
    required this.selectedIndex
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int index) {
          onTap(index);
        },
        selectedItemColor: blueColor,
        unselectedItemColor: grayColor,
        currentIndex: selectedIndex,
        items: <BottomNavigationBarItem> [
          const BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.house,
              ),
              label: 'Home'
          ),
          const BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.hourglass,
              ),
              label: 'Timer'
          ),
          BottomNavigationBarItem(
              icon: _buildAdd(FontAwesomeIcons.plus),
              label: 'Add'
          ),
          const BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.arrowTrendUp,
              ),
              label: 'Trends'
          ),
          const BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.person,
              ),
              label: 'Settings'
          ),
        ]
    );
  }
}

class AddMenu extends StatelessWidget {
  const AddMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: ySpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                    child: BorderContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Paragraph.title('Crear habito'),
                          Paragraph.subtitle('Crear un nuevo habito')
                        ],
                      ),
                    ),
                  )
              ),
              Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => const TaskDetailScreen()
                        )
                      );
                    },
                    child: BorderContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Paragraph.title('Crear tarea'),
                          Paragraph.subtitle('Agregar nuevo todo')
                        ],
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: ySpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                    child: BorderContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Paragraph.title('Crear gasto'),
                          Paragraph.subtitle('Crear un nuevo gasto')
                        ],
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: ySpacing * 2),
            child: Center(
              child: _buildAdd(FontAwesomeIcons.xmark),
            ),
          )
        ),
      ],
    );
  }
}