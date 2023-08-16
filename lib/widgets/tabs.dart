import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:trackme/core/theme.dart';

class ToggleTab extends StatelessWidget {
  final Function(int) onChangeIndex;
  final List<String> labels;
  final int selectedIndex;

  const ToggleTab({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChangeIndex
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlutterToggleTab(
        width: 90,
        height: 35,
        labels: labels,
        selectedIndex: selectedIndex,
        selectedLabelIndex: onChangeIndex,
        selectedTextStyle: const TextStyle(
          color: blueColor,
        ),
        unSelectedTextStyle: const TextStyle(
          color: Color.fromRGBO(161, 162, 169, 1),
        ),
        selectedBackgroundColors: const [whiteColor],
        marginSelected: const EdgeInsets.all(3),
      ),
    );
  }

}