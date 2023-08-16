import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:trackme/core/constants.dart';
import 'package:trackme/core/theme.dart';
import 'package:trackme/widgets/knot.dart';
import 'package:trackme/widgets/texts.dart';

class GoalCounter extends StatelessWidget {
  final int taskCount;
  final int taskTotal;

  const GoalCounter({
    super.key,
    required this.taskCount,
    required this.taskTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: ySpacing, left: xSpacing, right: xSpacing),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: blueGradient,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          SleekCircularSlider(
            min: 0,
            max: 100,
            initialValue: (taskCount/taskTotal) * 100,
            appearance: CircularSliderAppearance(
              size: 60,
              customColors: CustomSliderColors(
                progressBarColor: whiteColor,
              ),
              infoProperties: InfoProperties(
                mainLabelStyle: const TextStyle(
                  color: whiteColor
                )
              )
            ),
          ),
          const SizedBox(width: 5,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Paragraph.normal('Tus metas diarias estan casi completas!', color: whiteColor,),
              Paragraph.subtitle('$taskCount de $taskTotal completas')
            ],
          )
        ],
      ),
    );
  }
}

class BorderContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const BorderContainer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: padding ?? const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: whiteColor,
          border: Border.all(
            color: grayColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15)
      ),
      child: child,
    );
  }

}