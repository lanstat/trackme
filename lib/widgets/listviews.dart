import 'package:flutter/material.dart';
import 'package:trackme/core/constants.dart';
import 'package:trackme/widgets/button.dart';
import 'package:trackme/widgets/texts.dart';

final nameDays = [
  'LUN',
  'MAR',
  'MIE',
  'JUE',
  'VIE',
  'SAB',
  'DOM',
];

class LinearCalendar extends StatelessWidget {
  final DateTime init;
  final int count;
  final void Function(DateTime) onTap;
  final DateTime selectedDate;

  const LinearCalendar({
    super.key,
    required this.init,
    required this.onTap,
    required this.selectedDate,
    this.count = 30,
  });

  @override
  Widget build(BuildContext context) {
    var tmp = DateUtils.dateOnly(init);
    var selected = DateUtils.dateOnly(selectedDate);
    var items = List.generate(count, (index) => tmp.add(Duration(days: index)));
    return Padding(
      padding: const EdgeInsets.only(top: ySpacing),
      child: SizedBox(
          width: double.infinity,
          height: 70,
          child: ListView.builder(
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                var active = items[index] == selected;
                return Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: ToggleButton(
                    width: 50,
                    active: active,
                    icon: Column(
                      children: [
                        Paragraph.title(items[index].day.toString()),
                        Paragraph.subtitle(nameDays[items[index].weekday - 1])
                      ],
                    ),
                    onTap: () {
                      onTap(items[index]);
                    }
                  ),
                );
              }
          )
      ),
    );
  }
}

typedef ItemBuilder = Widget Function(BuildContext context, int index);

class ColumnBuilder extends StatelessWidget {
  final ItemBuilder itemBuilder;
  final int count;
  final Widget? spacer;

  const ColumnBuilder({
    super.key,
    required this.itemBuilder,
    required this.count,
    this.spacer,
  });

  @override
  Widget build(BuildContext context) {
    var list = <Widget>[];

    int i = 0;
    while (i < count) {
      list.add(itemBuilder(context, i));
      if (spacer != null) {
        list.add(spacer!);
      }
      i++;
    }

    return Column(
      children: list,
    );
  }
}