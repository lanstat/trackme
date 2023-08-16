import 'package:flutter/material.dart';

abstract class TileCompletable {
  String title();
  String subtitle();
  double count();
  double min();
  double max();
  IconData icon();
}

abstract class DataSerial {
  String tableName();
  int tableId();
  Map<String, dynamic> toMap();
}