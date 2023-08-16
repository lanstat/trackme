import 'package:flutter/material.dart';
import 'package:trackme/core/theme.dart';

class Headline extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const Headline({
    super.key,
    required this.text,
    required this.fontSize,
    required this.color,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize
      ),
    );
  }

  factory Headline.h1(String text, {Color? color}) {
    return Headline(
      text: text,
      fontSize: 48,
      color: color ?? blackColor,
    );
  }

  factory Headline.h2(String text, {Color? color}) {
    return Headline(
      text: text,
      fontSize: 40,
      color: color ?? blackColor,
    );
  }

  factory Headline.h3(String text, {Color? color}) {
    return Headline(
      text: text,
      fontSize: 36,
      color: color ?? blackColor,
    );
  }

  factory Headline.h4(String text, {Color? color}) {
    return Headline(
      text: text,
      fontSize: 32,
      color: color ?? blackColor,
    );
  }

  factory Headline.h5(String text, {Color? color}) {
    return Headline(
      text: text,
      fontSize: 24,
      color: color ?? blackColor,
    );
  }

  factory Headline.h6(String text, {Color? color}) {
    return Headline(
      text: text,
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: color ?? blackColor,
    );
  }
}

class Paragraph extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const Paragraph({
    super.key,
    required this.text,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.color = blackColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize
      ),
    );
  }

  factory Paragraph.title(String text, {
    Color color = blackColor,
  }) {
    return Paragraph(
      text: text,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  factory Paragraph.normal(String text, {
    Color color = blackColor
  }) {
    return Paragraph(
      text: text,
      fontSize: 14,
      color: color,
    );
  }

  factory Paragraph.subtitle(String text) {
    return Paragraph(
      text: text,
      fontSize: 12,
      color: grayColor,
    );
  }

  factory Paragraph.legend(String text) {
    return Paragraph(
      text: text.toUpperCase(),
      fontSize: 12,
      color: blackColor,
      fontWeight: FontWeight.bold,
    );
  }
}

class Link extends StatelessWidget {
  final String text;
  final void Function() onTap;

  const Link({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: blueColor,
          fontWeight: FontWeight.w500,
          fontSize: 12
        ),
      ),
    );
  }
}
