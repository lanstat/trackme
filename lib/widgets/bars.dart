import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackme/core/constants.dart';
import 'package:trackme/core/theme.dart';
import 'package:trackme/widgets/button.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget topLeftAction;
  final Widget topRightAction;
  final Widget? body;
  final Widget? footer;

  const TopBar({
    super.key,
    this.topLeftAction = emptyWidget,
    this.topRightAction = emptyWidget,
    this.body,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: grayColor,
                )
            ),
            color: whiteColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  topLeftAction,
                  topRightAction,
                ],
              ),
              body != null?
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: body,
              ):
              emptyWidget,
              footer != null?
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: footer,
              ):
              emptyWidget,
            ],
          ),
        )
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(160);
}

class SimpleTopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? topRightAction;
  final Widget? title;
  final Function()? onBack;
  final bool showBorder;

  const SimpleTopBar({
    super.key,
    this.onBack,
    this.topRightAction,
    this.title,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    BoxBorder? border;
    var list = <Widget>[];

    if (showBorder) {
      border = const Border(
        bottom: BorderSide(
          width: 1,
          color: grayColor,
        )
      );
    }

    if (onBack != null || title != null) {
      var tmp = <Widget>[];

      if (onBack != null) {
        tmp.add(ActionButton(
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
            size: kActionIconSize,
          ),
          onTap: () {
            Navigator.pop(context);
          }
        ));
      }
      if (title != null) {
        if (tmp.isNotEmpty) {
          tmp.add(const SizedBox(width: xSpacing,));
        }
        tmp.add(title as Widget);
      }
      list.add(Row(
        children: tmp,
      ));
    } else {
      list.add(emptyWidget);
    }
    if (topRightAction != null) {
      list.add(topRightAction as Widget);
    }

    return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: border,
              color: whiteColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: list,
                ),
              ],
            ),
          ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}
