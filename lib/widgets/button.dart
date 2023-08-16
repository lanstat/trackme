import 'package:flutter/material.dart';
import 'package:trackme/core/theme.dart';
import 'package:trackme/widgets/texts.dart';

class ActionButton extends StatelessWidget {
  final Widget icon;
  final void Function() onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(7),
          constraints: const BoxConstraints(
            minWidth: 30,
          ),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: grayColor,
              width: 1,
            ),
          ),
          child: Center(
            child: icon,
          ),
        ),
      )
    );
  }
}

class ToggleButton extends StatelessWidget {
  final Widget icon;
  final void Function() onTap;
  final bool active;
  final double? width;

  const ToggleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.active = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: active? blueColor: grayColor,
            width: 1,
          ),
        ),
        child: icon,
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String label;
  final void Function() onTap;
  final Color background;
  final Color foreground;
  final double? height;

  const MyButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.background,
    required this.foreground,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: background,
          border: Border.all(
            color: grayColor,
            width: 1,
          ),
        ),
        child: Center(
          child: Paragraph.title(
            label,
            color: foreground,
          ),
        ),
      ),
    );
  }

  factory MyButton.primary({
    required String label,
    required void Function() onTap,
    double? height,
  }) {
    return MyButton(
      label: label,
      onTap: onTap,
      height: height,
      background: blueColor,
      foreground: whiteColor,
    );
  }

  factory MyButton.secondary({required String label, required void Function() onTap}) {
    return MyButton(
      label: label,
      onTap: onTap,
      background: whiteColor,
      foreground: blackColor,
    );
  }
}
