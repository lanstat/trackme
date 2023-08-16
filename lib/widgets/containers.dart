import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:trackme/core/constants.dart';
import 'package:trackme/models/abstracts.dart';
import 'package:trackme/core/theme.dart';
import 'package:trackme/models/entities.dart';
import 'package:trackme/widgets/boxes.dart';
import 'package:trackme/widgets/texts.dart';

class HabitContainer extends StatelessWidget {
  final List<Habit> items;
  final void Function() onViewAll;

  const HabitContainer({
    super.key,
    required this.items,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    children.add(Padding(
      padding: const EdgeInsets.all(ySpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Paragraph.title('Habitos'),
          Link(
            text: 'Ver mas',
            onTap: onViewAll,
          )
        ],
      ),
    ));

    int index = 0;
    for (var item in items) {
      children.add(_buildCompletable(index, item));
      children.add(const SizedBox(height: ySpacing,));
      index++;
    }

    return Column(
      children: children,
    );
  }

  Widget _buildCompletable(int index, Habit item) {
    return Slidable(
      key: ValueKey(index),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {},),
        children: [
          SlidableAction(
            onPressed: (BuildContext context){},
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
            onPressed: (BuildContext context){},
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
        dismissible: DismissiblePane(onDismissed: () {},),
        children: [
          SlidableAction(
            onPressed: (BuildContext context){},
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
            onPressed: (BuildContext context){},
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
        child: Row(
          children: [
            SleekCircularSlider(
              min: item.min.toDouble(),
              max: item.max.toDouble(),
              initialValue: item.count.toDouble(),
              appearance: CircularSliderAppearance(
                size: 40,
                customColors: CustomSliderColors(
                  progressBarColor: blueColor,
                ),
              ),
              innerWidget: (double percentage) {
                return Center(
                  child: FaIcon(
                    item.iconData(),
                    color: blueColor,
                  ),
                );
              },
            ),
            const SizedBox(width: 5,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Paragraph.normal(item.title),
                Paragraph.subtitle('${item.count}/${item.max} ${item.subtitle.toUpperCase()}')
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimeTrackContainer extends StatelessWidget {
  final List<TimeTrack> items;
  final void Function() onViewAll;

  const TimeTrackContainer({
    super.key,
    required this.items,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    children.add(Padding(
      padding: const EdgeInsets.all(ySpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Paragraph.title('Seguimiento'),
          Link(
            text: 'Ver mas',
            onTap: onViewAll,
          )
        ],
      ),
    ));

    int index = 0;
    for (var item in items) {
      children.add(_buildCompletable(index, item));
      children.add(const SizedBox(height: ySpacing,));
      index++;
    }

    return Column(
      children: children,
    );
  }

  Widget _buildCompletable(int index, TimeTrack item) {
    return BorderContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Paragraph.normal(item.project.name),
            Paragraph.subtitle('${item.minutes} MINUTOS')
          ],
        )
    );
  }
}

class ActionTile {
  IconData icon;
  String label;
  void Function() onTap;

  ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class SlideTile extends StatelessWidget {
  final int index;
  final bool startIsDismissible;
  final bool endIsDismissible;
  final List<ActionTile>? start;
  final List<ActionTile>? end;
  final Widget child;
  final void Function() onTap;

  const SlideTile({
    super.key,
    required this.index,
    this.startIsDismissible = false,
    this.start,
    this.endIsDismissible = false,
    this.end,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ActionPane? startPane;
    ActionPane? endPane;
    if (start != null) {
      startPane = ActionPane(
        motion: const ScrollMotion(),
        dismissible: startIsDismissible? DismissiblePane(onDismissed: () {},): null,
        children: List.generate(start!.length, (index) {
          return SlidableAction(
            onPressed: (BuildContext context){
              start![index].onTap();
            },
            backgroundColor: whiteColor,
            icon: FaIcon(
              start![index].icon,
              color: blueColor,
            ),
            label: start![index].label,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15)
            ),
          );
        })
      );
    }
    if (end != null) {
      endPane = ActionPane(
        motion: const ScrollMotion(),
        dismissible: endIsDismissible? DismissiblePane(onDismissed: () {},): null,
        children: List.generate(end!.length, (index) {
          return SlidableAction(
            onPressed: (BuildContext context){
              end![index].onTap();
            },
            backgroundColor: whiteColor,
            icon: FaIcon(
              end![index].icon,
              color: blueColor,
            ),
            label: end![index].label,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15)
            ),
          );
        }),
      );
    }
    return Slidable(
      key: ValueKey(index),
      startActionPane: startPane,
      endActionPane: endPane,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: whiteColor,
            border: Border.symmetric(
              vertical: BorderSide(
                color: grayColor,
                width: 1
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

}